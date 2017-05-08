class CreateTicks < ActiveRecord::Migration[5.1]
  def change
    create_table "ticks" do |t|
      t.datetime "at"
    end
  end
end
