class Context
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :public_id, String
  property :status, String

  belongs_to :invocation
  has n, :rules, through: Resource
  belongs_to :current_rule, 'Rule', required: false

  def self.with(props)
    m = first(props)
    yield(m) if m
  end

  def next_rule
    remaining = rules.drop_while { |rm| rm != current_rule }[1..-1]
    remaining ? remaining.first : nil
  end
end
