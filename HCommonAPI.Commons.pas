unit HCommonAPI.Commons;

interface

uses
  HCryptoAPI.Types,
  System.SysUtils;

function HCommon_GetBit(const Num, Position: Int64): Byte; overload;
procedure HCommon_SetBit(var Num: Int64; const Position: Int64; const Bit: Boolean);

function HCommon_TrimLeft(const Str: string; const Chars: TStringsArray): String;
function HCommon_TrimRight(const Str: string; const Chars: TStringsArray): String;
function HCommon_Trim(const Str: String; const Chars: TStringsArray): String;

implementation

function HCommon_GetBit(const Num, Position: Int64): Byte; overload;
var Temp: Int64;
begin
  Temp := 1 shl Position;
  Temp := (Num and Temp) shr Position;
  Result := Byte(Temp);
end;

procedure HCommon_SetBit(var Num: Int64; const Position: Int64; const Bit: Boolean);
var Temp: Int64;
begin
  Temp := Int64(Bit xor Boolean(HCommon_GetBit(Num, Position)));
  Temp := Temp shl Position;
  Num := Num xor Temp;
end;

function HCommon_TrimLeft(const Str: string; const Chars: TStringsArray): String;
var I, From: Integer;
begin
  From := 1;
  for i := 1 to Str.Length do begin
    if not (Str[i] in Chars.GetRecord) then begin
      From := i;
      break;
    end;
  end;
  Result := Str.Substring(From);
end;

function HCommon_TrimRight(const Str: string; const Chars: TStringsArray): String;
var I, From: Integer;
begin
  From := Str.Length;
  for i := Str.Length downto 1 do begin
    if not (Str[i] in Chars.GetRecord) then begin
      From := i;
      Break;
    end;
  end;
  Result := Str.Substring(1, From);
end;

function HCommon_Trim(const Str: String; const Chars: TStringsArray): String;
begin
  Result := HCommon_TrimLeft(Str, Chars);
  Result := HCommon_TrimRight(Result, Chars);
end;

end.
