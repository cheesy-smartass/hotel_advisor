class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :comment, index: true
      t.references :user, index: true
      t.integer :score
      t.string :default
      t.string :nil

      t.timestamps
    end
  end
end
