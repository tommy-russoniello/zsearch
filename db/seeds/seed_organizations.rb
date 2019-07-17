data = JSON.parse(
  File.read(Rails.root.join('db', 'data', 'organizations.json'))
)
organization_domain_names = []
organization_tags = []

data.each do |organization|
  organization.each do |key, value|
    organization[key] = ActiveSupport::Inflector.transliterate(value) if value.is_a?(String)
  end

  organization[:id] = organization.delete('_id')

  organization.delete('domain_names')&.each do |domain_name|
    domain_name = ActiveSupport::Inflector.transliterate(domain_name) if domain_name.is_a?(String)
    model = DomainName.find_or_initialize_by(name: domain_name)
    model.save! if model.new_record?
    organization_domain_names << { domain_name_id: model.id, organization_id: organization[:id] }
  end

  organization.delete('tags')&.each do |tag|
    tag = ActiveSupport::Inflector.transliterate(tag).downcase if tag.is_a?(String)
    model = Tag.find_or_initialize_by(name: tag)
    model.save! if model.new_record?
    organization_tags << { tag_id: model.id, organization_id: organization[:id] }
  end
end

Organization.create!(data)
OrganizationDomainName.create!(organization_domain_names)
OrganizationTag.create!(organization_tags)
