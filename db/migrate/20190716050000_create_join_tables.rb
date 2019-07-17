class CreateJoinTables < ActiveRecord::Migration[5.2]
  def change
    create_table(:organization_domain_names) do |table|
      table.bigint(:domain_name_id, null: false)
      table.bigint(:organization_id, null: false)
      table.timestamps
      table.index(%i[domain_name_id])
      table.index(
        %i[organization_id domain_name_id],
        name: 'idx_organization_domain_names_on_organization_and_domain_name',
        unique: true
      )
    end

    add_foreign_key(:organization_domain_names, :domain_names)
    add_foreign_key(:organization_domain_names, :organizations)

    create_table(:organization_tags) do |table|
      table.bigint(:organization_id, null: false)
      table.bigint(:tag_id, null: false)
      table.timestamps
      table.index(%i[organization_id tag_id], unique: true)
      table.index(%i[tag_id])
    end

    add_foreign_key(:organization_tags, :organizations)
    add_foreign_key(:organization_tags, :tags)

    create_table(:user_tags) do |table|
      table.bigint(:tag_id, null: false)
      table.bigint(:user_id, null: false)
      table.timestamps
      table.index(%i[tag_id])
      table.index(%i[user_id tag_id], unique: true)
    end

    add_foreign_key(:user_tags, :tags)
    add_foreign_key(:user_tags, :users)

    create_table(:ticket_tags) do |table|
      table.bigint(:tag_id, null: false)
      table.bigint(:ticket_id, null: false)
      table.timestamps
      table.index(%i[tag_id])
      table.index(%i[ticket_id tag_id], unique: true)
    end

    add_foreign_key(:ticket_tags, :tags)
    add_foreign_key(:ticket_tags, :tickets)
  end
end
