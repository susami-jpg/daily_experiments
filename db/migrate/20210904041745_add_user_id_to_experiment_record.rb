class AddUserIdToExperimentRecord < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM experiment_records;'
    add_reference :experiment_records, :user, null: false, index: true
  end

  def down
    remove_reference :experiment_records, :user, index: true
  end
end
