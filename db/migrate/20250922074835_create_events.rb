class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title, null:false
      t.text :description, null:false
      t.datetime :event_date, null:false
      t.string :organizer_name, null:false
      t.string :target_departments, null:false
      t.references :user, null: false, foreign_key: true
      t.string :public_token

      t.timestamps
    end
  end
end
