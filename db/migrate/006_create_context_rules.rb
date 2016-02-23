migration 6, :create_context_rules do
  up do
    create_table :context_rules do
      column :id, Integer, :serial => true
      column :rule_id, DataMapper::Property::String, :length => 255
      column :rule_version, DataMapper::Property::String, :length => 255
      column :context_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :context_rules
  end
end
