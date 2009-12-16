require 'RMagick'
require 'rubygems'
require 'sinatra'
require 'haml'
include Magick

def transform_image(image)
  image.resize_to_fit!(350, 350)
  image.background_color = '#FFFFFF00'
  image.vignette()
end

get '/' do
  haml :index
end

post '/' do
  path = Dir.pwd + '/public/uploads/'
  FileUtils.mkdir_p(path)
  if not params[:image1] or not params[:image2] or not params[:image3]
    return 'Please upload 3 images'
  end
  
  full_moon_path = Dir.pwd + '/images/Moon_BG.png'
  dest_filename = Time.new.to_i.to_s + '.gif'
  
  if image_list = ImageList.new(full_moon_path, params[:image1][:tempfile].path, params[:image2][:tempfile].path, params[:image3][:tempfile].path)
    image_list[0].page = Rectangle.new(800, 600, 0, 0)
    image_list[1] = transform_image(image_list[1])
    image_list[2] = transform_image(image_list[2])
    image_list[3] = transform_image(image_list[3])
    image_list[1].page = Rectangle.new(200, 200, 25, 25)
    image_list[2].page = Rectangle.new(200, 200, 75, 250)
    image_list[3].page = Rectangle.new(200, 200, 425, 350)
    result = image_list.flatten_images
    result.write(path + dest_filename)
    redirect '/result/' + dest_filename
  else
    return 'There was a problem uploading that.'
  end
end

get '/result/:filename' do
  @link = '/uploads/' + params[:filename]
  haml :result
end

def thingy
end