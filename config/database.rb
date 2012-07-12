MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'itelejugito_development'
  when :production  then MongoMapper.database = 'itelejugito_production'
  when :test        then MongoMapper.database = 'itelejugito_test'
end
