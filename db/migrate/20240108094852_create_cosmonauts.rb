class CreateCosmonauts < ActiveRecord::Migration[7.1]
  def change
    create_table :cosmonauts do |t|
      t.string :first_name
      t.string :last_name
      t.string :physical_condition
      t.string :mental_endurance

      t.timestamps
    end
  end
end
