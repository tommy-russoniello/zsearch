class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table(:users) do |table|
      table.boolean(:active, default: true, null: false)
      table.string(:alias)
      table.string(:email)
      table.string(:external_id, null: false)
      table.datetime(:last_login_at, null: false)
      table.string(:locale)
      table.string(:name, null: false)
      table.bigint(:organization_id)
      table.string(:phone, null: false)
      table.integer(:role, default: 0, null: false)
      table.boolean(:shared, default: false, null: false)
      table.string(:signature, limit: 512, null: false)
      table.boolean(:suspended, default: false, null: false)
      table.string(:timezone)
      table.string(:url, limit: 1024, null: false)
      table.boolean(:verified, default: false, null: false)
      table.timestamps
      table.index(%i[name])
    end

    add_foreign_key(:users, :organizations)
  end
end
