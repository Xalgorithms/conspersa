migration 7, :add_current_rule_id_to_context do
  up do
    modify_table :contexts do
      add_column :current_rule_id, Integer
    end
  end

  down do
    modify_table :contexts do
      drop_column :current_rule_id
    end
  end
end
