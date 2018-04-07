class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.string :email, default: "", null: false
      t.string :first_name, default: "", null: false
      t.string :last_name, default: "", null: false
      t.references :event, foreign_key: true
    end
  end
end
