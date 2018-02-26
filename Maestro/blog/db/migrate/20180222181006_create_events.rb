class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name,              null: false, default: ""
      t.text :description,         null: true
      t.integer :option,           null: false, default: 1
      t.string :street_address,    null: true
      t.integer :apartment_number, null: true
      t.string :city,              null: true
      t.date :date,                null: true
      t.time :time,                null: true
      t.string :password,          null: false, default: ""
      t.references :user, foreign_key: true
    end
  end
end
