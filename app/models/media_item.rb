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

  scope :public_items, -> { where(is_private: false) }
  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }

  def self.search(user, name)
    if user && name
      for_user(user).by_name(name)
    elsif user
      for_user(user)
    elsif name
      public_items.by_name(name)
    else
      public_items
    end
  end

  def self.for_user(user)
    order = sanitize_sql_array(["user_id = ? DESC, is_private DESC", user.id])
    where("is_private = ? OR user_id = ?", false, user).order(order)
  end
end
