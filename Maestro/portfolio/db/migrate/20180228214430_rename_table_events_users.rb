class RenameTableEventsUsers < ActiveRecord::Migration[5.1]
  def change
	rename_table :events_users, :event_users
  end
end