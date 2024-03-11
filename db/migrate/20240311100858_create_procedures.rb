class CreateProcedures < ActiveRecord::Migration[7.0]
  def change
    create_table :procedures do |t|
      t.string :name
      t.text :description
      t.integer :length_of_time
      t.boolean :active, default: true

      # t.timestamps
    end
  end
end
