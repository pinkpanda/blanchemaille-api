require 'carrierwave/orm/activerecord'

class Newspaper < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  validates :newspaper_name,
            presence: true

  validates :title,
            presence: true
end

class Organization < ActiveRecord::Base
  validates :name,
            presence: true

  validates :type,
            presence: true
end

class Page < ActiveRecord::Base
  validates :title,
            presence: true
end

class Partner < ActiveRecord::Base
  validates :name,
            presence: true
end

class Work < ActiveRecord::Base
  validates :title,
            presence: true
end
