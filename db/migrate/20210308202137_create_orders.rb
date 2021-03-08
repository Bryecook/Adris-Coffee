class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :client_id
      t.integer :drink_id
      t.integer :location_id
    end
  end
end
