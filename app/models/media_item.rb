require 'uri'

class MediaItem < ActiveRecord::Base
  belongs_to :user

  TYPES = %w[Website Video Image]

  validates :user,       presence:  true
  validates :name,       presence:  true
  validates :url,        presence:  true
  validates :is_private, inclusion: { in: [true, false] }
  validates :media_type, presence:  true, inclusion: { in: TYPES }

  validates_url :url, message: 'is invalid.'
end
