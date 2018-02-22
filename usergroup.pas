unit UserGroup;

{$mode objfpc}{$H+}

interface

uses
  User, Group, Classes, SysUtils;

type

  { TUserGroup }

  TUserGroup = class
  private
    id: integer;
    userId: integer;
    groupId: integer;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
    function setGroupId(gi: integer): integer;
  public
    // class function find(i: integer): TUserGroupArray;
    // class function findByUser(u: TUser): TUserGroupArray;
    // class function findByGroup(g: TGroup): TUserGroupArray;
    constructor create(u: TUser; g: TGroup);
    function getId(): integer;
    function getUserId(): integer;
    function getGroupId(): integer;
  end;

  TUserGroupArray = array of TUserGroup;

function findUserGroup(i: integer): TUserGroupArray;
function findUserGroupByUser(u: TUser): TUserGroupArray;
function findUserGroupByGroup(g: TGroup): TUserGroupArray;

var
  userGroups: TUserGroupArray;

implementation

{ TUserGroup }

function findUserGroup(i: integer): TUserGroupArray;
var c: integer; a: TUserGroupArray;
begin
  for c := 0 to length(userGroups) - 1 do
      if userGroups[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := userGroups[c];
         end;
  result := a;
end;

function findUserGroupByUser(u: TUser): TUserGroupArray;
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

function findUserGroupByGroup(g: TGroup): TUserGroupArray;
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

constructor TUserGroup.create(u: TUser; g: TGroup);
begin
  inherited create();
  self.setUserId(u.getId());
  self.setGroupId(g.getId());
  repeat
    self.setId(random(999999) + 1);
  until length(findUserGroup(self.getId())) = 0;
  setLength(userGroups, length(userGroups) + 1);
  userGroups[length(userGroups) - 1] := self;
end;

function TUserGroup.getId(): integer;
begin
  result := self.id;
end;

function TUserGroup.getUserId(): integer;
begin
  result := self.userId;
end;

function TUserGroup.getGroupId(): integer;
begin
  result := self.groupId;
end;

function TUserGroup.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TUserGroup.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TUserGroup.setGroupId(gi: integer): integer;
begin
  self.groupId := gi;
  result := self.getGroupId();
end;

end.
