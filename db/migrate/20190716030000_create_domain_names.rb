class CreateDomainNames < ActiveRecord::Migration[5.2]
  def change
    create_table(:domain_names) do |table|
      table.string(:name, null: false)
      table.timestamps
      table.index(%i[name])
    end
  end
end
