class CreateExperimentRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :experiment_records do |t|
      t.string :experimented_on, null: false
      t.string :name, null: false
      t.string :start_at
      t.string :end_at
      t.text :description
      t.string :required_time

      t.timestamps
    end
  end
end
