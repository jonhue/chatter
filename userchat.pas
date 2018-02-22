unit UserChat;

{$mode objfpc}{$H+}

interface

uses
  User, Chat, Classes, SysUtils;

type

  { TUserGroup }

  TUserChat = class
  private
    id: integer;
    userId: integer;
    chatId: integer;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
    function setChatId(ci: integer): integer;
  public
    // class function find(i: integer): TUserChatArray;
    // class function findByUser(u: TUser): TUserChatArray;
    // class function findByChat(c: TChat): TUserChatArray;
    constructor create(u: TUser; c: TChat);
    function getId(): integer;
    function getUserId(): integer;
    function getChatId(): integer;
  end;

  TUserChatArray = array of TUserChat;

function findUserChat(i: integer): TUserChatArray;
function findUserChatByUser(u: TUser): TUserChatArray;
function findUserChatByChat(c: TChat): TUserChatArray;

var
  userChats: TUserChatArray;

implementation

{ TUserChat }

function findUserChat(i: integer): TUserChatArray;
var c: integer; a: TUserChatArray;
begin
  for c := 0 to length(userChats) - 1 do
    if userChats[c].getId() = i then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := userChats[c];
    end;
  result := a;
end;

function findUserChatByUser(u: TUser): TUserChatArray;
var i: integer; a: TUserChatArray;
begin
  for i := 0 to length(userChats) - 1 do
    if userChats[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := userChats[i];
    end;
  result := a;
end;

function findUserChatByChat(c: TChat): TUserChatArray;
var i: integer; a: TUserChatArray;
begin
  for i := 0 to length(userChats) - 1 do
    if userChats[i].getChatId() = c.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := userChats[i];
    end;
  result := a;
end;

constructor TUserChat.create(u: TUser; c: TChat);
begin
  inherited create();
  self.setUserId(u.getId());
  self.setChatId(c.getId());
  repeat
    self.setId(random(999999) + 1);
  until length(findUserChat(self.getId())) = 0;
  setLength(userChats, length(userChats) + 1);
  userChats[length(userChats) - 1] := self;
end;

function TUserChat.getId(): integer;
begin
  result := self.id;
end;

function TUserChat.getUserId(): integer;
begin
  result := self.userId;
end;

function TUserChat.getChatId(): integer;
begin
  result := self.chatId;
end;

function TUserChat.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TUserChat.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TUserChat.setChatId(ci: integer): integer;
begin
  self.chatId := ci;
  result := self.getChatId();
end;

end.
