migration 5, :create_contexts do
  up do
    create_table :contexts do
      column :id, Integer, :serial => true
      column :invocation_id, DataMapper::Property::Integer
      column :public_id, DataMapper::Property::String, :length => 255
      column :status, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :contexts
  end
end
