class ContextRule
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :rule_id, String
  property :rule_version, String

  belongs_to :context
end
