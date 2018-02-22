unit Message;

{$mode objfpc}{$H+}

interface

uses
  Chat, User, Classes, SysUtils;

type

  { TMessage }

  TMessage = class
  private
    id: integer;
    chatId: integer;
    userId: integer;
    content: string;
  protected
    function setId(i: integer): integer;
    function setChatId(ci: integer): integer;
    function setUserId(ui: integer): integer;
    function setContent(c: string): string;
  public
    // class function find(i: integer): TMessageArray;
    // class function findByChat(c: TChat): TMessageArray;
    constructor create(c: TChat; u: TUser; co: string);
    function getId(): integer;
    function getChatId(): integer;
    function getUserId(): integer;
    function getContent(): string;
  end;

  TMessageArray = array of TMessage;

function findMessage(i: integer): TMessageArray;
function findMessageByChat(c: TChat): TMessageArray;
function findMessageByUser(u: TUser): TMessageArray;

var
  messages: TMessageArray;

implementation

{ TMessage }

function findMessage(i: integer): TMessageArray;
var c: integer; a: TMessageArray;
begin
  for c := 0 to length(messages) - 1 do
    if messages[c].getId() = i then
    begin
      setLength(a, length(a) + 1);
      a[length(a) - 1] := messages[c];
    end;
  result := a;
end;

function findMessageByChat(c: TChat): TMessageArray;
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

function findMessageByUser(u: TUser): TMessageArray;
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

constructor TMessage.create(c: TChat; u: TUser; co: string);
begin
  inherited create();
  self.setChatId(c.getId());
  self.setUserId(u.getId());
  self.setContent(co);
  repeat
    self.setId(random(999999) + 1);
  until length(findMessage(self.getId())) = 0;
  setLength(messages, length(messages) + 1);
  messages[length(messages) - 1] := self;
end;

function TMessage.getId(): integer;
begin
  result := self.id;
end;

function TMessage.getChatId(): integer;
begin
  result := self.chatId;
end;

function TMessage.getUserId(): integer;
begin
  result := self.userId;
end;

function TMessage.getContent(): string;
begin
  result := self.content;
end;

function TMessage.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TMessage.setChatId(ci: integer): integer;
begin
  self.chatId := ci;
  result := self.getChatId();
end;

function TMessage.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

function TMessage.setContent(c: string): string;
begin
  self.content := c;
  result := self.getContent();
end;

end.
