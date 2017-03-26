class CreateMyPolls < ActiveRecord::Migration
  def change
    create_table :my_polls do |t|
      t.references :user, index: true
      t.datetime :expires_at
      t.string :title
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :my_polls, :users
  end
end
