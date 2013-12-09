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

      Md5Hash.import_hashes_B(hashes)
      count
    end
  end
end
