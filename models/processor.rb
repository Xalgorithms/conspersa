class Processor
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :address, String
  has n, :rules

  def update_rules(updated_rules)
    rules = updated_rules.map do |r|
      Rule.all(processor: self).destroy
      Rule.create(source_id: r.id, name: r.name, version: r.version)
    end
  end
end
