Sequel.migration do

  change do
    create_table(:bitstamp) do
      primary_key :id
      index :exchange_name
      index :pair
      index :timestamp

      String   :exchange_name,    null:     false
      Integer  :year,             null:     false
      String   :pair,             null:     false

      Float     :high
      Float     :low
      Float     :avg
      Float     :volume
      Float     :vol_cur
      Float     :last
      Float     :bid
      Float     :ask
      DateTime  :timestamp
      DateTime  :created_at
      Float     :vwap
    end
  end

end
