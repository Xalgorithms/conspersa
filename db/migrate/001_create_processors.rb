migration 1, :create_processors do
  up do
    create_table :processors do
      column :id, Integer, :serial => true
      column :address, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :processors
  end
end
