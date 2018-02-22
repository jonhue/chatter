unit Chat;

{$mode objfpc}{$H+}

interface

uses
  User, Group, Classes, SysUtils;

type

  { TChat }

  TChat = class
  private
    id: integer;
    userId: integer;
    groupId: integer;
    name: string;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
    function setGroupId(gi: integer): integer;
    function setName(n: string): string;
  public
    // class function find(i: integer): TChatArray;
    // class function findByUser(u: TUser): TChatArray;
    // class function findByGroup(g: TGroup): TChatArray;
    constructor create(u: TUser; g: TGroup; n: string);
    function update(g: TGroup; n: string): TChat;
    function getId(): integer;
    function getUserId(): integer;
    function getGroupId(): integer;
    function getName(): string;
  end;

  TChatArray = array of TChat;

function findChat(i: integer): TChatArray;
function findChatByUser(u: TUser): TChatArray;
function findChatByGroup(g: TGroup): TChatArray;

var
  chats: TChatArray;

implementation

{ TNotification }

function findChat(i: integer): TChatArray;
var c: integer; a: TChatArray;
begin
  for c := 0 to length(chats) - 1 do
      if chats[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := chats[c];
         end;
  result := a;
end;

function findChatByUser(u: TUser): TChatArray;
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

function findChatByGroup(g: TGroup): TChatArray;
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

constructor TChat.create(u: TUser; g: TGroup; n: string);
begin
  inherited create();
  self.setUserId(u.getId());
  self.setName(n);
  if g <> nil then
     self.setGroupId(g.getId());
  repeat
    self.setId(random(999999) + 1);
  until length(findChat(self.getId())) = 0;
  setLength(chats, length(chats) + 1);
  chats[length(chats) - 1] := self;
end;

function TChat.update(g: TGroup; n: string): TChat;
begin
  self.setGroupId(g.getId());
  self.setName(n);
  result := self;
end;

function TChat.getId(): integer;
begin
  result := self.id;
end;

function TChat.getUserId(): integer;
begin
  result := self.userId;
end;

function TChat.getGroupId(): integer;
begin
  result := self.groupId;
end;

function TChat.getName(): string;
begin
  result := self.name;
end;

function TChat.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TChat.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TChat.setGroupId(gi: integer): integer;
begin
  self.groupId := gi;
  result := self.getGroupId();
end;

function TChat.setName(n: string): string;
begin
  self.name := n;
  result := self.getName();
end;

end.

