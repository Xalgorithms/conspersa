class Context
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :public_id, String
  property :status, String

  belongs_to :invocation
end
