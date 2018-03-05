unit User;

{$mode objfpc}{$H+}

interface

uses
  Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TUser }

  TUser = class;
  TUserArray = array of TUser;

  TUser = class
  private
    id: integer;
    username: string;
    firstName: string;
    lastName: string;
    password: string;
  protected
    function setUsername(u: string): string;
    function setFirstName(fn: string): string;
    function setLastName(ln: string): string;
    function setPassword(p: string): string;
  public
    constructor create(u, fn, ln, p: string);
    constructor recreate(i: integer; u, fn, ln, p: string);
    class function seed(): boolean;
    class function find(i: integer): TUser;
    class function whereUsername(u: string): TUserArray;
    class function signup(u, fn, ln, p: string): TUser;
    class function login(u, p: string): TUser;
    function update(p, u, fn, ln, np: string): TUser;
    function getId(): integer;
    function getUsername(): string;
    function getFirstName(): string;
    function getLastName(): string;
    function getPassword(): string;
  end;

var
  users: TUserArray;

implementation
uses Form;

{ TUser }

constructor TUser.create(u, fn, ln, p: string);
begin
  inherited create();
  self.username := u;
  self.firstName := fn;
  self.lastName := ln;
  self.password := p;
  repeat
    self.id := random(999999) + 1;
  until TUser.find(self.getId()) = nil;
  setLength(users, length(users) + 1);
  users[length(users) - 1] := self;
  databaseChange('INSERT INTO users ( id, username, first_name, last_name, password ) VALUES ( ' + IntToStr(self.id) + ', "' + self.username + '", "' + self.firstName + '", "' + self.lastName + '", "' + self.password + '" );');
end;

constructor TUser.recreate(i: integer; u, fn, ln, p: string);
begin
  inherited create();
  self.id := i;
  self.username := u;
  self.firstName := fn;
  self.lastName := ln;
  self.password := p;
  setLength(users, length(users) + 1);
  users[length(users) - 1] := self;
end;

class function TUser.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM users;';
    query.open();
    while not query.eof do
    begin
      TUser.recreate(query.fieldByName('id').asInteger, query.fieldByName('username').asString, query.fieldByName('first_name').asString, query.fieldByName('last_name').asString, query.fieldByName('password').asString);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

class function TUser.find(i: integer): TUser;
var j: integer;
begin
  for j := 0 to length(users) - 1 do
    if users[j].getId() = i then
    begin
      result := users[j];
      exit;
    end;
  result := nil;
end;

class function TUser.whereUsername(u: string): TUserArray;
var i: integer; a: TUserArray;
begin
  for i := 0 to length(users) - 1 do
    if users[i].getUsername() = u then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := users[i];
    end;
  result := a;
end;

class function TUser.signup(u, fn, ln, p: string): TUser;
var user: TUser;
begin
  user := TUser.create(u, fn, ln, p);
  if length(TUser.whereUsername(user.getUsername())) = 1 then
  begin
    result := user;
    exit;
  end
  else
    user.destroy();
  result := nil;
end;

class function TUser.login(u, p: string): TUser;
begin
  if length(TUser.whereUsername(u)) > 0 then
    if TUser.whereUsername(u)[0].getPassword() = p then
    begin
      result := TUser.whereUsername(u)[0];
      exit;
    end;
  result := nil;
end;

function TUser.update(p, u, fn, ln, np: string): TUser;
begin
  if p <> self.getPassword() then
  begin
    result := nil;
    exit;
  end;
  self.setUsername(u);
  self.setFirstName(fn);
  self.setLastName(ln);
  self.setPassword(np);
  result := self;
end;

function TUser.getId(): integer;
begin
  result := self.id;
end;

function TUser.getUsername(): string;
begin
  self.username := databaseSelectString('users', 'username', self.getId());
  result := self.username;
end;

function TUser.getFirstName(): string;
begin
  self.firstName := databaseSelectString('users', 'first_name', self.getId());
  result := self.firstName;
end;

function TUser.getLastName(): string;
begin
  self.lastName := databaseSelectString('users', 'last_name', self.getId());
  result := self.lastName;
end;

function TUser.getPassword(): string;
begin
  self.password := databaseSelectString('users', 'password', self.getId());
  result := self.password;
end;

function TUser.setUsername(u: string): string;
begin
  self.username := databaseUpdateString('users', 'username', u, self.getId());
  result := self.getUsername();
end;

function TUser.setFirstName(fn: string): string;
begin
  self.firstName := databaseUpdateString('users', 'first_name', fn, self.getId());
  result := self.getFirstName();
end;

function TUser.setLastName(ln: string): string;
begin
  self.lastName := databaseUpdateString('users', 'last_name', ln, self.getId());
  result := self.getLastName();
end;

function TUser.setPassword(p: string): string;
begin
  self.password := databaseUpdateString('users', 'password', p, self.getId());
  result := self.getPassword();
end;

end.
