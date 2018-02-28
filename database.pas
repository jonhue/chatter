unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, mysql56conn;

function databaseChange(q: string): boolean;
function databaseUpdateString(t, f, v: string; i: integer): string;
function databaseUpdateInteger(t, f: string; v, i: integer): integer;
function databaseSelect(t, f: string; i: integer): TSQLQuery;
function databaseSelectString(t, f: string; i: integer): string;
function databaseSelectInteger(t, f: string; i: integer): integer;

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

function databaseUpdateString(t, f, v: string; i: integer): string;
begin
  databaseChange('UPDATE ' + t + ' SET ' + f + ' = "' + v + '" WHERE id = ' + IntToStr(i) + ';');
  result := v;
end;

function databaseUpdateInteger(t, f: string; v, i: integer): integer;
begin
  databaseChange('UPDATE ' + t + ' SET ' + f + ' = ' + IntToStr(v) + ' WHERE id = ' + IntToStr(i) + ';');
  result := v;
end;

function databaseSelect(t, f: string; i: integer): TSQLQuery;
var query: TSQLQuery;
begin
  query := TSQLQuery.create(nil);
  query.dataBase := Form1.MySQL56Connection1;
  query.SQL.text := 'SELECT ' + f + ' FROM ' + t + ' WHERE id = ' + IntToStr(i) + ';';
  query.open();
  result := query;
end;

function databaseSelectString(t, f: string; i: integer): string;
var query: TSQLQuery;
begin
  try
    query := databaseSelect(t, f, i);
    while not query.Eof do
    begin
      result := query.fieldByName(f).asString;
      query.next;
    end;
  finally
    query.close;
  end;
end;

function databaseSelectInteger(t, f: string; i: integer): integer;
var query: TSQLQuery;
begin
  try
    query := databaseSelect(t, f, i);
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
