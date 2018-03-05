unit Group;

{$mode objfpc}{$H+}

interface

uses
  User, Classes, Database, SysUtils, db, sqldb, mysql56conn;

type

  { TGroup }

  TGroup = class;
  TGroupArray = array of TGroup;

  TGroup = class
  private
    id: integer;
    userId: integer;
    name: string;
    description: string;
  protected
    function setUserId(ui: integer): integer;
    function setName(n: string): string;
    function setDescription(d: string): string;
  public
    constructor create(u: TUser; n, d: string);
    constructor recreate(i, ui: integer; n, d: string);
    class function seed(): boolean;
    class function find(i: integer): TGroup;
    class function whereUser(u: TUser): TGroupArray;
    class function whereName(n: string): TGroupArray;
    function update(n, d: string): TGroup;
    function getId(): integer;
    function getUserId(): integer;
    function getName(): string;
    function getDescription(): string;
  end;

var
  groups: TGroupArray;

implementation
uses Form;

{ TGroup }

constructor TGroup.create(u: TUser; n, d: string);
begin
  inherited create();
  self.userId := u.getId();
  self.name := n;
  self.description := d;
  repeat
    self.id := random(999999) + 1;
  until TGroup.find(self.getId()) = nil;
  setLength(groups, length(groups) + 1);
  groups[length(groups) - 1] := self;
  databaseChange('INSERT INTO groups ( id, user_id, name, description ) VALUES ( ' + IntToStr(self.id) + ', ' + IntToStr(self.userId) + ', "' + self.name + '", "' + self.description + '" );');
end;

constructor TGroup.recreate(i, ui: integer; n, d: string);
begin
  inherited create();
  self.id := i;
  self.userId := ui;
  self.name := n;
  self.description := d;
  setLength(groups, length(groups) + 1);
  groups[length(groups) - 1] := self;
end;

class function TGroup.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM groups;';
    query.open();
    while not query.eof do
    begin
      TGroup.recreate(query.fieldByName('id').asInteger, query.fieldByName('user_id').asInteger, query.fieldByName('name').asString, query.fieldByName('description').asString);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

class function TGroup.find(i: integer): TGroup;
var j: integer;
begin
  for j := 0 to length(groups) - 1 do
    if groups[j].getId() = i then
    begin
      result := groups[j];
      exit;
    end;
  result := nil;
end;

class function TGroup.whereUser(u: TUser): TGroupArray;
var i: integer; a: TGroupArray;
begin
  for i := 0 to length(groups) - 1 do
    if groups[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := groups[i];
    end;
  result := a;
end;

class function TGroup.whereName(n: string): TGroupArray;
var i: integer; a: TGroupArray;
begin
  for i := 0 to length(groups) - 1 do
    if groups[i].getName() = n then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := groups[i];
    end;
  result := a;
end;

function TGroup.update(n, d: string): TGroup;
begin
  self.setName(n);
  self.setDescription(d);
  result := self;
end;

function TGroup.getId(): integer;
begin
  result := self.id;
end;

function TGroup.getUserId(): integer;
begin
  self.userId := databaseSelectInteger('groups', 'user_id', self.getId());
  result := self.userId;
end;

function TGroup.getName(): string;
begin
  self.name := databaseSelectString('groups', 'name', self.getId());
  result := self.name;
end;

function TGroup.getDescription(): string;
begin
  self.description := databaseSelectString('groups', 'description', self.getId());
  result := self.description;
end;

function TGroup.setUserId(ui: integer): integer;
begin
  self.userId := databaseUpdateInteger('groups', 'user_id', ui, self.getId());
  result := self.getUserId();
end;

function TGroup.setName(n: string): string;
begin
  self.name := databaseUpdateString('groups', 'name', n, self.getId());
  result := self.getName();
end;

function TGroup.setDescription(d: string): string;
begin
  self.description := databaseUpdateString('groups', 'description', d, self.getId());
  result := self.getDescription();
end;

end.
