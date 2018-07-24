class CreatePerformances < ActiveRecord::Migration[5.0]
  def change
    create_table :performances do |t|
      t.integer :blog_id
      t.integer :page_speed_score
      t.integer :yslow_score
      t.float :load_time
      t.integer :page_size
      t.integer :total_requests

      t.timestamps
    end
  end
end
