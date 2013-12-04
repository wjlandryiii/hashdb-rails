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

	def pastehashes

	end

	def importhashes
		hashes = params[:paste_string].split()
		hashes.each do |hash|
			md5hash = Md5Hash.new()
			md5hash.md5_value = hash.downcase
			md5hash.save
		end
		redirect_to md5_hashes_path
	end

	def uploadhashes
		#just show html
	end

	def upload
		upload = params[:upload]
		datafile = upload[:datafile]
		tmpfile = datafile.tempfile
		while(hash = tmpfile.gets)
			md5hash = Md5Hash.new()
			md5hash.md5_value = hash.downcase
			md5hash.save
		end
		redirect_to md5_hashes_path
	end

	def pastesolutions

	end

	def importsolutions
		new_solutions = 0
		hashes_solved = 0
		solutions = params[:paste_string].split("\r\n")
		solutions.each do |solution|
			hash = Digest::MD5.hexdigest(solution)
			md5hash = Md5Hash.find_by_md5_value(hash)
			if md5hash.nil?
				md5hash = Md5Hash.new
				md5hash.md5_value = hash
				new_solutions = new_solutions + 1
			elsif !md5hash.solved?
				hashes_solved = hashes_solved + 1
			end
			md5hash.solved = true
			md5hash.solution = solution
			md5hash.save
		end
		flash[:notice] = "There are " + new_solutions.to_s + " new hashes.  "
		flash[:notice] << "There are " + hashes_solved.to_s + " hashes solved." 
		redirect_to md5_hashes_path
	end

	def edit

	end

	def update
		@md5hash = Md5Hash.find(params[:id])
		if Digest::MD5.hexdigest(params[:md5_hash][:solution]) == @md5hash.md5_value
			@md5hash.solved = true
			@md5hash.solution = params[:md5_hash][:solution]
			@md5hash.save()
			redirect_to md5_hash_path(@md5hash)
		else
			render :edit
		end
	end

	def show
		@md5hash = Md5Hash.find_by_id(params[:id])
	end

	def index
		@md5hashes = Md5Hash.all(:order => 'updated_at DESC', :limit => 100)
	end

	def unsolved
		md5hashes = Md5Hash.where(:solved => false).where("md5_value IS NOT NULL")
		txt = ""
		md5hashes.each do |md5hash|
			txt += md5hash.md5_value + "\r\n"
		end

		render text: txt, content_type:"text/plain"
	end

	def wordlist
		md5hashes = Md5Hash.where("solution IS NOT NULL").order(:solution)
		txt = ""
		md5hashes.each do |md5hash|
			txt += md5hash.solution + "\r\n"
		end

		render text: txt, content_type:"text/plain"
	end
end
