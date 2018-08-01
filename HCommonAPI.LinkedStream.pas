unit HCommonAPI.LinkedStream;

interface

uses
  System.Classes,
  System.SysUtils,
  HCryptoAPI.Types;

{TODO -oHunter200165 -cTLinkedStream : Do something to complete this class}
  
type
  HCommon_TLinkedStream = class(TStream)
  private
    FParentStream: TStream;
    FOffset: Int64;
    FParentPosition: Int64;
    FPosition: Int64;
    FSize: Int64;
    procedure SetPosition(const Value: Int64);
    function GetRealPos: Int64;
  protected
    property Offset: Int64 read FOffset write FOffset;
    property RealPosition: Int64 read GetRealPos;
    procedure SetSize(const Value: Int64); override;
  public
    property ParentStream: TStream read FParentStream write FParentStream;
    property ParentPosition: Int64 read FParentPosition write FParentPosition;
    property Size: Int64 read FSize write SetSize;
    property Position: Int64 read FPosition write SetPosition;

    procedure SaveParentPosition;
    procedure RestoreParentPosition;

    function Read(var Bytes: TBytesArray; const Count: Integer): Integer; virtual;
    function Write(const Bytes: TBytesArray; const Count: Integer): Integer; virtual;
    procedure ReadBuffer(var Bytes: TBytesArray; const Count: Integer); virtual;
    procedure WriteBuffer(const Buffer: TBytesArray; const Count: Integer); virtual;
    procedure WriteToStream(Stream: TStream; const Count: Integer); virtual;

    constructor Create(Parent: TStream; const Offset: Int64);
  end;

implementation

{ HCommon_TLinkedStream }

const 
  BlockSize: Int64 = 1048576;

constructor HCommon_TLinkedStream.Create(Parent: TStream; const Offset: Int64);
begin
  Self.ParentStream := Parent;
  Self.Offset := Offset;
end;

function HCommon_TLinkedStream.GetRealPos: Int64;
begin
  Result := Offset + Position;
end;

function HCommon_TLinkedStream.Read(var Bytes: TBytesArray; const Count: Integer): Integer;
var SCount: Integer;
begin
  SaveParentPosition;
  ParentPosition := Position + Offset;
  SCount := Position + Count;
  if (Size - SCount) < 0 then
    SCount := Size - Position
  else 
    SCount := Count;
  Result := SCount;
  Position := Position + SCount;
  ParentStream.ReadBuffer(Bytes[0], Count);
  RestoreParentPosition;
end;

procedure HCommon_TLinkedStream.ReadBuffer(var Bytes: TBytesArray; const Count: Integer);
begin
  if Read(Bytes, Count) <> Count then
    raise EReadError.Create('Read size mismatch.');
end;

procedure HCommon_TLinkedStream.RestoreParentPosition;
begin
  ParentPosition := ParentStream.Position;
end;

procedure HCommon_TLinkedStream.SaveParentPosition;
begin
  ParentStream.Position := ParentPosition;
end;

procedure HCommon_TLinkedStream.SetPosition(const Value: Int64);
begin
  if ((Value >= 0) and (Value <= Size)) then
    FPosition := Value
  else 
    raise ERangeError.Create('Position of stream is out of bounds!');
end;

procedure HCommon_TLinkedStream.SetSize(const Value: Int64);
begin
  { Offset = 13; Size = 15; Minimum Length = 28 }
  if Offset + Value < ParentStream.Size then
    raise ERangeError.Create('Size range out of bounds!');  
  FSize := Value;
end;

function HCommon_TLinkedStream.Write(const Bytes: TBytesArray; const Count: Integer): Integer;
var SCount: Integer;
begin
  SaveParentPosition;
  ParentPosition := Position + Offset;
  SCount := Position + Count;
  if (Size - SCount) < 0 then
    Size := Size + (SCount - Size);
  SCount := Count;
  ParentStream.WriteBuffer(Bytes[0], SCount);
  Result := SCount;
  Position := Position + SCount;
end;

procedure HCommon_TLinkedStream.WriteBuffer(const Buffer: TBytesArray; const Count: Integer);
begin
  if Write(Buffer, Count) <> Count then
    raise EWriteError.Create('Write size mismatch.');
end;

procedure HCommon_TLinkedStream.WriteToStream(Stream: TStream; const Count: Integer);
var Buffer: TBytesArray;
    Blocks, Remain, i: Integer;
begin
  Blocks := Count div BlockSize;
  Remain := Count mod BlockSize;
  SetLength(Buffer, BlockSize);
  for i := 1 to Blocks do begin 
    ReadBuffer(Buffer, BlockSize);
    Stream.WriteBuffer(Buffer[0], BlockSize);
  end;
  if Remain > 0 then begin 
    Buffer.Size := Remain;
    ReadBuffer(Buffer, Remain);
    Stream.WriteBuffer(Buffer[0], Remain);
  end;
end;

end.
