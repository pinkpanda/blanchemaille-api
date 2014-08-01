require 'carrierwave/orm/activerecord'

class Newspaper < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  mount_uploader :image, ImageUploader

  validates :title,
            presence: true
end

class Organization < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  mount_uploader :image, ImageUploader

  validates :name,
            presence: true

  validates :sector,
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

class User < ActiveRecord::Base
  validates :email,
            presence: true,
            uniqueness: true

  validates :firstname,
            presence: true

  validates :lastname,
            presence: true

  validates :password,
            presence: true

  before_create :set_token

  def set_token
    self.authentication_token = SecureRandom.urlsafe_base64
    until User.find_by(authentication_token: self.authentication_token).nil?
      self.authentication_token = SecureRandom.urlsafe_base64
    end
  end
end

class Work < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title,
            presence: true

  validates :worked_at,
            presence: true
end
