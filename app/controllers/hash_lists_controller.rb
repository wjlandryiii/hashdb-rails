
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
		t1 = Time.now.to_f
		@hashList = HashList.find(params[:id])
		
		if @hashList
			upload = params[:upload]
			if(upload != nil)
				datafile = upload[:datafile]
				tmpfile = datafile.tempfile
				
				HashList.import_from_file(@hashList, tmpfile)
			end
			t2 = Time.now.to_f
			flash[:notice] = (t2-t1).to_s + " seconds."
			redirect_to hash_list_path @hashList
			#render "show"
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
