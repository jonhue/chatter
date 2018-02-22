unit Group;

{$mode objfpc}{$H+}

interface

uses
  User, Classes, SysUtils;

type

  { TGroup }

  TGroup = class
  private
    id: integer;
    userId: integer;
    name: string;
    description: string;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
    function setName(n: string): string;
    function setDescription(d: string): string;
  public
    // class function find(i: integer): TGroupArray;
    // class function findByUser(u: TUser): TGroupArray;
    // class function findByName(n: string): TGroupArray;
    constructor create(u: TUser; n, d: string);
    function update(n, d: string): TGroup;
    function getId(): integer;
    function getUserId(): integer;
    function getName(): string;
    function getDescription(): string;
  end;

  TGroupArray = array of TGroup;

var
  groups: TGroupArray;

function findGroup(i: integer): TGroupArray;
function findGroupByUser(u: TUser): TGroupArray;
function findGroupByName(n: string): TGroupArray;

implementation

{ TGroup }

function findGroup(i: integer): TGroupArray;
var c: integer; a: TGroupArray;
begin
  for c := 0 to length(groups) - 1 do
      if groups[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := groups[c];
         end;
  result := a;
end;

function findGroupByUser(u: TUser): TGroupArray;
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

function findGroupByName(n: string): TGroupArray;
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

constructor TGroup.create(u: TUser; n, d: string);
begin
  inherited create();
  self.setUserId(u.getId());
  self.setName(n);
  self.setDescription(d);
  repeat
    self.setId(random(999999) + 1);
  until length(findGroup(self.getId())) = 0;
  setLength(groups, length(groups) + 1);
  groups[length(groups) - 1] := self;
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
  result := self.userId;
end;

function TGroup.getName(): string;
begin
  result := self.name;
end;

function TGroup.getDescription(): string;
begin
  result := self.description;
end;

function TGroup.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TGroup.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TGroup.setName(n: string): string;
begin
  self.name := n;
  result := self.getName();
end;

function TGroup.setDescription(d: string): string;
begin
  self.description := d;
  result := self.getDescription();
end;

end.

