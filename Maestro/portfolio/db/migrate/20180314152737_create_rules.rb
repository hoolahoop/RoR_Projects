class CreateRules < ActiveRecord::Migration[5.1]
  def change
    create_table :rules do |t|
      t.string :email, default: "", null: false
      t.references :guest, foreign_key: true
      t.references :event, foreign_key: true
    end
  end
end
