class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table(:organizations) do |table|
      table.string(:details)
      table.string(:external_id, null: false)
      table.string(:name, null: false)
      table.boolean(:shared_tickets, default: false, null: false)
      table.string(:url, limit: 1024, null: false)
      table.timestamps
      table.index(%i[name])
    end
  end
end
