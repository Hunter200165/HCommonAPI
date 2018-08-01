unit HCommonAPI.Container;

interface

uses
  HCryptoAPI.Types;

{ Container is base class for storing data }

type
  HCommon_Container = class(TObject);
  { Useless, but informative class }
  HCommon_BytesContainer = class(HCommon_Container)
  private
    FBytes: TBytesArray;
    function GetSize: Integer;
    procedure SetSize(const Value: Integer);
    function GetIndexer(Item: Integer): Byte;
    procedure SetIndexer(Item: Integer; const Value: Byte);
  protected
  public
    property Bytes: TBytesArray read FBytes write FBytes; 
    property Indexer[Item: Integer]: Byte read GetIndexer write SetIndexer; default;
    property Size: Integer read GetSize write SetSize;
    constructor Create(Size: Integer = 0);
  end;

implementation

{ HCommon_BytesContainer }

constructor HCommon_BytesContainer.Create(Size: Integer);
begin
  inherited Create;
  Self.Size := Size;
end;

function HCommon_BytesContainer.GetIndexer(Item: Integer): Byte;
begin
  Result := FBytes[Item];
end;

function HCommon_BytesContainer.GetSize: Integer;
begin
  Result := Length(FBytes);
end;

procedure HCommon_BytesContainer.SetIndexer(Item: Integer; const Value: Byte);
begin
  FBytes[Item] := Value;
end;

procedure HCommon_BytesContainer.SetSize(const Value: Integer);
begin
  SetLength(FBytes, Value);
end;

end.
