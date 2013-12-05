require 'digest/md5'

class Md5HashesController < ApplicationController
	def new
		@md5hash = Md5Hash.new
	end

	def create
		@md5hash = Md5Hash.new(params[:md5_hash])
		@md5hash.md5_value.downcase! 
		if @md5hash.save
			redirect_to md5_hash_path(@md5hash)
		else
			render :new
		end
	end

	def paste
		hashCount = 0;
		novelHashCount = 0;
		hashes = params[:paste_string].split()
		hashes.each do |hash|
			hashCount += 1
			md5hash = Md5Hash.new()
			md5hash.md5_value = hash.downcase
			if md5hash.save
				novelHashCount += 1
			end
		end
		flash[:notice] = hashCount.to_s() + " hashes" + " submitted and " + novelHashCount.to_s() + " were novel."
		redirect_to md5_hashes_path
	end

	def upload
		hashCount = 0;
		novelHashCount = 0;
		upload = params[:upload]
		datafile = upload[:datafile]
		tmpfile = datafile.tempfile
		while(hash = tmpfile.gets)
			hashCount += 1
			md5hash = Md5Hash.new()
			hash.downcase!
			hash.strip!
			md5hash.md5_value = hash
			if md5hash.save
				novelHashCount += 1
			end
		end
		flash[:notice] = hashCount.to_s() + " hashes" + " submitted and " + novelHashCount.to_s() + " were novel."
		redirect_to md5_hashes_path
	end

	def show
		@md5hash = Md5Hash.find_by_md5_value(params[:md5_value])
		if @md5hash == nil
			@md5hash = Md5Hash.new()
			@md5hash.md5_value = params[:md5_value]
			if !@md5hash.save
				render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
			end
		end
	end

	def index
		@md5hashes = Md5Hash.all(:order => 'updated_at DESC', :limit => 20)

	end

	def unsolved
		md5hashes = Md5Hash.where(:solved => false).where("md5_value IS NOT NULL")
		txt = ""
		md5hashes.each do |md5hash|
			txt += md5hash.md5_value + "\r\n"
		end
		render text: txt, content_type:"text/plain"
	end

	def stats
		@hashesCount = Md5Hash.count(:md5_value)
		@hashesSolved = Md5Hash.where("plain_text_id is not null").count(:md5_value)		
	end


end
