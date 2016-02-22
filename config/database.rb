DataMapper.logger = logger
DataMapper::Property::String.length(255)

case Padrino.env
  when :development then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "tatev_development.db"))
  when :production  then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "tatev_production.db"))
  when :test        then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "tatev_test.db"))
end
