# monopoly game web site
 
 Web site for monopoly game

## Installation

1. cd monop-www && gem install
2. to run site use 
padrino s


## Usage
open web browser 
http://localhost:3000/

## sqlite
$ sqlite3 monop.db

Enter ".help" for usage hints.
sqlite> create table users(id INTEGER PRIMARY KEY AUTOINCREMENT ,name varchar(20), email varchar(20), created_at INTEGER);
sqlite> create table Logs(ip TEXT, path TEXT,uagent TEXT,referer TEXT, date int);
sqlite> insert into users values('user1', 'user1@ggmail.com', '1551005795');
sqlite> insert into users values('user2', 'user2@ggmail.com', '1551005795');
sqlite> select * from users;

sqlite>

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/monop-www/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) sndk - creator, maintainer
