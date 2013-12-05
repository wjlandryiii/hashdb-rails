class PlainTextController < ApplicationController
  def new
    @plainText = PlainText.new
  end

  def create
    @plainText = PlainText.new(params[:plain_text])
    md5Hash = Md5Hash.find_or_create_from_plaintext(@plainText.plainTextString)
    @plainText.md5_hash = md5Hash
    if @plainText.save
      redirect_to plain_text_path(@plainText)
    else
      render :new
    end
  end

  def paste
    plainTextCount = 0;
    novelPlainTextCount = 0;
    plainTextStrings = params[:paste_string].split()
    plainTextStrings.each do |plainTextString|
      plainTextCount += 1
      plainText = PlainText.new
      plainText.plainTextString = plainTextString
      md5hash = Md5Hash.find_or_create_from_plaintext(plainTextString)
      plainText.md5_hash = md5hash
      if plainText.save
        novelPlainTextCount += 1
      end
    end
    flash[:notice] = plainTextCount.to_s() + " plain text strings submitted and " + novelPlainTextCount.to_s() + " were novel."
    redirect_to plain_texts_path
  end

  def upload
    plainTextCount = 0;
    novelPlainTextCount = 0;
    upload = params[:upload]
    datafile = upload[:datafile]
    tmpfile = datafile.tempfile
    while(plainTextString = tmpfile.gets)
      plainTextString.chomp!
      plainTextCount += 1
      plainText = PlainText.new
      plainText.plainTextString = plainTextString
      md5hash = Md5Hash.find_or_create_from_plaintext(plainTextString)
      plainText.md5_hash = md5hash
      if plainText.save
        novelPlainTextCount += 1
      end
    end
    flash[:notice] = plainTextCount.to_s() + " plain text strings submitted and " + novelPlainTextCount.to_s() + " were novel."
    redirect_to plain_texts_path
  end

  def index
    @plainTexts = PlainText.all(:order => 'updated_at DESC', :limit => 20)
  end

  def show
    @plainText = PlainText.find_by_id(params[:id])
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
