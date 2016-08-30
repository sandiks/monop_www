Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
when :development then Sequel.connect("postgres://postgres:12345@localhost/monop", :loggers => [logger])
when :production  then Sequel.connect("postgres://postgres:12345@localhost/monop",  :loggers => [logger])
when :test        then Sequel.connect("postgres://localhost/monopwww_test",        :loggers => [logger])
end
