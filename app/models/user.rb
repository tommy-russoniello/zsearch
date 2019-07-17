class User < ApplicationRecord
  enum role: %i[end_user agent admin]

  belongs_to :organization, required: false

  has_many :tickets
  has_many :user_tags

  has_many :tags, through: :user_tags

  class << self
    def has_many_attributes
      %w[tags]
    end

    def name_field
      'name'
    end
  end

  def name_field
    name
  end
end
