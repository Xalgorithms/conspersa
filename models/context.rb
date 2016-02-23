class Context
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :public_id, String
  property :status, String

  belongs_to :invocation
  has n, :rules, through: Resource
  
  belongs_to :current_rule, 'Rule'
end
