data = JSON.parse(
  File.read(Rails.root.join('db', 'data', 'tickets.json'))
)
ticket_tags = []

data.each do |ticket|
  ticket.each do |key, value|
    ticket[key] = ActiveSupport::Inflector.transliterate(value) if value.is_a?(String)
  end

  ticket[:ticket_type] = ticket.delete('type')
  ticket[:uuid] = ticket.delete('_id')
  ticket['priority'] &&= ticket['priority'].tr(' -', '_')
  ticket['status'] &&= ticket['status'].tr(' -', '_')
  ticket['type'] &&= ticket['type'].tr(' -', '_')
  ticket['via'] &&= ticket['via'].tr(' -', '_')

  ticket.delete('tags')&.each do |tag|
    tag = ActiveSupport::Inflector.transliterate(tag).downcase if tag.is_a?(String)
    model = Tag.find_or_initialize_by(name: tag)
    model.save! if model.new_record?
    ticket_tags << { tag_id: model.id, ticket_id: ticket[:uuid] }
  end
end

Ticket.create!(data)

ticket_tags.each do |ticket_tag|
  ticket_tag[:ticket_id] = Ticket.where(uuid: ticket_tag[:ticket_id]).pluck(:id).first
end
TicketTag.create!(ticket_tags)
