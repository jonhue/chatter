unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TGroup }

  TGroup = class
  private
    id: integer;
    name: string;
  protected
    function setId(i: integer): integer;
    function setName(n: string): string;
  public
    // class function find(i: integer): TGroupArray;
    // class function findByName(n: string): TGroupArray;
    constructor create(n: string);
    function getId(): integer;
    function getName(): string;
  end;

  TGroupArray = array of TGroup;

var
  groups: TGroupArray;

implementation

{ TGroup }

function findGroup(i: integer): TGroupArray;
var c: integer; a: TGroupArray;
begin
  for c := 0 to length(groups) - 1 do
      if groups[c].getId() = i then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := groups[c];
         end;
  result := a;
end;

function findGroupByName(n: string): TGroupArray;
var i: integer; a: TGroupArray;
begin
  for i := 0 to length(groups) - 1 do
      if groups[i].getName() = n then
         begin
           setLength(a, length(a) + 1);
           a[length(a) - 1] := groups[i];
         end;
  result := a;
end;

constructor TGroup.create(n: string);
begin
  inherited create();
  self.setName(n);
  repeat
    self.setId(random(999999) + 1);
  until length(findGroup(self.getId())) = 0;
  setLength(groups, length(groups) + 1);
  groups[length(groups) - 1] := self;
end;

function TGroup.getId(): integer;
begin
  result := self.id;
end;

function TGroup.getName(): string;
begin
  result := self.name;
end;

function TGroup.setId(i: integer): integer;
begin
  self.id := i;
  result := self.getId();
end;

function TGroup.setName(n: string): string;
begin
  self.name := n;
  result := self.getName();
end;

end.

