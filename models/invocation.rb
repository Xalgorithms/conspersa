class Invocation
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :client_id, String
  property :public_id, String

  has n, :contexts
end
