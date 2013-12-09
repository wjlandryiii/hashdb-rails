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
      knownHashes = Set.new
      hashesB = Set.new(hashes)
      md5hashes = Md5Hash.select(:hex_hash).order(:hex_hash).find_all_by_hex_hash(hashes)

      md5hashes.each do | hash |
        knownHashes.add(hash.hex_hash)
      end

      unKnownHashes = hashesB.subtract(knownHashes)
      unKnownHashes = unKnownHashes.to_a()
      unKnownHashes.map! { |x| [x]}
      Md5Hash.import([:hex_hash], unKnownHashes, :validate => false)
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

      hashes.in_groups_of(5000, false) { |hash_chunk|
        Md5Hash.import_hashes(hash_chunk)
      }
      count
    end


  	def find_or_create_from_hex_hash(hex_hash)
			hex_hash.strip!
			hex_hash.downcase!
			md5Hash = Md5Hash.find_by_md5_value(hex_hash)
			if md5Hash == nil
				md5Hash = Md5Hash.new
				md5Hash.hex_hash = hex_hash
				md5Hash.save!
			end
			return md5Hash
  	end

  	def find_or_create_from_password(s)
  		hex_hash = Digest::MD5.hexdigest(s)
  		return Md5Hash.find_or_create(hex_hash)
  	end
  end
end
