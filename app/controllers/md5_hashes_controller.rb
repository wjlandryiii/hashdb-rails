require 'digest/md5'
require 'pager'

class Md5HashesController < ApplicationController
	def index
		@md5hashes = Md5Hash.paginate(:page => params[:page])

		# @pager = Pager.new(Md5Hash.count(), params[:page], 15)

		# @itemsPerPage = 1
		# @itemCount = Md5Hash.count
		# @pageCount = @pager.pageCount() #@itemCount / @itemsPerPage + (@itemCount % @itemsPerPage == 0 ? 0 : 1)
		# @page = params[:page].to_i
		# @pageCountOffset = 0

		# if @page == 0
		# 	@pageCountOffset = 2
		# elsif @page == 1
		# 	@pageCountOffset = 1
		# end

		# if @page == @pageCount - 1
		# 	@pageCountOffset = -2
		# elsif @page == @pageCount - 2
		# 	@pageCountOffset = -1
		# end

		# @pageItem0 = @page + @pageCountOffset - 2
		# @pageItem1 = @page + @pageCountOffset - 1
		# @pageItem2 = @page + @pageCountOffset
		# @pageItem3 = @page + @pageCountOffset + 1
		# @pageItem4 = @page + @pageCountOffset + 2

		# #@md5hashes = Md5Hash.offset(@page*@itemsPerPage).limit(@itemsPerPage).reorder(:updated_at)
		# @md5hashes = Md5Hash.offset(@pager.offset()).limit(@pager.limit()).reorder(:updated_at)
	end

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
					md5hash.save
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
		upload = params[:upload]
		datafile = upload[:datafile]
		tmpfile = datafile.tempfile

		t1 = Time.now.to_f
		count = Md5Hash.import_from_file(tmpfile)
		t2 = Time.now.to_f

		flash[:notice] = count.to_s + " hashes in " + (t2 - t1).to_s + " seconds"
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
					md5hash.save
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



	def unsolved
		t1 = Time.now.to_f

		connection = ActiveRecord::Base.connection()
		sql = "SELECT hex_hash FROM md5_hashes WHERE password IS NULL"
		results = connection.execute(sql)
		unsolved = results.map { |x| x["hex_hash"]}
		txt = unsolved.join("\r\n")

		t2 = Time.now.to_f
		#txt +=  (t2-t1).to_s + "\r\n"

		render text: txt, content_type:"text/plain"
	end

	def wordlist
		t1 = Time.now.to_f

		connection = ActiveRecord::Base.connection()
		sql = "SELECT password FROM md5_hashes WHERE password IS NOT NULL"
		results = connection.execute(sql)
		passwords = results.map { |x| x["password"]}
		txt = passwords.join("\r\n")

		t2 = Time.now.to_f

		#txt +=  (t2-t1).to_s + "\r\n"
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
