class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :my_poll, index: true
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :questions, :my_polls
  end
end
