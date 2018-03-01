unit UserChat;

{$mode objfpc}{$H+}

interface

uses
  User, Chat, Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TUserGroup }

  TUserChat = class
  private
    id: integer;
    userId: integer;
    chatId: integer;
  protected
    function setUserId(ui: integer): integer;
    function setChatId(ci: integer): integer;
  public
    // class function find(i: integer): TUserChatArray;
    // class function findByUser(u: TUser): TUserChatArray;
    // class function findByChat(c: TChat): TUserChatArray;
    constructor create(u: TUser; c: TChat);
    constructor recreate(i, ui, ci: integer);
    class function seed(): boolean;
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
uses Form;

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
  self.userId := u.getId();
  self.chatId := c.getId();
  repeat
    self.id := random(999999) + 1;
  until length(findUserChat(self.getId())) = 0;
  setLength(userChats, length(userChats) + 1);
  userChats[length(userChats) - 1] := self;
  databaseChange('INSERT INTO user_chats ( id, user_id, chat_id ) VALUES ( ' + IntToStr(self.id) + ', ' + IntToStr(self.userId) + ', ' + IntToStr(self.chatId) + ' );');
end;

constructor TUserChat.recreate(i, ui, ci: integer);
begin
  inherited create();
  self.id := i;
  self.userId := ui;
  self.chatId := ci;
  setLength(userChats, length(userChats) + 1);
  userChats[length(userChats) - 1] := self;
end;

class function TUserChat.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM user_chats;';
    query.open();
    while not query.eof do
    begin
      TUserChat.recreate(query.fieldByName('id').asInteger, query.fieldByName('user_id').asInteger, query.fieldByName('chat_id').asInteger);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

function TUserChat.getId(): integer;
begin
  result := self.id;
end;

function TUserChat.getUserId(): integer;
begin
  self.userId := databaseSelectInteger('user_chats', 'user_id', self.getId());
  result := self.userId;
end;

function TUserChat.getChatId(): integer;
begin
  self.chatId := databaseSelectInteger('user_chats', 'chat_id', self.getId());
  result := self.chatId;
end;

function TUserChat.setUserId(ui: integer): integer;
begin
  self.userId := databaseUpdateInteger('user_chats', 'user_id', ui, self.getId());
  result := self.getUserId();
end;

function TUserChat.setChatId(ci: integer): integer;
begin
  self.chatId := databaseUpdateInteger('user_chats', 'chat_id', ci, self.getId());
  result := self.getChatId();
end;

end.
