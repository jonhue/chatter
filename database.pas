unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, mysql56conn;

function databaseChange(q: string): boolean;
function databaseUpdateString(f, v: string; i: integer): string;
function databaseUpdateInteger(f: string; v, i: integer): integer;
function databaseSelect(f: string; i: integer): TSQLQuery;
function databaseSelectString(f: string; i: integer): string;
function databaseSelectInteger(f: string; i: integer): integer;

implementation
uses Form;

function databaseChange(q: string): boolean;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;

  try
    query.SQL.text := q;
    query.execSQL();
    Form1.MySQL56Connection1.transaction.commit();
  finally
    query.close;
  end;
  result := true;
end;

function databaseUpdateString(f, v: string; i: integer): string;
begin
  databaseChange('UPDATE users SET ' + f + ' = "' + v + '" WHERE id = ' + IntToStr(i) + ';');
  result := v;
end;

function databaseUpdateInteger(f: string; v, i: integer): integer;
begin
  databaseChange('UPDATE users SET ' + f + ' = ' + IntToStr(v) + ' WHERE id = ' + IntToStr(i) + ';');
  result := v;
end;

function databaseSelect(f: string; i: integer): TSQLQuery;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  query.SQL.text := 'SELECT ' + f + ' FROM users WHERE id = ' + IntToStr(i) + ';';
  query.open();
  result := query;
end;

function databaseSelectString(f: string; i: integer): string;
var query: TSQLQuery;
begin
  try
    query := databaseSelect(f, i);
    while not query.Eof do
    begin
      result := query.fieldByName(f).asString;
      query.next;
    end;
  finally
    query.close;
  end;
end;

function databaseSelectInteger(f: string; i: integer): integer;
var query: TSQLQuery;
begin
  try
    query := databaseSelect(f, i);
    while not query.Eof do
    begin
      result := query.fieldByName(f).asInteger;
      query.next;
    end;
  finally
    query.close;
  end;
end;

end.
