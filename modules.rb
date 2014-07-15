require 'carrierwave'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    '/images/' + [version_name, 'default.png'].compact.join('_')
  end

  version :thumb do
    process resize_to_fill: [300, 200]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end