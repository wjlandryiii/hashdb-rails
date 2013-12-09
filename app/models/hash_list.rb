class HashList < ActiveRecord::Base
	attr_accessible :title, :description
	has_many :hash_list_hashes, :dependent => :delete_all

  VALID_MD5_REGEX = /\A([0-9]|[a-f]){32}\z/i

  class << self

    def import_hashes(hashList, hashes)
      hashIds = {}
      hashesSet = Set.new(hashes)
      dedupedHashes = hashesSet.to_a()
      dedupedHashes.in_groups_of(1000, false) { | hash_chunk |
        ActiveRecord::Base.transaction do
          knownHashes = Set.new
          md5hashes = Md5Hash.select("id, hex_hash").order(:hex_hash).find_all_by_hex_hash(hash_chunk)

          md5hashes.each do | hash |
            knownHashes.add(hash.hex_hash)
            hashIds[hash] = hash.id
          end

          newHashes = Set.new(hash_chunk)
          unKnownHashes = newHashes.subtract(knownHashes).to_a()
          unKnownHashes.map! {|x| [x]}
          Md5Hash.import([:hex_hash], unKnownHashes, :validate => false)
          md5hashes = Md5Hash.select("id, hex_hash").order(:hex_hash).find_all_by_hex_hash(hash_chunk)
          md5hashes.each do | hash |
            hashIds[hash] = hash.id
          end
        end
      }


      id = hashList.id
      md5hashes = Md5Hash.find_all_by_hex_hash(dedupedHashes)
      
      md5hashes.map {|hash| hashIds[hash.hex_hash] = hash.id }


      hashes.in_groups_of(5000, false) { | hash_chunk |
        ActiveRecord::Base.transaction do

            listHashes = Array.new
            hash_chunk.each do | hash |
              #md5hash = Md5Hash.find_by_hex_hash(hash)
              listHash = HashListHash.new
              listHash.hash_list_id = id
              #listHash.md5_hash = md5hash
              listHash.md5_hash_id = hashIds[hash]
              listHashes += [listHash]
            end
          HashListHash.import(listHashes)
        end
      }
    end

  	def import_from_file(hashList, file)
  		hashes = Array.new

  		while(hash = file.gets)
        hash.downcase!
        hash.strip!
        if hash.length == 32
          if VALID_MD5_REGEX.match(hash) != nil
       	    hashes += [hash]
          end
        end
     	end

      HashList.import_hashes(hashList, hashes)
  	end
  end
end