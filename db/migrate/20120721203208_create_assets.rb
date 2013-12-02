class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string   :attachment_file_name
      t.integer  :uploadable_id
      t.string   :uploadable_type,      limit: 25
      t.string   :type,                 limit: 25
      t.integer  :position
      t.text     :description

      t.timestamps
    end

    add_index :assets, :position
    add_index :assets, [:uploadable_id, :uploadable_type, :type]

  end
end