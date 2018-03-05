unit UserGroup;

{$mode objfpc}{$H+}

interface

uses
  User, Group, Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TUserGroup }

  TUserGroup = class;
  TUserGroupArray = array of TUserGroup;

  TUserGroup = class
  private
    id: integer;
    userId: integer;
    groupId: integer;
  protected
    function setUserId(ui: integer): integer;
    function setGroupId(gi: integer): integer;
  public
    constructor create(u: TUser; g: TGroup);
    constructor recreate(i, ui, gi: integer);
    class function seed(): boolean;
    class function find(i: integer): TUserGroup;
    class function whereUser(u: TUser): TUserGroupArray;
    class function whereGroup(g: TGroup): TUserGroupArray;
    function getId(): integer;
    function getUserId(): integer;
    function getGroupId(): integer;
  end;

var
  userGroups: TUserGroupArray;

implementation
uses Form;

{ TUserGroup }

constructor TUserGroup.create(u: TUser; g: TGroup);
begin
  inherited create();
  self.userId := u.getId();
  self.groupId := g.getId();
  repeat
    self.id := random(999999) + 1;
  until TUserGroup.find(self.getId()) = nil;
  setLength(userGroups, length(userGroups) + 1);
  userGroups[length(userGroups) - 1] := self;
  databaseChange('INSERT INTO user_groups ( id, user_id, group_id ) VALUES ( ' + IntToStr(self.id) + ', ' + IntToStr(self.userId) + ', ' + IntToStr(self.groupId) + ' );');
end;

constructor TUserGroup.recreate(i, ui, gi: integer);
begin
  inherited create();
  self.id := i;
  self.userId := ui;
  self.groupId := gi;
  setLength(userGroups, length(userGroups) + 1);
  userGroups[length(userGroups) - 1] := self;
end;

class function TUserGroup.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM user_groups;';
    query.open();
    while not query.eof do
    begin
      TUserGroup.recreate(query.fieldByName('id').asInteger, query.fieldByName('user_id').asInteger, query.fieldByName('group_id').asInteger);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

class function TUserGroup.find(i: integer): TUserGroup;
var j: integer;
begin
  for j := 0 to length(userGroups) - 1 do
    if userGroups[j].getId() = i then
    begin
      result := userGroups[j];
      exit;
    end;
  result := nil;
end;

class function TUserGroup.whereUser(u: TUser): TUserGroupArray;
var i: integer; a: TUserGroupArray;
begin
  for i := 0 to length(userGroups) - 1 do
    if userGroups[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := userGroups[i];
    end;
  result := a;
end;

class function TUserGroup.whereGroup(g: TGroup): TUserGroupArray;
var i: integer; a: TUserGroupArray;
begin
  for i := 0 to length(userGroups) - 1 do
    if userGroups[i].getGroupId() = g.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := userGroups[i];
    end;
  result := a;
end;

function TUserGroup.getId(): integer;
begin
  result := self.id;
end;

function TUserGroup.getUserId(): integer;
begin
  self.userId := databaseSelectInteger('user_groups', 'user_id', self.getId());
  result := self.userId;
end;

function TUserGroup.getGroupId(): integer;
begin
  self.groupId := databaseSelectInteger('user_groups', 'group_id', self.getId());
  result := self.groupId;
end;

function TUserGroup.setUserId(ui: integer): integer;
begin
  self.userId := databaseUpdateInteger('user_groups', 'user_id', ui, self.getId());
  result := self.getUserId();
end;

function TUserGroup.setGroupId(gi: integer): integer;
begin
  self.groupId := databaseUpdateInteger('user_groups', 'group_id', gi, self.getId());
  result := self.getGroupId();
end;

end.
