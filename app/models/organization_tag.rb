class OrganizationTag < ApplicationRecord
  belongs_to :organization
  belongs_to :tag
end
