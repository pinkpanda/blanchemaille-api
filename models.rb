require 'carrierwave/orm/activerecord'

class Newspaper < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  mount_uploader :image, ImageUploader

  validates :newspaper_name,
            presence: true

  validates :title,
            presence: true
end

class Organization < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  mount_uploader :image, ImageUploader

  validates :name,
            presence: true
end

class Page < ActiveRecord::Base
  validates :slug,
          presence: true

  validates :title,
            presence: true
end

class Partner < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  mount_uploader :image, ImageUploader

  validates :name,
            presence: true
end

class Work < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title,
            presence: true
end
