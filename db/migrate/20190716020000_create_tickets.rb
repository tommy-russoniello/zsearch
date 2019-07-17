class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table(:tickets) do |table|
      table.string(:uuid, null: false)
      table.bigint(:assignee_id)
      table.text(:description)
      table.datetime(:due_at)
      table.string(:external_id, null: false)
      table.boolean(:has_incidents, default: false, null: false)
      table.bigint(:organization_id)
      table.integer(:priority, default: 0, null: false)
      table.integer(:status, default: 0, null: false)
      table.string(:subject, null: false)
      table.bigint(:submitter_id)
      table.integer(:ticket_type, default: 0)
      table.string(:url, limit: 1024, null: false)
      table.integer(:via, default: 0, null: false)
      table.timestamps
      table.index(%i[subject])
    end

    add_foreign_key(:tickets, :organizations)
    add_foreign_key(:tickets, :users)
  end
end
