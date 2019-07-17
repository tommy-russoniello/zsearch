data = JSON.parse(
  File.read(Rails.root.join('db', 'data', 'users.json'))
)
user_tags = []

data.each do |user|
  user.each do |key, value|
    user[key] = ActiveSupport::Inflector.transliterate(value) if value.is_a?(String)
  end

  user[:id] = user.delete('_id')
  user['role'] &&= user['role'].tr(' -', '_')

  user.delete('tags')&.each do |tag|
    tag = ActiveSupport::Inflector.transliterate(tag).downcase if tag.is_a?(String)
    model = Tag.find_or_initialize_by(name: tag)
    model.save! if model.new_record?
    user_tags << { tag_id: model.id, user_id: user[:id] }
  end
end

User.create!(data)
UserTag.create!(user_tags)
