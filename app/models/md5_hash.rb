class Md5Hash < ActiveRecord::Base
  attr_accessible :hex_hash, :password
  validates_uniqueness_of :hex_hash
  VALID_MD5_REGEX = /\A([0-9]|[a-f]){32}\z/i
  validates :hex_hash, format: {with: VALID_MD5_REGEX }

  before_save { |md5Hash| md5Hash.hex_hash = Digest::MD5.hexdigest(md5Hash.password).downcase!.strip! if md5Hash.hex_hash == nil}

  def to_param
  	hex_hash
  end

  class << self

    def import_hashes(hashes)
      hashes.in_groups_of(1000, false) { | hash_chunk |
        ActiveRecord::Base.transaction do
          knownHashes = Set.new
          md5hashes = Md5Hash.select(:hex_hash).order(:hex_hash).find_all_by_hex_hash(hash_chunk)

          md5hashes.each do | hash |
            knownHashes.add(hash.hex_hash)
          end

          newHashes = Set.new(hash_chunk)
          unKnownHashes = newHashes.subtract(knownHashes).to_a()
          unKnownHashes.map! {|x| [x]}
          Md5Hash.import([:hex_hash], unKnownHashes, :validate => false)
        end
      }
    end

    def import_hashes_B(hashes)
      connection = Md5Hash.connection()
      hashes.in_groups_of(1000, false) { | hash_chunk |

        knownHashes = Set.new
        md5hashes = Md5Hash.select(:hex_hash).order(:hex_hash).find_all_by_hex_hash(hash_chunk)

        md5hashes.each do | hash |
          knownHashes.add(hash.hex_hash)
        end

        newHashes = Set.new(hash_chunk)
        unKnownHashes = newHashes.subtract(knownHashes).to_a()
        unKnownHashes.map! {|x| [x]}
        Md5Hash.import([:hex_hash], unKnownHashes, :validate => false)

      }
    end

    def import_hashes_C(hashes)
      hashesSet = Set.new(hashes)
      knownHashesSet = Set.new()

      connection = ActiveRecord::Base.connection.raw_connection
      connection.prepare("my_hash_findall_by_hex_hash", "SELECT id, hex_hash, password FROM md5_hashes WHERE hex_hash IN ($1)")


      connection.exec("DEALLOCATE my_hash_findall_by_hex_hash")
    end

    def import_hashes_D(hashes)
      connection = ActiveRecord::Base.connection.raw_connection
      hashes_csv = hashes.join("\r\n")
      connection.transaction do
        connection.exec( "COPY md5_hashes (hex_hash) FROM STDIN WITH csv" )
        connection.put_copy_data(hashes_csv)
        connection.put_copy_end
      end
    end

    def import_hashes_E(hashes) #this is the ticket.  Imports eharmony.txt in about 60 seconds
      connection = ActiveRecord::Base.connection.raw_connection
      hashes_csv = hashes.join("\r\n")

      connection.transaction do
        connection.exec("CREATE TEMPORARY TABLE tmp_hashes (hex_hash varchar(64)) ON COMMIT DROP")
        #connection.exec("CREATE UNIQUE INDEX tmp_hashes_hex_hash_index ON tmp_hashes (hex_hash)")  #this index does not inprove proformance
        connection.exec("COPY tmp_hashes (hex_hash) FROM STDIN WITH csv" )
        connection.put_copy_data(hashes_csv)
        connection.put_copy_end
        connection.exec("INSERT INTO md5_hashes (hex_hash) SELECT t.hex_hash FROM tmp_hashes t LEFT JOIN md5_hashes h ON h.hex_hash = t.hex_hash WHERE h.hex_hash IS NULL")
      end

    end

    def import_from_file(file)
      count = 0
      hashes = Set.new
      while(hash = file.gets)
        hash.downcase!
        hash.strip!
        if hash.length == 32
          if VALID_MD5_REGEX.match(hash) != nil
            count += 1
            hashes.add(hash)
          end
        end
      end
      hashes = hashes.to_a()
      hashes.sort!

      t1 = Time.now.to_f
      Md5Hash.import_hashes_E(hashes)
      t2 = Time.now.to_f
      Rails.logger.debug("!!!!! import time: " + (t2 - t1).to_s + "seconds")
      count
    end

    def export_unsolved_hashes_to_file(file)
      connection = ActiveRecord::Base.connection.raw_connection
      buff = ''
      connection.transaction do
        connection.exec "COPY (SELECT hex_hash FROM md5_hashes WHERE password IS NULL) TO STDOUT CSV" 
        file.write(buff) while buff = connection.get_copy_data()
      end
      file.flush()
    end

    def import_passwords_naive_solution(passwords)
      passwords.each do | password |
        hash = Digest::MD5.hexdigest(password)

        md5hash = Md5Hash.find_by_hex_hash hash
        if md5hash
          md5hash.password = password
          md5hash.save
        else
          md5hash = Md5Hash.new
          md5hash.hex_hash = hash
          md5hash.password = password
          md5hash.save
        end
      end
    end

    def import_passwords_naive_solution2(passwords)
      connection = ActiveRecord::Base.connection.raw_connection

      connection.prepare("my_hash_lookup", "SELECT id, hex_hash, password FROM md5_hashes WHERE hex_hash = $1 LIMIT 1")
      connection.prepare("my_hash_update", "UPDATE md5_hashes SET password = $1 WHERE hex_hash = $2")
      connection.prepare("my_hash_create", "INSERT INTO md5_hashes (hex_hash, password) VALUES ($1, $2)")

      passwords.each do | password |
        hash = Digest::MD5.hexdigest(password)
        
        hr = connection.exec_prepared("my_hash_lookup", [hash])
        if hr.first != nil
          if hr[0][:password] == nil
            connection.exec_prepared("my_hash_update", [password, hash])
          end
        else
          connection.exec_prepared("my_hash_create", [hash, password])
        end
      end

      connection.exec("DEALLOCATE my_hash_lookup")
      connection.exec("DEALLOCATE my_hash_update")
      connection.exec("DEALLOCATE my_hash_create")
    end

    def import_passwords_naive_solution3(passwords)

      passwordSet = Set.new(passwords)
      connection = ActiveRecord::Base.connection.raw_connection

      connection.prepare("my_hash_lookup", "SELECT id, hex_hash, password FROM md5_hashes WHERE hex_hash = $1 LIMIT 1")
      connection.prepare("my_hash_findall_by_password", "SELECT id, hex_hash, password FROM md5_hashes WHERE password IN ($1)")
      connection.prepare("my_hash_findall_by_hex_hash", "SELECT id, hex_hash, password FROM md5_hashes WHERE hex_hash IN ($1)")
      connection.prepare("my_hash_update", "UPDATE md5_hashes SET password = $1 WHERE hex_hash = $2")
      connection.prepare("my_hash_create", "INSERT INTO md5_hashes (hex_hash, password) VALUES ($1, $2)")
      connection.prepare("my_hash_create_bulk", "INSERT INTO md5_hashes (hex_hash, password) VALUES (($1,$2))")

      hr = connection.exec_prepared("my_hash_findall_by_password", [passwordSet.to_a()])

      hr.each do | row |
        passwordSet.delete(row[:password])
      end

      passwords = passwordSet.to_a()

      hashes = {}

      allHashes = Set.new()
      passwords.each do | password |
        hash = Digest::MD5.hexdigest(password).downcase
        hashes[hash] = password
        allHashes.add(hash)
      end

      updateHashes = Set.new()
      hr = connection.exec_prepared("my_hash_findall_by_hex_hash", [hashes.keys])
      hr.each do | row |
        updateHashes.add(hr[:hex_hash])
      end

      insertHashes = allHashes.subtract(updateHashes)

      insertTuples = insertHashes.to_a.map { | hash | [hash, hashes[hash]]}

      connection.exec_prepared("my_hash_create_bulk", [insertTuples])

      updateHashes.each do | hash |
        connection.exec_prepared("my_hash_update", [hashes[hash], hash])
      end


      connection.exec("DEALLOCATE my_hash_lookup")
      connection.exec("DEALLOCATE my_hash_findall_by_password")
      connection.exec("DEALLOCATE my_hash_findall_by_hex_hash")
      connection.exec("DEALLOCATE my_hash_update")
      connection.exec("DEALLOCATE my_hash_create")
      connection.exec("DEALLOCATE my_hash_create_bulk")
    end


    def import_passwords(passwords)
      Md5Hash.import_passwords_naive_solution2(passwords)
    end

    def import_passwords_from_file(fileName)
      count = 0
      file = File.open(fileName, "r:UTF-8")
      Rails.logger.debug("File: " + file.to_s)
      passwords = Set.new
      while(password = file.gets)
        password.chomp!
        count += 1
        passwords.add(password)
      end
      Rails.logger.debug("Password Count: " + count.to_s)
      file.close
      Md5Hash.import_passwords(passwords.to_a)
      count
    end

    def export_passwords_to_file(file)
      connection = ActiveRecord::Base.connection.raw_connection
      buff = ''
      connection.transaction do
        connection.exec "COPY (SELECT password FROM md5_hashes WHERE password IS NOT NULL) TO STDOUT CSV" 
        file.write(buff) while buff = connection.get_copy_data()
      end
      file.flush()
    end
  end
end
