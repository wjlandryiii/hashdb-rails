require 'digest/md5'

class Md5HashesController < ApplicationController
	def new

	end

	def paste_hashes
		hashCount = 0;
		novelHashCount = 0;
		hashes = params[:paste_string].split()
		hashes.each do |hash|
			hashCount += 1
			md5hash = Md5Hash.new()
			md5hash.hex_hash = hash.downcase
			if md5hash.save
				novelHashCount += 1
			end
		end
		flash[:notice] = hashCount.to_s() + " hashes" + " submitted and " + novelHashCount.to_s() + " were novel."
		redirect_to md5_hashes_path
	end

	def paste_passwords
		passwordCount = 0
		solvedHashCount = 0
		novelPasswordCount = 0
		novelHashCount = 0
		passwords = params[:paste_string].split()
		passwords.each do |password|
			passwordCount += 1
			password.chomp!
			md5hash = Md5Hash.find_by_password(password)
			if !md5hash
				novelPasswordCount += 1
				hex_hash = Digest::MD5.hexdigest(password)
				md5hash = Md5Hash.find_by_hex_hash(hex_hash)
				if md5hash
					solvedHashCount += 1
					md5hash.password = password
				else
					novelHashCount += 1
					md5hash = Md5Hash.new
					md5hash.hex_hash = hex_hash
					md5hash.password = password
					md5hash.save
				end
			end
		end
		flash[:notice] = passwordCount.to_s() + " passwords" + " submitted and " + novelHashCount.to_s() + " were novel.  " + novelHashCount.to_s() + "  novel hashes were added and " + solvedHashCount.to_s() + " known hashes were solved."
		redirect_to md5_hashes_path
	end

	def upload_hashes
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
			md5hash.hex_hash = hash
			if md5hash.save
				novelHashCount += 1
			end
		end
		flash[:notice] = hashCount.to_s() + " hashes" + " submitted and " + novelHashCount.to_s() + " were novel."
		redirect_to md5_hashes_path
	end

	def upload_passwords
		passwordCount = 0
		solvedHashCount = 0
		novelPasswordCount = 0
		novelHashCount = 0
		upload = params[:upload]
		datafile = upload[:datafile]
		tmpfile = datafile.tempfile
		while(password = tmpfile.gets)
			passwordCount += 1
			password.force_encoding('UTF-8')
			password.chomp!
			md5hash = Md5Hash.find_by_password(password)
			if !md5hash
				novelPasswordCount += 1
				hex_hash = Digest::MD5.hexdigest(password)
				md5hash = Md5Hash.find_by_hex_hash(hex_hash)
				if md5hash
					solvedHashCount += 1
					md5hash.password = password
				else
					novelHashCount += 1
					md5hash = Md5Hash.new
					md5hash.hex_hash = hex_hash
					md5hash.password = password
					md5hash.save
				end
			end
		end
		flash[:notice] = passwordCount.to_s() + " passwords" + " submitted and " + novelHashCount.to_s() + " were novel.  " + novelHashCount.to_s() + "  novel hashes were added and " + solvedHashCount.to_s() + " known hashes were solved."
		redirect_to md5_hashes_path
	end

	def show
		@md5hash = Md5Hash.find_by_hex_hash(params[:hex_hash])
		if @md5hash == nil
			@md5hash = Md5Hash.new()
			@md5hash.hex_hash = params[:hex_hash]
			if !@md5hash.save
				render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
			end
		end
	end

	def index
		@md5hashes = Md5Hash.all(:order => 'updated_at DESC', :limit => 20)
	end

	def unsolved
		md5hashes = Md5Hash.where("password IS NULL")
		txt = ""
		md5hashes.each do |md5hash|
			txt += md5hash.hex_hash + "\r\n"
		end
		render text: txt, content_type:"text/plain"
	end

	def wordlist
		md5hashes = Md5Hash.where("password IS NOT NULL")
		txt = ""
		md5hashes.each do |md5hash|
			txt += md5hash.password + "\r\n"
		end
		render text: txt, content_type:"text/plain"
	end

	def stats
		@hashesCount = Md5Hash.count(:hex_hash)
		@hashesSolved = Md5Hash.where("password is not null").count(:hex_hash)		
	end

	def deleteall
		Md5Hash.delete_all
		redirect_to md5_hashes_path
	end
end
