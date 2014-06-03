class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :meeting
      t.references :user
      t.integer :role, :limit => 1
      t.timestamps
    end
  end
end
