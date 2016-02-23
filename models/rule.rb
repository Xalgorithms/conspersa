class Rule
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :version, String
  property :source_id, String
  belongs_to :processor
end
