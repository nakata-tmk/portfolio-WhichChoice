class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :body
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
