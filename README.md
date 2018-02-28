# Chatter

💻 🎓 Final project of my CS class

### Dependencies

_Tested on Windows_

* [Lazarus](https://www.lazarus-ide.org/)
* [MySQL Server](https://dev.mysql.com/downloads/installer)

### Development

1) Setup MySQL by creating a new user `chatter` with password `password`
  
```
CREATE USER 'chatter'@'localhost' IDENTIFIED BY 'password';
```
  
2) Give the user the permission to create and alter tables
  
```
GRANT ALL PRIVILEGES ON * . * TO 'chatter'@'localhost';
```

3) Clone this repository
4) Copy `libmysql.dll` from `<MYSQL_INSTALLATION_PATH>\lib` to the cloned repo and the Lazarus installation folder
5) Run `source <PATH>\schema.sql` in your MySQL command line client
6) Open the `chatter.exe` file
