unit HCommonAPI.Intercept;

interface

uses
  HCryptoAPI.Types;

type
  HCommon_InterceptFunc_OnRead = procedure(var Bytes: TBytesArray; Sender: TObject);
  HCommon_InterceptFunc_OnWrite = procedure(var Bytes: TBytesArray; Sender: TObject);
  HCommon_InterceptFunc_OnReadO = procedure(var Bytes: TBytesArray; Sender: TObject) of object;
  HCommon_InterceptFunc_OnWriteO = procedure(var Bytes: TBytesArray; Sender: TObject) of object;
  HCommon_TIntercept = class(TObject)
  private
    FOnRead: HCommon_InterceptFunc_OnRead;
    FOnWrite: HCommon_InterceptFunc_OnWrite;
    FIntercept: HCommon_TIntercept;
  protected
  public
    property Intercept: HCommon_TIntercept read FIntercept write FIntercept;
    property OnRead: HCommon_InterceptFunc_OnRead write FOnRead;
    property OnWrite: HCommon_InterceptFunc_OnWrite write FOnWrite;
    procedure Read(var Bytes: TBytesArray; Sender: TObject);
    procedure Write(var Bytes: TBytesArray; Sender: TObject);
    destructor Destroy; override;
  end;
  { This is convenient implementation, but uses standard base - TIntercept }
  HCommon_TInterceptObject = class(HCommon_TIntercept)
  private
    FOnRead: HCommon_InterceptFunc_OnReadO;
    FOnWrite: HCommon_InterceptFunc_OnWriteO;
  public
    property OnRead: HCommon_InterceptFunc_OnReadO write FOnRead;
    property OnWrite: HCommon_InterceptFunc_OnWriteO write FOnWrite;
    procedure Read(var Bytes: TBytesArray; Sender: TObject);
    procedure Write(var Bytes: TBytesArray; Sender: TObject);
  end;

implementation

{ HCommon_TIntercept }

destructor HCommon_TIntercept.Destroy;
begin
  if Assigned(Intercept) then
    Intercept.Free;
  inherited;
end;

procedure HCommon_TIntercept.Read(var Bytes: TBytesArray; Sender: TObject);
begin
  if Assigned(FOnRead) then
    FOnRead(Bytes, Sender);
  if Assigned(Intercept) then
    Intercept.Read(Bytes, Sender);
end;

procedure HCommon_TIntercept.Write(var Bytes: TBytesArray; Sender: TObject);
begin
  if Assigned(FOnWrite) then
    FOnWrite(Bytes, Sender);
  if Assigned(Intercept) then
    Intercept.Write(Bytes, Sender);
end;

{ HCommon_TInterceptObject }

procedure HCommon_TInterceptObject.Read(var Bytes: TBytesArray; Sender: TObject);
begin
  if Assigned(FOnRead) then
    FOnRead(Bytes, Sender);
  if Assigned(Intercept) then
    Intercept.Read(Bytes, Sender);
end;

procedure HCommon_TInterceptObject.Write(var Bytes: TBytesArray; Sender: TObject);
begin
  if Assigned(FOnWrite) then
    FOnWrite(Bytes, Sender);
  if Assigned(Intercept) then
    Intercept.Write(Bytes, Sender);
end;

end.
