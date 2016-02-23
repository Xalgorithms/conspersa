migration 3, :add_source_id_to_rule do
  up do
    modify_table :rules do
      add_column :source_id, String
    end
  end

  down do
    modify_table :rules do
      drop_column :source_id
    end
  end
end
