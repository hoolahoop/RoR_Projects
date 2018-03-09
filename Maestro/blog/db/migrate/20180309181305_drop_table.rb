class DropTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :event_users
  end
end
