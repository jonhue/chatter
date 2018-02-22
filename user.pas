unit User;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TUser }

  TUser = class
  private
    id: integer;
    username: string;
    firstName: string;
    lastName: string;
    password: string;
  protected
    function setId(i: integer): integer;
    function setUsername(u: string): string;
    function setFirstName(fn: string): string;
    function setLastName(ln: string): string;
    function setPassword(p: string): string;
  public
    // class function find(i: integer): TUserArray;
    // class function findByUsername(u: string): TUserArray;
    constructor create(u, fn, ln, p: string);
    class function signup(u, fn, ln, p: string): TUser;
    class function login(u, p: string): TUser;
    function update(p, u, fn, ln, np: string): TUser;
    function getId(): integer;
    function getUsername(): string;
    function getFirstName(): string;
    function getLastName(): string;
    function getPassword(): string;
  end;

  TUserArray = array of TUser;

function findUser(i: integer): TUserArray;
function findUserByUsername(u: string): TUserArray;

var
  users: TUserArray;

implementation

{ TUser }

function findUser(i: integer): TUserArray;
var c: integer; a: TUserArray;
begin
  for c := 0 to length(users) - 1 do
      if users[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := users[c];
         end;
  result := a;
end;

function findUserByUsername(u: string): TUserArray;
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

constructor TUser.create(u, fn, ln, p: string);
begin
  inherited create();
  self.setUsername(u);
  self.setFirstName(fn);
  self.setLastName(ln);
  self.setPassword(p);
  repeat
    self.setId(random(999999) + 1);
  until length(findUser(self.getId())) = 0;
  setLength(users, length(users) + 1);
  users[length(users) - 1] := self;
end;

class function TUser.signup(u, fn, ln, p: string): TUser;
var user: TUser;
begin
  user := TUser.create(u, fn, ln, p);
  if length(findUserByUsername(user.getUsername())) = 1 then
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
  if length(findUserByUsername(u)) > 0 then
     if findUserByUsername(u)[0].getPassword() = p then
     begin
        result := findUserByUsername(u)[0];
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
  result := self.username;
end;

function TUser.getFirstName(): string;
begin
  result := self.firstName;
end;

function TUser.getLastName(): string;
begin
  result := self.lastName;
end;

function TUser.getPassword(): string;
begin
  result := self.password;
end;

function TUser.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TUser.setUsername(u: string): string;
begin
  self.username := u;
  result := self.getUsername();
end;

function TUser.setFirstName(fn: string): string;
begin
  self.firstName := fn;
  result := self.getFirstName();
end;

function TUser.setLastName(ln: string): string;
begin
  self.lastName := ln;
  result := self.getLastName();
end;

function TUser.setPassword(p: string): string;
begin
  self.password := p;
  result := self.getPassword();
end;

end.

