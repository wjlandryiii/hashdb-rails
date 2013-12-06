
class HashListsController < ApplicationController
	def index
		@hashLists = HashList.all(:order => 'updated_at DESC', :limit => 20)
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
		if @hashList == nil
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
		end
	end

	def edit
		@hashList = HashList.find(params[:id])
		if @hashList == nil
			render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
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
		@hashList.delete
		redirect_to hash_lists_path
	end
end
