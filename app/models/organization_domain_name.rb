class OrganizationDomainName < ApplicationRecord
  belongs_to :domain_name
  belongs_to :organization
end
