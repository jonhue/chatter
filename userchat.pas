unit UserChat;

{$mode objfpc}{$H+}

interface

uses
  User, Chat, Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TUserChat }

  TUserChat = class;
  TUserChatArray = array of TUserChat;

  TUserChat = class
  private
    id: integer;
    userId: integer;
    chatId: integer;
  protected
    function setUserId(ui: integer): integer;
    function setChatId(ci: integer): integer;
  public
    constructor create(u: TUser; c: TChat);
    constructor recreate(i, ui, ci: integer);
    class function seed(): boolean;
    class function find(i: integer): TUserChat;
    class function whereUser(u: TUser): TUserChatArray;
    class function whereChat(c: TChat): TUserChatArray;
    function getId(): integer;
    function getUserId(): integer;
    function getChatId(): integer;
  end;

var
  userChats: TUserChatArray;

implementation
uses Form;

{ TUserChat }

constructor TUserChat.create(u: TUser; c: TChat);
begin
  inherited create();
  self.userId := u.getId();
  self.chatId := c.getId();
  repeat
    self.id := random(999999) + 1;
  until TUserChat.find(self.getId()) = nil;
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

class function TUserChat.find(i: integer): TUserChat;
var j: integer;
begin
  for j := 0 to length(userChats) - 1 do
    if userChats[j].getId() = i then
      result := userChats[j];
end;

class function TUserChat.whereUser(u: TUser): TUserChatArray;
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

class function TUserChat.whereChat(c: TChat): TUserChatArray;
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
