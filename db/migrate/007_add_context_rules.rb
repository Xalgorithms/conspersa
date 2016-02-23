migration 7, :add_context_rules do
  up do
    create_table :context_rules do
      column :rule_id, DataMapper::Property::Integer
      column :context_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :context_rules
  end
end
