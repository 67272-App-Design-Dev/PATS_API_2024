class CreateAnimals < ActiveRecord::Migration[7.0]
  def change
    create_table :animals do |t|
      t.string :name
      t.boolean :active, default: true

      # t.timestamps
    end
  end
end
