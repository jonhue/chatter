unit Invitation;

{$mode objfpc}{$H+}

interface

uses
  User, Group, Chat, Classes, SysUtils;

type

  { TInvitation }

  TInvitation = class
  private
    id: integer;
    userId: integer;
    targetId: integer;
    groupId: integer;
    chatId: integer;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
    function setTargetId(ti: integer): integer;
    function setGroupId(gi: integer): integer;
    function setChatId(ci: integer): integer;
  public
    // class function find(i: integer): TInvitationArray;
    // class function findByUser(u: TUser): TInvitationArray;
    // class function findByTarget(t: TUser): TInvitationArray;
    // class function findByGroup(g: TGroup): TInvitationArray;
    // class function findByChat(c: TChat): TInvitationArray;
    constructor create(u, t: TUser; g: TGroup; c: TChat);
    function getId(): integer;
    function getUserId(): integer;
    function getTargetId(): integer;
    function getGroupId(): integer;
    function getChatId(): integer;
  end;

  TInvitationArray = array of TInvitation;

function findInvitation(i: integer): TInvitationArray;
function findInvitationByUser(u: TUser): TInvitationArray;
function findInvitationByTarget(t: TUser): TInvitationArray;
function findInvitationByGroup(g: TGroup): TInvitationArray;
function findInvitationByChat(c: TChat): TInvitationArray;

var
  invitations: TInvitationArray;

implementation

{ TInvitation }

function findInvitation(i: integer): TInvitationArray;
var c: integer; a: TInvitationArray;
begin
  for c := 0 to length(invitations) - 1 do
    if invitations[c].getId() = i then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := invitations[c];
    end;
  result := a;
end;

function findInvitationByUser(u: TUser): TInvitationArray;
var i: integer; a: TInvitationArray;
begin
  for i := 0 to length(invitations) - 1 do
    if invitations[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := invitations[i];
    end;
  result := a;
end;

function findInvitationByTarget(t: TUser): TInvitationArray;
var i: integer; a: TInvitationArray;
begin
  for i := 0 to length(invitations) - 1 do
    if invitations[i].getTargetId() = t.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := invitations[i];
    end;
  result := a;
end;

function findInvitationByGroup(g: TGroup): TInvitationArray;
var i: integer; a: TInvitationArray;
begin
  for i := 0 to length(invitations) - 1 do
    if invitations[i].getGroupId() = g.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := invitations[i];
    end;
  result := a;
end;

function findInvitationByChat(c: TChat): TInvitationArray;
var i: integer; a: TInvitationArray;
begin
  for i := 0 to length(invitations) - 1 do
    if invitations[i].getChatId() = c.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := invitations[i];
    end;
  result := a;
end;

constructor TInvitation.create(u, t: TUser; g: TGroup; c: TChat);
begin
  inherited create();
  self.setUserId(u.getId());
  self.setTargetId(t.getId());
  if g <> nil then
    self.setGroupId(g.getId());
  if c <> nil then
    self.setChatId(c.getId());
  repeat
    self.setId(random(999999) + 1);
  until length(findInvitation(self.getId())) = 0;
  setLength(invitations, length(invitations) + 1);
  invitations[length(invitations) - 1] := self;
end;

function TInvitation.getId(): integer;
begin
  result := self.id;
end;

function TInvitation.getUserId(): integer;
begin
  result := self.userId;
end;

function TInvitation.getTargetId(): integer;
begin
  result := self.targetId;
end;

function TInvitation.getGroupId(): integer;
begin
  result := self.groupId;
end;

function TInvitation.getChatId(): integer;
begin
  result := self.chatId;
end;

function TInvitation.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TInvitation.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TInvitation.setTargetId(ti: integer): integer;
begin
  self.targetId := ti;
  result := self.getTargetId();
end;

function TInvitation.setGroupId(gi: integer): integer;
begin
  self.groupId := gi;
  result := self.getGroupId();
end;

function TInvitation.setChatId(ci: integer): integer;
begin
  self.chatId := ci;
  result := self.getChatId();
end;

end.
