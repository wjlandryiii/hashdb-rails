
class HashListsController < ApplicationController
	def index
		@hashLists = HashList.all
	end

	def new
		@hashList = HashList.new
	end

	def create
		@hashList = HashList.new(params[:hash_list])
		if @hashList.save
			redirect_to hash_list_path(@hashList)
			#render 'show'
		else
			render 'new'
		end
	end

	def show
		@hashList = HashList.find(params[:id])
		offset = params[:offset] || 0
		@hashCount = @hashList.hash_list_hashes.count # HashListHash.where(hash_list_id: @hashList.id).count
		@hashesSolvedCount = @hashList.hash_list_hashes.joins("INNER JOIN md5_hashes ON hash_list_hashes.md5_hash_id = md5_hashes.id").where("md5_hashes.password IS NOT NULL").count
		if @hashList == nil
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		end
		@hashListHashes = @hashList.hash_list_hashes.paginate(:page => params[:page])
	end

	def edit
		@hashList = HashList.find(params[:id])
		if @hashList == nil
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		end
	end

	def upload_hashlist
		@hashList = HashList.find(params[:id])
		if @hashList
			hashCount = 0;
			novelHashCount = 0;
			savedHashCount = 0;
			upload = params[:upload]
			if(upload != nil)
				datafile = upload[:datafile]
				tmpfile = datafile.tempfile
				while(hash = tmpfile.gets)
					hash.force_encoding('UTF-8')
					hash.chomp!
				 	hash.downcase!
				 	hash.strip!
				 	if hash.length > 0
				 		hashCount += 1
					 	md5hash = Md5Hash.find_by_hex_hash(hash)
					 	if !md5hash
					 		novelHashCount += 1
					 		md5hash = Md5Hash.new
					 		md5hash.hex_hash = hash
					 		if !md5hash.save
					 			md5hash = nil;
					 		end
					 	end
					 	if md5hash
						 	hashListHash = HashListHash.new
						 	hashListHash.hash_list = @hashList
						 	hashListHash.md5_hash = md5hash
						 	if hashListHash.save
						 		savedHashCount += 1
						 	end
						end
					end
				end
			end
			flash[:notice] = hashCount.to_s() + " hashes submitted.  " + savedHashCount.to_s() + " hashes added to list and " +novelHashCount.to_s() + " hashes were novel."
			redirect_to hash_list_path @hashList
		end
	end

	def update
		@hashList = HashList.find(params[:id])
		if @hashList.update_attributes(params[:hash_list])
			redirect_to hash_list_path(@hashList)
		else
			render 'edit'
		end
	end

	def destroy
		@hashList = HashList.find(params[:id])
		@hashList.destroy
		redirect_to hash_lists_path
	end
end
