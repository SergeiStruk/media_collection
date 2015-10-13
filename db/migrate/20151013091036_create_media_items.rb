class CreateMediaItems < ActiveRecord::Migration
  def change
    create_table :media_items do |t|
      t.integer :user_id, null: false
      t.string  :name, null: false
      t.text    :url, null: false
      t.string  :media_type, null: false
      t.boolean :is_private, default: true, null: false

      t.timestamps
    end

    add_index :media_items, :user_id
    add_foreign_key :media_items, :users
  end
end
