unit Message;

{$mode objfpc}{$H+}

interface

uses
  Chat, User, Database, Classes, SysUtils, db, sqldb, mysql56conn;

type

  { TMessage }

  TMessage = class;
  TMessageArray = array of TMessage;

  TMessage = class
  private
    id: integer;
    userId: integer;
    chatId: integer;
    content: string;
  protected
    function setUserId(ui: integer): integer;
    function setChatId(ci: integer): integer;
    function setContent(c: string): string;
  public
    constructor create(c: TChat; u: TUser; co: string);
    constructor recreate(i, ui, ci: integer; c: string);
    class function seed(): boolean;
    class function find(i: integer): TMessage;
    class function whereUser(u: TUser): TMessageArray;
    class function whereChat(c: TChat): TMessageArray;
    function getId(): integer;
    function getUserId(): integer;
    function getChatId(): integer;
    function getContent(): string;
  end;

var
  messages: TMessageArray;

implementation
uses Form;

{ TMessage }

constructor TMessage.create(c: TChat; u: TUser; co: string);
begin
  inherited create();
  self.chatId := c.getId();
  self.userId := u.getId();
  self.content := co;
  repeat
    self.id := random(999999) + 1;
  until TMessage.find(self.getId()) = nil;
  setLength(messages, length(messages) + 1);
  messages[length(messages) - 1] := self;
  databaseChange('INSERT INTO messages ( id, user_id, chat_id, content ) VALUES ( ' + IntToStr(self.id) + ', ' + IntToStr(self.userId) + ', ' + IntToStr(self.chatId) + ', "' + self.content + '" );');
end;

constructor TMessage.recreate(i, ui, ci: integer; c: string);
begin
  inherited create();
  self.id := i;
  self.userId := ui;
  self.chatId := ci;
  self.content := c;
  setLength(messages, length(messages) + 1);
  messages[length(messages) - 1] := self;
end;

class function TMessage.seed(): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  try
    query.SQL.text := 'SELECT * FROM messages;';
    query.open();
    while not query.eof do
    begin
      TMessage.recreate(query.fieldByName('id').asInteger, query.fieldByName('user_id').asInteger, query.fieldByName('chat_id').asInteger, query.fieldByName('content').asString);
      query.next();
    end;
  finally
    query.close();
  end;
  result := true;
end;

class function TMessage.find(i: integer): TMessage;
var j: integer;
begin
  for j := 0 to length(messages) - 1 do
    if messages[j].getId() = i then
      result := messages[j];
end;

class function TMessage.whereUser(u: TUser): TMessageArray;
var i: integer; a: TMessageArray;
begin
  for i := 0 to length(messages) - 1 do
    if messages[i].getUserId() = u.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := messages[i];
    end;
  result := a;
end;

class function TMessage.whereChat(c: TChat): TMessageArray;
var i: integer; a: TMessageArray;
begin
  for i := 0 to length(messages) - 1 do
    if messages[i].getChatId() = c.getId() then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := messages[i];
    end;
  result := a;
end;

function TMessage.getId(): integer;
begin
  result := self.id;
end;

function TMessage.getUserId(): integer;
begin
  self.userId := databaseSelectInteger('messages', 'user_id', self.getId());
  result := self.userId;
end;

function TMessage.getChatId(): integer;
begin
  self.chatId := databaseSelectInteger('messages', 'chat_id', self.getId());
  result := self.chatId;
end;

function TMessage.getContent(): string;
begin
  self.content := databaseSelectString('messages', 'content', self.getId());
  result := self.content;
end;

function TMessage.setUserId(ui: integer): integer;
begin
  self.userId := databaseUpdateInteger('messages', 'user_id', ui, self.getId());
  result := self.getUserId();
end;

function TMessage.setChatId(ci: integer): integer;
begin
  self.chatId := databaseUpdateInteger('messages', 'chat_id', ci, self.getId());
  result := self.getChatId();
end;

function TMessage.setContent(c: string): string;
begin
  self.content := databaseUpdateString('messages', 'content', c, self.getId());
  result := self.getContent();
end;

end.
