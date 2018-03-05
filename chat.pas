unit Chat;

{$mode objfpc}{$H+}

interface

uses
  User, Group, Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TChat }

  TChat = class;
  TChatArray = array of TChat;

  TChat = class
  private
    id: integer;
    userId: integer;
    groupId: integer;
    name: string;
  protected
    function setUserId(ui: integer): integer;
    function setGroupId(gi: integer): integer;
    function setName(n: string): string;
  public
    constructor create(u: TUser; g: TGroup; n: string);
    constructor recreate(i, ui, gi: integer; n: string);
    class function seed(): boolean;
    class function find(i: integer): TChat;
    class function whereUser(u: TUser): TChatArray;
    class function whereGroup(g: TGroup): TChatArray;
    function update(g: TGroup; n: string): TChat;
    function getId(): integer;
    function getUserId(): integer;
    function getGroupId(): integer;
    function getName(): string;
  end;

var
  chats: TChatArray;

implementation
uses Form;

{ TChat }

constructor TChat.create(u: TUser; g: TGroup; n: string);
begin
  inherited create();
  self.userId := u.getId();
  self.name := n;
  if g <> nil then
    self.groupId := g.getId();
  repeat
    self.id := random(999999) + 1;
  until TChat.find(self.getId()) = nil;
  setLength(chats, length(chats) + 1);
  chats[length(chats) - 1] := self;
  databaseChange('INSERT INTO chats ( id, user_id, group_id, name ) VALUES ( ' + IntToStr(self.id) + ', ' + IntToStr(self.userId) + ', ' + IntToStr(self.groupId) + ', "' + self.name + '" );');
end;

constructor TChat.recreate(i, ui, gi: integer; n: string);
begin
  inherited create();
  self.id := i;
  self.userId := ui;
  self.groupId := gi;
  self.name := n;
  setLength(chats, length(chats) + 1);
  chats[length(chats) - 1] := self;
end;

class function TChat.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM chats;';
    query.open();
    while not query.eof do
    begin
      TChat.recreate(query.fieldByName('id').asInteger, query.fieldByName('user_id').asInteger, query.fieldByName('group_id').asInteger, query.fieldByName('name').asString);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

class function TChat.find(i: integer): TChat;
var j: integer;
begin
  for j := 0 to length(chats) - 1 do
    if chats[j].getId() = i then
    begin
      result := chats[j];
      exit;
    end;
  result := nil;
end;

class function TChat.whereUser(u: TUser): TChatArray;
var i: integer; a: TChatArray;
begin
  for i := 0 to length(chats) - 1 do
    if chats[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := chats[i];
    end;
  result := a;
end;

class function TChat.whereGroup(g: TGroup): TChatArray;
var i: integer; a: TChatArray;
begin
  for i := 0 to length(chats) - 1 do
    if chats[i].getGroupId() = g.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := chats[i];
    end;
  result := a;
end;

function TChat.update(g: TGroup; n: string): TChat;
begin
  self.setName(n);
  if g <> nil then
    self.setGroupId(g.getId());
  result := self;
end;

function TChat.getId(): integer;
begin
  result := self.id;
end;

function TChat.getUserId(): integer;
begin
  self.userId := databaseSelectInteger('chats', 'user_id', self.getId());
  result := self.userId;
end;

function TChat.getGroupId(): integer;
begin
  self.groupId := databaseSelectInteger('chats', 'group_id', self.getId());
  result := self.groupId;
end;

function TChat.getName(): string;
begin
  self.name := databaseSelectString('chats', 'name', self.getId());
  result := self.name;
end;

function TChat.setUserId(ui: integer): integer;
begin
  self.userId := databaseUpdateInteger('chats', 'user_id', ui, self.getId());
  result := self.getUserId();
end;

function TChat.setGroupId(gi: integer): integer;
begin
  self.groupId := databaseUpdateInteger('chats', 'group_id', gi, self.getId());
  result := self.getGroupId();
end;

function TChat.setName(n: string): string;
begin
  self.name := databaseUpdateString('chats', 'name', n, self.getId());
  result := self.getName();
end;

end.
