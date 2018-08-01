unit HCommonAPI.CompactBoolean;

interface

uses
  System.SysUtils,
  HCommonAPI.Types,
  HCommonAPI.Commons;

type
  HCommon_TCompactBoolean = record
  private
    FCountFromZero: Boolean;
    FStorage: Int64;
    function GetIndexed(Item: Integer): Boolean;
    procedure SetIndexed(Item: Integer; const Value: Boolean);
    function GetIndexedBit(Item: Integer): HCommon_TBit;
    procedure SetIndexedBit(Item: Integer; const Value: HCommon_TBit);
  public
    property Storage: Int64 read FStorage write FStorage;
    property CountFromZero: Boolean read FCountFromZero write FCountFromZero;
    property Indexed[Item: Integer]: Boolean read GetIndexed write SetIndexed; default;
    property Indexed[Item: Integer]: HCommon_TBit read GetIndexedBit write SetIndexedBit; default;
    procedure SetBoolean(Index: Integer; const Value: Boolean);
    function GetBoolean(Index: Integer): Boolean;
  end;

implementation

{ HCommon_TCompactBoolean }

function HCommon_TCompactBoolean.GetBoolean(Index: Integer): Boolean;
begin
  if not CountFromZero then
    Index := Index - 1;
  if not (Index in [0..63]) then
    raise EArgumentException.Create('Index out of range.');
  Result := Boolean(HCommon_GetBit(FStorage, Index));
end;

function HCommon_TCompactBoolean.GetIndexed(Item: Integer): Boolean;
begin
  Result := GetBoolean(Item);
end;

function HCommon_TCompactBoolean.GetIndexedBit(Item: Integer): HCommon_TBit;
begin
  Result := HCommon_TBit(GetBoolean(Item));
end;

procedure HCommon_TCompactBoolean.SetBoolean(Index: Integer; const Value: Boolean);
begin
  if not CountFromZero then
    Index := Index - 1;
  if not (Index in [0..63]) then
    raise EArgumentException.Create('Index out of range.');
  HCommon_SetBit(FStorage, Index, Value);
end;

procedure HCommon_TCompactBoolean.SetIndexed(Item: Integer; const Value: Boolean);
begin
  SetBoolean(Item, Value);
end;

procedure HCommon_TCompactBoolean.SetIndexedBit(Item: Integer; const Value: HCommon_TBit);
begin
  SetBoolean(Item, Boolean(Value));
end;

end.
