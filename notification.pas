unit Notification;

{$mode objfpc}{$H+}

interface

uses
  User, Classes, SysUtils;

type

  { TNotification }

  TNotification = class
  private
    id: integer;
    userId: integer;
  protected
    function setId(i: integer): integer;
    function setUserId(ui: integer): integer;
  public
    // class function find(i: integer): TNotificationArray;
    // class function findByUser(u: TUser): TNotificationArray;
    constructor create(u: TUser);
    function getId(): integer;
    function getUserId(): integer;
  end;

  TNotificationArray = array of TNotification;

function findNotification(i: integer): TNotificationArray;
function findNotificationByUser(u: TUser): TNotificationArray;

var
  notifications: TNotificationArray;

implementation

{ TNotification }

function findNotification(i: integer): TNotificationArray;
var c: integer; a: TNotificationArray;
begin
  for c := 0 to length(notifications) - 1 do
      if notifications[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := notifications[c];
         end;
  result := a;
end;

function findNotificationByUser(u: TUser): TNotificationArray;
var i: integer; a: TNotificationArray;
begin
  for i := 0 to length(notifications) - 1 do
      if notifications[i].getUserId() = u.getId() then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := notifications[i];
         end;
  result := a;
end;

constructor TNotification.create(u: TUser);
begin
  inherited create();
  self.setUserId(u.getId());
  repeat
    self.setId(random(999999) + 1);
  until length(findNotification(self.getId())) = 0;
  setLength(notifications, length(notifications) + 1);
  notifications[length(notifications) - 1] := self;
end;

function TNotification.getId(): integer;
begin
  result := self.id;
end;

function TNotification.getUserId(): integer;
begin
  result := self.userId;
end;

function TNotification.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TNotification.setUserId(ui: integer): integer;
begin
  self.userId := ui;
  result := self.getUserId();
end;

end.
