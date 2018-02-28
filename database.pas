unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, mysql57conn;

function databaseConnect(u, p: string): TSQLConnector;
function databaseDisconnect(): boolean;
function databaseExecute(q: string): boolean;

var
  databaseConnection: TSQLConnector;
  databaseQuery: TSQLQuery;

implementation

function databaseConnect(u, p: string): TSQLConnector;
begin
  databaseConnection := TSQLConnector.create(nil);
  with databaseConnection do begin
    connectorType := 'mysql 5.7';
    hostName := 'localhost';
    databaseName := 'chatter';
    userName := u;
    password := p;
    transaction := TSQLTransaction.create(databaseConnection);
  end;
  // databaseConnection.free;
  result := databaseConnection;
end;

function databaseDisconnect(): boolean;
begin
  databaseConnection.free;
  result := true;
end;

function databaseExecute(q: string): boolean;
var field: TField;
begin
  databaseQuery := TSQLQuery.create(nil);
  databaseQuery.dataBase := databaseConnection;
  databaseQuery.SQL.text := q;
  databaseQuery.open;
  while not databaseQuery.EOF do begin
    for field in databaseQuery.fields do begin
      Write(field.fieldName, ' = ');
      if field.isNull then WriteLn('NULL') else WriteLn(field.value);
    end;
    WriteLn;
    databaseQuery.next;
  end;
  databaseQuery.close;
  databaseQuery.free;
  result := true;
end;

end.
