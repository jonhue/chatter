unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, mysql56conn;

function databaseConnect(u, p: string): TSQLConnector;
function databaseExecute(q: string): boolean;

var
  databaseConnection: TSQLConnector;
  databaseQuery: TSQLQuery;
  databaseField: TField;

implementation

function databaseConnect(u, p: string): TSQLConnector;
begin
  databaseConnection := TSQLConnector.create(nil);
  with databaseConnection do begin
    connectorType := 'mysql 5.6';
    hostName := 'localhost';
    databaseName := 'chatter';
    userName := u;
    password := p;
    transaction := TSQLTransaction.create(databaseConnection);
  end;
  databaseConnection.free;
  result := databaseConnection;
end;

function databaseExecute(q: string): boolean;
begin
  databaseQuery := TSQLQuery.create(nil);
  databaseQuery.dataBase := databaseConnection;
  databaseQuery.SQL.text := q;
  databaseQuery.open;
  while not databaseQuery.EOF do begin
    for databaseField in databaseQuery.fields do begin
      Write(databaseField.fieldName, ' = ');
      if databaseField.isNull then WriteLn('NULL') else WriteLn(databaseField.value);
    end;
    WriteLn;
    databaseQuery.next;
  end;
  databaseQuery.close;
  databaseQuery.free;
  result := true;
end;

end.
