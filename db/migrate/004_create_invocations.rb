migration 4, :create_invocations do
  up do
    create_table :invocations do
      column :id, Integer, :serial => true
      column :client_id, DataMapper::Property::String, :length => 255
      column :public_id, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :invocations
  end
end
