migration 2, :create_rules do
  up do
    create_table :rules do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :version, DataMapper::Property::String, :length => 255
      column :processor_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :rules
  end
end
