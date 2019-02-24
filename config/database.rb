Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
  #when :development then Sequel.connect(YAML::load(File.open('config/database-mysql.yml')), :loggers => [logger])
  #when :production  then Sequel.connect(YAML::load(File.open('config/database-mysql.yml')),  :loggers => [logger])
  when :development then Sequel.connect("sqlite://db/monop.db", :loggers => [logger])
  when :production  then Sequel.connect("sqlite://db/monop.db",  :loggers => [logger])
end 