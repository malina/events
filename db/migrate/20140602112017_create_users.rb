class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :name, :null => false
      t.string :email,            :null => false
      t.integer :gender, :limit => 1 
      t.integer :age, :limit => 2 
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false
      t.string :remember_me_token, :default => nil
      t.datetime :remember_me_token_expires_at, :default => nil
      t.string :reset_password_token, :default => nil
      t.datetime :reset_password_token_expires_at, :default => nil
      t.datetime :reset_password_email_sent_at, :default => nil

      t.timestamps
    end

    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
    add_index :users, [:gender, :age]

  end

end