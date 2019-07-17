class Ticket < ApplicationRecord
  enum priority: %i[low normal high urgent]
  enum status: %i[pending open hold closed solved]
  enum ticket_type: %i[task question problem incident]
  enum via: %i[chat voice web]

  belongs_to :assignee, class_name: :User, required: false
  belongs_to :organization, required: false
  belongs_to :submitter, class_name: :User, required: false

  has_many :ticket_tags

  has_many :tags, through: :ticket_tags

  class << self
    def has_many_attributes
      %w[tags]
    end

    def name_field
      'subject'
    end
  end

  def name_field
    subject
  end
end
