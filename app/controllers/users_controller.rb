class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		@md5hash = Md5Hash.find_by_md5_value(@user.md5_hash_value)
		if @md5hash.nil?
			@md5hash = Md5Hash.new
			@md5hash.md5_value = @user.md5_hash_value
			@md5hash.save
		end

		@user.md5_hash = @md5hash

		if @user.save
			redirect_to user_path(@user)
		else
			render :new
		end
	end

	def show
		@user = User.find_by_id(params[:id])
	end

	def index
		@users = User.joins(:md5_hash)
		@user_count = User.count
		@user_count_solved = User.joins(:md5_hash).where(md5_hashes: {solved: true}).count

	end

	def pasteuserhashes

	end

	def importuserhashes
		client = params[:client]
		userhashes = params[:paste_string].split("\r\n")
		userhashes.each do |userhash|
			username = userhash.split(":")[0]
			hashstring = userhash.split(":")[1]
			
			if !username.blank? && !hashstring.blank?
				user = User.new()
				user.name = username
				user.client = client

				md5hash = Md5Hash.find_by_md5_value(hashstring)
				if md5hash.nil?
					md5hash = Md5Hash.new
					md5hash.md5_value = hashstring
					md5hash.save
				end

				#Rails.logger("debug::" + md5hash.to_json)

				user.md5_hash = md5hash
				user.save
			end
		end
		redirect_to users_path
	end
end
