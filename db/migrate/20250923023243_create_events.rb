class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :event_date
      t.string :organizer_name
      t.string :target_departments
      t.references :user, null: false, foreign_key: true
      t.string :public_token

      t.timestamps
    end
  end
end
