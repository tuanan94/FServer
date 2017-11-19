class CreateWatchings < ActiveRecord::Migration[5.1]
  def change
    create_table :watchings do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
