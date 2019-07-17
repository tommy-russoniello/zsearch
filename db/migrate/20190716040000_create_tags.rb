class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table(:tags) do |table|
      table.string(:name, null: false)
      table.timestamps
      table.index(%i[name])
    end
  end
end
