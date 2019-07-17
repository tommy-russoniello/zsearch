class Organization < ApplicationRecord
  has_many :organization_domain_names
  has_many :organization_tags
  has_many :tickets
  has_many :users

  has_many :domain_names, through: :organization_domain_names
  has_many :tags, through: :organization_tags

  class << self
    def has_many_attributes
      %w[domain_names tags]
    end

    def name_field
      'name'
    end
  end

  def name_field
    name
  end
end
