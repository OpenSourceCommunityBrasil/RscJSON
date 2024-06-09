{=======================================}
{             RSC SISTEMAS              }
{        SOLUÇÕESES TECNOLÓGICAS        }
{         rscsistemas.com.br            }
{          +55 92 4141-2737             }
{      contato@rscsistemas.com.br       }
{                                       }
{ Desenvolvidor por:                    }
{   Roniery Santos Cardoso              }
{     roniery@rscsistemas.com.br        }
{     +55 92 984391279                  }
{                                       }
{                                       }
{ VersÃ£o Original RSC SISTEMAS          }
{ VersÃ£o: 4.5.2 - 2024                  }
{                                       }
{                                       }
{=======================================}


unit RscJSON;

interface

{$IF CompilerVersion >= 20} // Delphi 2009 and newer
  {$LEGACYIFEND ON}
{$IFEND}

uses
{$IF CompilerVersion < 24} // Delphi XE2 and older
  Windows,
{$IFEND}
  SysUtils,
  Classes,
  Variants,
  Math,
  StrUtils;

type
  TRscJSONtypes = (jsBase, jsNumber, jsString, jsWideString, jsBoolean, jsNull, jsList, jsObject);

  TRscJSONbase = class
  private
    Function  InGetValue(const aValue: TRscJSONtypes) : Variant;
    procedure InSetValue(const AValue: variant; const DataType: TRscJSONtypes);

    function GetAsInteger: Integer;
    procedure SetAsInteger(const aValue: Integer);
    function GetAsInt64: Int64;
    procedure SetAsInt64(const aValue: Int64);
    function GetAsString: string;
    procedure SetAsString(const aValue: string);
    function GetAsWideString: WideString;
    procedure SetAsWideString(const aValue: WideString);
    function GetAsDouble: Double;
    procedure SetAsDouble(const aValue: Double);
    function GetAsBoolean: Boolean;
    procedure SetAsBoolean(const aValue: Boolean);

  protected

    function  GetAValue: variant; virtual;
    procedure SetValue(const AValue: variant); virtual;

    function  GetCount: Integer; virtual;
    function  GetChild(idx: Integer): TRscJSONbase; virtual;
    procedure SetChild(idx: Integer; const AValue: TRscJSONbase); virtual;
    function  GetField(AName: Variant):TRscJSONbase; virtual;
  public
    property Count: Integer read GetCount;
    property Field[AName: Variant]: TRscJSONbase read GetField;
    property Child[idx: Integer]: TRscJSONbase read GetChild write SetChild;
    property Value: variant read GetAValue write SetValue;

    class function SelfType: TRscJSONtypes; virtual;
    class function SelfTypeName: string; virtual;

    function ToJson: string;
    procedure SaveToStream(dst: TStream);
    procedure SaveToFile(dstname: string);

    Property AsInteger          : Integer          Read GetAsInteger        Write SetAsInteger;
    Property AsInt64            : Int64            Read GetAsInt64          Write SetAsInt64;
    Property AsString           : string           Read GetAsString         Write SetAsString;
    Property AsWideString       : WideString       Read GetAsWideString     Write SetAsWideString;
    Property AsDouble           : Double           Read GetAsDouble         Write SetAsDouble;
    Property AsBoolean          : Boolean          Read GetAsBoolean        Write SetAsBoolean;

  end;

  TRscJSONnumber = class(TRscJSONbase)
  protected
    FValue: extended;
    function GetAValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: extended = 0): TRscJSONnumber;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONstring = class(TRscJSONbase)
  protected
    FValue: WideString;
    function GetAValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(const wsValue: WideString = ''): TRscJSONstring;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONWidestring = class(TRscJSONbase)
  protected
    FValue: WideString;
    function GetAValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(const wsValue: WideString = ''): TRscJSONWidestring;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONboolean = class(TRscJSONbase)
  protected
    FValue: Boolean;
    function GetAValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
  public
    procedure AfterConstruction; override;
    class function Generate(AValue: Boolean = true): TRscJSONboolean;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONnull = class(TRscJSONbase)
  protected
    function GetAValue: Variant; override;
    function Generate: TRscJSONnull;
  public
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONFuncEnum = procedure(ElName: string; Elem: TRscJSONbase; data: pointer; var Continue: Boolean) of object;

  TRscJSONCustomArray = class(TRscJSONbase)
  protected
    fList: TList;
    function GetCount: Integer; override;
    function GetChild(idx: Integer): TRscJSONbase; override;
    procedure SetChild(idx: Integer; const AValue: TRscJSONbase); override;
    function ForEachElement(idx: Integer; var nm: string): TRscJSONbase; virtual;

    function GetField(AName: Variant):TRscJSONbase; override;
    function GetValue(const Index: Integer): TRscJSONbase;

    function _Add(obj: TRscJSONbase): Integer; virtual;
    procedure _Delete(iIndex: Integer); virtual;
    function _IndexOf(obj: TRscJSONbase): Integer; virtual;
  public
    procedure ForEach(fnCallBack: TRscJSONFuncEnum; pUserData: pointer);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function getInt64(idx: Integer): Int64; virtual;
    function getInt(idx: Integer): Integer; virtual;
    function getString(idx: Integer): string; virtual;
    function getWideString(idx: Integer): WideString; virtual;
    function getDouble(idx: Integer): Double; virtual;
    function getBoolean(idx: Integer): Boolean; virtual;
    function getRscJSONbase(idx: Integer): TRscJSONbase; virtual;

    property Items[const Index: Integer]: TRscJSONbase read GetValue; default;

  end;

  TRscJSONArray = class(TRscJSONCustomArray)
  protected
  public
    function Add(const Elemento: TRscJSONbase): Integer; overload;
    function Add(const Elemento: Boolean): Integer; overload;
    function Add(const Elemento: double): Integer; overload;
    function Add(const Elemento: string): Integer; overload;
    function Add(const Elemento: WideString): Integer; overload;
    function Add(const Elemento: Integer): Integer; overload;
    function Add(const Elemento: Int64): Integer; overload;

    procedure Delete(idx: Integer);
    function IndexOf(obj: TRscJSONbase): Integer;
    class function Generate: TRscJSONArray;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;
  end;

  TRscJSONobjectmethod = class(TRscJSONbase)
  protected
    FValue: TRscJSONbase;
    FName: string;
    procedure SetName(const AValue: string);
  public
    property ObjValue: TRscJSONbase read FValue;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Name: string read FName write SetName;
    class function Generate(const aname: WideString; aobj: TRscJSONbase): TRscJSONobjectmethod;
  end;

  TRscJSONobject = class(TRscJSONCustomArray)
  protected
    function GetNameOf(idx: Integer): string;
    function ForEachElement(idx: Integer; var nm: string): TRscJSONbase; override;
    function GetField(AName: Variant):TRscJSONbase; override;

  public
    function AddPair(const aName: string; const aValue: TRscJSONbase): Integer; overload;
    function AddPair(const aName: string; const aValue: Boolean): Integer; overload;
    function AddPair(const aName: string; const aValue: double): Integer; overload;
    function AddPair(const aName: string; const aValue: string): Integer; overload;
    function AddPair(const aName: string; const aValue: WideString): Integer; overload;
    function AddPair(const aName: string; const aValue: Integer): Integer; overload;
    function AddPair(const aName: string; const aValue: Int64): Integer; overload;

    procedure RemovePair(Index: Integer); overload;
    procedure RemovePair(Name: string); overload;

    function IndexOfName(const aName: string): Integer;
    function IndexOfObject(aobj: TRscJSONbase): Integer;

    property NameOf[idx: Integer]: string read GetNameOf;

    constructor Create;
    destructor Destroy; override;

    class function Generate: TRscJSONobject;
    class function SelfType: TRscJSONtypes; override;
    class function SelfTypeName: string; override;

    function GetValue(Name: string): TRscJSONbase; overload;
    function GetValue(Index: integer): TRscJSONbase; overload;

  end;

  TRscJSON = class
  public
    class function LoadFromString(const JsonStr: string): TRscJSONbase;
    class function LoadFromStream(src: TStream): TRscJSONbase;
    class procedure SaveToStream(obj: TRscJSONbase; dst: TStream);
    class function LoadFromFile(srcname: string): TRscJSONbase;
    class procedure SaveToFile(obj: TRscJSONbase; dstname: string);
  end;

  function GenerateReadableText(vObj: TRscJSONbase; var vLevel:  Integer): string;

implementation

type
  ERscIntException = class(Exception)
  public
    idx: Integer;
    constructor Create(idx: Integer; msg: string);
  end;

function IsCharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  {$IF CompilerVersion >= 20} // Delphi 2009 and newer
    Result := CharInSet(C, CharSet);
  {$ELSE}
    Result := C in CharSet;
  {$IFEND}
end;

function Indent(vTab: Integer): string;
begin
  result := DupeString('  ', vTab);
end;

function GenerateReadableText(vObj: TRscJSONbase; var vLevel:
  Integer): string;
var
  i: Integer;
  vStr: string;
  xs: TRscJSONstring;
begin
  vLevel := vLevel + 1;
  if vObj is TRscJSONobject then
    begin
      vStr := '';
      for i := 0 to TRscJSONobject(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
            GenerateReadableText(TRscJSONobject(vObj).Child[i], vLevel);
        end;
      if vStr <> '' then
        begin
          vStr := '{'#13#10 + vStr + #13#10 + Indent(vLevel - 1) + '}';
        end
      else
        begin
          vStr := '{}';
        end;
      result := vStr;
    end
  else if vObj is TRscJSONArray then
    begin
      vStr := '';
      for i := 0 to TRscJSONArray(vObj).Count - 1 do
        begin
          if vStr <> '' then
            begin
              vStr := vStr + ','#13#10;
            end;
          vStr := vStr + Indent(vLevel) +
              GenerateReadableText(TRscJSONArray(vObj).Child[i], vLevel);
        end;
      if vStr <> '' then
        begin
          vStr := '['#13#10 + vStr + #13#10 + Indent(vLevel - 1) + ']';
        end
      else
        begin
          vStr := '[]';
        end;
      result := vStr;
    end
  else if vObj is TRscJSONobjectmethod then
    begin
      vStr := '';
      xs := TRscJSONstring.Create;
      try
        xs.Value := TRscJSONobjectmethod(vObj).Name;
        vStr := GenerateReadableText(xs, vLevel);
        vLevel := vLevel - 1;
        vStr := vStr + ':' + GenerateReadableText(TRscJSONbase(
          TRscJSONobjectmethod(vObj).ObjValue), vLevel);
        vLevel := vLevel + 1;
        result := vStr;
      finally
        xs.Free;
      end;
    end
  else
    begin
      if vObj is TRscJSONobjectmethod then
        begin
          if TRscJSONobjectmethod(vObj).Name <> '' then
            begin
            end;
        end;
      result := vObj.ToJson;
    end;
  vLevel := vLevel - 1;
end;

{$IF CompilerVersion >= 20.0} // Delphi 2009 and later
function code2utf(iNumber: Integer): string;
{$ELSE}
function code2utf(iNumber: Integer): UTF8String;
{$IFEND}
begin
  if iNumber < 128 then Result := chr(iNumber)
  else if iNumber < 2048 then
    Result := chr((iNumber shr 6) + 192) + chr((iNumber and 63) + 128)
  else if iNumber < 65536 then
    Result := chr((iNumber shr 12) + 224) + chr(((iNumber shr 6) and
      63) + 128) + chr((iNumber and 63) + 128)
  else if iNumber < 2097152 then
    Result := chr((iNumber shr 18) + 240) + chr(((iNumber shr 12) and
      63) + 128) + chr(((iNumber shr 6) and 63) + 128) +
      chr((iNumber and 63) + 128);
end;

{ TlkJSONbase }

function TRscJSONbase.GetAsInteger: Integer;
begin
  Result  :=  InGetValue(jsNumber);
end;

procedure TRscJSONbase.SetAsInteger(const aValue: Integer);
begin
  InSetValue(aValue, jsNumber);
end;

function TRscJSONbase.GetAsInt64: Int64;
begin
  Result  :=  InGetValue(jsNumber);
end;

procedure TRscJSONbase.SetAsInt64(const aValue: Int64);
begin
  InSetValue(aValue, jsNumber);
end;

function TRscJSONbase.GetAsString: string;
begin
  Result  :=  InGetValue(jsString);
end;

procedure TRscJSONbase.SetAsString(const aValue: string);
begin
  InSetValue(aValue, jsString);
end;

function TRscJSONbase.GetAsWideString: WideString;
begin
  Result  :=  InGetValue(jsWideString);
end;

procedure TRscJSONbase.SetAsWideString(const aValue: WideString);
begin
  InSetValue(aValue, jsWideString);
end;

function TRscJSONbase.GetAsDouble: Double;
begin
  Result  :=  InGetValue(jsNumber);
end;

procedure TRscJSONbase.SetAsDouble(const aValue: Double);
begin
  InSetValue(aValue, jsNumber);
end;

function TRscJSONbase.GetAsBoolean: Boolean;
begin
  Result  :=  InGetValue(jsBoolean);
end;

procedure TRscJSONbase.SetAsBoolean(const aValue: Boolean);
begin
  InSetValue(aValue, jsBoolean);
end;

//--------------------------==============================

function TRscJSONbase.GetChild(idx: Integer): TRscJSONbase;
begin
  result := nil;
end;

procedure TRscJSONbase.SetChild(idx: Integer; const AValue:
  TRscJSONbase);
begin

end;

function TRscJSONbase.GetCount: Integer;
begin
  result := 0;
end;

function TRscJSONbase.GetField(AName: Variant):TRscJSONbase;
begin
  result := self;
end;

function TRscJSONbase.GetAValue: variant;
begin
  result := variants.Null;
end;

function TRscJSONbase.InGetValue(const aValue: TRscJSONtypes): Variant;
var
{$IF CompilerVersion <= 15} //Delphi 6 and old
  DecimalSeparator: Char;
  ThousandSeparator: Char;
  DateSeparator: Char;
  TimeSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
{$ELSE}
  fs: TFormatSettings;
{$IFEND}
begin
  {$IF CompilerVersion >= 24} // Delphi XE3 and newer
    {$IF Defined(MSWINDOWS)}
      fs := TFormatSettings.Create('pt-BR');
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$ELSE}
      fs := TFormatSettings.Invariant; // Use invariant settings for non-Windows platforms
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$IFEND}
  {$ELSEIF CompilerVersion >= 16} // Delphi 6 do not have GetLocaleFormatSettings
    GetLocaleFormatSettings(GetThreadLocale, fs);
    fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
  {$ELSE}
  DecimalSeparator := SysUtils.DecimalSeparator;
  ThousandSeparator := SysUtils.ThousandSeparator;
  DateSeparator  := SysUtils.DateSeparator;
  TimeSeparator  := SysUtils.TimeSeparator;
  ShortDateFormat  := SysUtils.ShortDateFormat;
  LongDateFormat  := SysUtils.LongDateFormat;
  ShortTimeFormat := SysUtils.ShortDateFormat;
  LongTimeFormat  := SysUtils.LongTimeFormat;
  {$IFEND}
  try
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := '.';
    SysUtils.ThousandSeparator := ',';
    SysUtils.DateSeparator := '/';
    SysUtils.TimeSeparator := ':';
    SysUtils.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.LongDateFormat := 'dddd, dd mmmm yyyy';
    SysUtils.ShortDateFormat := 'hh:nn';
    SysUtils.LongTimeFormat := 'hh:nn:ss';
    {$IFEND}

    Result  :=  Null;
    case aValue of
      jsBase    :
        begin
          if  Self <> nil then
            Result  :=  Self.Value;
        end;
      jsNumber  :
        begin
          if  Self <> nil then
            {$IF CompilerVersion >= 16} //Delphi 7 and last
            Result  :=  StrToFloat(VarToStr(Self.Value), fs)
            {$ELSE}
            Result  :=  StrToFloat(VarToStr(Self.Value))
            {$IFEND}
          else
            Result  :=  0;
        end;
      jsString  :
        begin
          if  Self <> nil then
            begin
              if VarIsNull(Self.Value) then
                Result  :=  'null'
              else
                Result  :=  Self.Value;
            end
          else
            begin
              Result  :=  '';
            end
        end;
      jsWideString  :
        begin
          if  Self <> nil then
            begin
              if VarIsNull(Self.Value) then
                Result  :=  'null'
              else
                Result  :=  Self.Value;
            end
          else
            begin
              Result  :=  '';
            end
        end;
      jsBoolean :
        begin
          if  Self <> nil then
            Result := (Self.Value = '1')  Or (Lowercase(Self.Value) = 'true')
          else
            Result  :=  False;
        end;
      jsNull    :
        begin
          if  Self <> nil then
            Result  :=  Self.Value
          else
            Result  :=  Null;
        end;
      jsList    :
        begin
          if  Self <> nil then
            Result  :=  Self.Value;
        end;
      jsObject  :
        begin
          if  Self <> nil then
            Result  :=  Self.Value
          else
            Result  :=  Null;
        end;
    end;

  finally
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := DecimalSeparator;
    SysUtils.ThousandSeparator := ThousandSeparator;
    SysUtils.DateSeparator := DateSeparator;
    SysUtils.TimeSeparator := TimeSeparator;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongDateFormat := LongDateFormat;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongTimeFormat := LongTimeFormat;
    {$IFEND}  
  end;
end;

procedure TRscJSONbase.InSetValue(const AValue: variant;
  const DataType: TRscJSONtypes);
begin
  case DataType of
    jsBase    :
      begin
        Self.Value  :=  AValue;
      end;
    jsNumber  :
      begin
        Self.Value  :=  AValue;
      end;
    jsString  :
      begin
        if VarIsNull(AValue) then
          Self.Value  :=  ''
        else
          Self.Value  :=  AValue;
      end;
    jsWideString  :
      begin
        if VarIsNull(AValue) then
          Self.Value  :=  ''
        else
          Self.Value  :=  AValue;
      end;
    jsBoolean :
      begin
        If Boolean(AValue) then
          Self.Value  :=  'true'
        else
          Self.Value  :=  'false';
      end;
    jsNull    :
      begin
        Self.Value  :=  Null;
      end;
    jsList    :
      begin
        Self.Value  :=  AValue;
      end;
    jsObject  :
      begin
        Self.Value  :=  AValue;
      end;
  end;
end;

procedure TRscJSONbase.SetValue(const AValue: variant);
begin

end;

class function TRscJSONbase.SelfType: TRscJSONtypes;
begin
  result := jsBase;
end;

class function TRscJSONbase.SelfTypeName: string;
begin
  result := 'jsBase';
end;

function TRscJSONbase.ToJson: string;
var
{$IF CompilerVersion <= 15} //Delphi 6 and old
  DecimalSeparator: Char;
  ThousandSeparator: Char;
  DateSeparator: Char;
  TimeSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
{$ELSE}
  fs: TFormatSettings;
{$IFEND}
  pt1, pt0, pt2: PChar;
  ptsz: cardinal;

  procedure get_more_memory;
  var
    delta: cardinal;
  begin
    delta := 50000;
    if pt0 = nil then
      begin
        pt0 := AllocMem(delta);
        ptsz := 0;
        pt1 := pt0;
      end
    else
      begin
        ReallocMem(pt0, ptsz + delta);
        {$IF CompilerVersion >= 20.0} // Delphi 2009 and later
        pt1 := Pointer(NativeUInt(pt0) + ptsz); // Correção na atribuição de pt1
        {$ELSE}
        pt1 := pointer(cardinal(pt0) + ptsz);
        {$IFEND}

      end;
    ptsz := ptsz + delta;
    {$IF CompilerVersion >= 20.0} // Delphi 2009 and later
    pt2 := Pointer(NativeUInt(pt1) + delta); // CorreÃ§Ã£o na atribuiÃ§Ã£o de pt2
    {$ELSE}
    pt2 := pointer(cardinal(pt1) + delta);
    {$IFEND}

  end;

  procedure mem_ch(ch: char);
  begin
    if pt1 >= pt2 then
      get_more_memory;

      pt1^ := ch;
    inc(pt1);
  end;

  procedure mem_write(rs: string);
  var
    i: Integer;
  begin
    for i := 1 to length(rs) do
      begin
        if pt1 >= pt2 then get_more_memory;
        pt1^ := rs[i];
        inc(pt1);
      end;
  end;

  procedure gn_base(obj: TRscJSONbase);
  var
    ws: string;
    i, j: Integer;
    xs: TRscJSONstring;
  begin
    if not assigned(obj) then exit;
    if obj is TRscJSONnumber then
      begin
        {$IF CompilerVersion >= 16} //Delphi 7 and last
        mem_write(FloatToStr(TRscJSONnumber(obj).FValue, fs));
        {$ELSE}
        mem_write(FloatToStr(TRscJSONnumber(obj).FValue));
        {$IFEND}
      end
    else if obj is TRscJSONstring then
      begin
        ws := TRscJSONstring(obj).FValue;
        i := 1;
        mem_ch('"');
        while i <= length(ws) do
          begin
            case ws[i] of
              '/', '\', '"':
                begin
                  mem_ch('\');
                  mem_ch(ws[i]);
                end;
              #8: mem_write('\b');
              #9: mem_write('\t');
              #10: mem_write('\n');
              #13: mem_write('\r');
              #12: mem_write('\f');
            else
              if ord(ws[i]) < 32 then
                mem_write('\u' + inttohex(ord(ws[i]), 4))
              else
                mem_ch(ws[i]);
            end;
            inc(i);
          end;
        mem_ch('"');
      end
    else if obj is TRscJSONWidestring then
      begin
        ws := TRscJSONWidestring(obj).FValue;
        i := 1;
        mem_ch('"');
        while i <= length(ws) do
          begin
            case ws[i] of
              '/', '\', '"':
                begin
                  mem_ch('\');
                  mem_ch(ws[i]);
                end;
              #8: mem_write('\b');
              #9: mem_write('\t');
              #10: mem_write('\n');
              #13: mem_write('\r');
              #12: mem_write('\f');
            else
              if ord(ws[i]) < 32 then
                mem_write('\u' + inttohex(ord(ws[i]), 4))
              else
                mem_ch(ws[i]);
            end;
            inc(i);
          end;
        mem_ch('"');
      end
    else if obj is TRscJSONboolean then
      begin
        if TRscJSONboolean(obj).FValue then
          mem_write('true')
        else
          mem_write('false');
      end
    else if obj is TRscJSONnull then
      begin
        mem_write('null');
      end
    else if obj is TRscJSONArray then
      begin
        mem_ch('[');
        j := TRscJSONobject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TRscJSONArray(obj).Child[i]);
          end;
        mem_ch(']');
      end
    else if obj is TRscJSONobjectmethod then
      begin
        try
          xs := TRscJSONstring.Create;
          xs.FValue := TRscJSONobjectmethod(obj).FName;
          gn_base(TRscJSONbase(xs));
          mem_ch(':');
          gn_base(TRscJSONbase(TRscJSONobjectmethod(obj).FValue));
        finally
          if assigned(xs) then FreeAndNil(xs);
        end;
      end
    else if obj is TRscJSONobject then
      begin
        mem_ch('{');
        j := TRscJSONobject(obj).Count - 1;
        for i := 0 to j do
          begin
            if i > 0 then mem_ch(',');
            gn_base(TRscJSONobject(obj).Child[i]);
          end;
        mem_ch('}');
      end;
  end;

begin
  {$IF CompilerVersion >= 24} // Delphi XE3 and newer
    {$IF Defined(MSWINDOWS)}
      fs := TFormatSettings.Create('pt-BR');
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$ELSE}
      fs := TFormatSettings.Invariant; // Use invariant settings for non-Windows platforms
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$IFEND}
  {$ELSEIF CompilerVersion >= 16} // Delphi 6 do not have GetLocaleFormatSettings
    GetLocaleFormatSettings(GetThreadLocale, fs);
    fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
  {$ELSE}
  DecimalSeparator := SysUtils.DecimalSeparator;
  ThousandSeparator := SysUtils.ThousandSeparator;
  DateSeparator  := SysUtils.DateSeparator;
  TimeSeparator  := SysUtils.TimeSeparator;
  ShortDateFormat  := SysUtils.ShortDateFormat;
  LongDateFormat  := SysUtils.LongDateFormat;
  ShortTimeFormat := SysUtils.ShortDateFormat;
  LongTimeFormat  := SysUtils.LongTimeFormat;
  {$IFEND}

  try
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := '.';
    SysUtils.ThousandSeparator := ',';
    SysUtils.DateSeparator := '/';
    SysUtils.TimeSeparator := ':';
    SysUtils.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.LongDateFormat := 'dddd, dd mmmm yyyy';
    SysUtils.ShortDateFormat := 'hh:nn';
    SysUtils.LongTimeFormat := 'hh:nn:ss';
    {$IFEND}
    pt0 := nil;
    get_more_memory;
    gn_base(Self);
    mem_ch(#0);
    result := string(pt0);
    freemem(pt0);
  finally
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := DecimalSeparator;
    SysUtils.ThousandSeparator := ThousandSeparator;
    SysUtils.DateSeparator := DateSeparator;
    SysUtils.TimeSeparator := TimeSeparator;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongDateFormat := LongDateFormat;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongTimeFormat := LongTimeFormat;
    {$IFEND}
  end;
end;  

procedure TRscJSONbase.SaveToFile(dstname: string);
var
  fs: TFileStream;
begin
  try
    fs := TFileStream.Create(dstname, fmCreate);
    SaveToStream(fs);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

procedure TRscJSONbase.SaveToStream(dst: TStream);
var
  ws: string;
begin
  if not assigned(dst) then exit;
  ws := Self.ToJson;
  dst.Write(pchar(ws)^, length(ws));
end;

{ TlkJSONnumber }

procedure TRscJSONnumber.AfterConstruction;
begin
  inherited;
  FValue := 0;
end;

class function TRscJSONnumber.Generate(AValue: extended):
  TRscJSONnumber;
begin
  result := TRscJSONnumber.Create;
  result.FValue := AValue;
end;

function TRscJSONnumber.GetAValue: Variant;
begin
  result := FValue;
end;

class function TRscJSONnumber.SelfType: TRscJSONtypes;
begin
  result := jsNumber;
end;

class function TRscJSONnumber.SelfTypeName: string;
begin
  result := 'jsNumber';
end;

procedure TRscJSONnumber.SetValue(const AValue: Variant);
begin
  FValue := VarAsType(AValue, varDouble);
end;

{ TlkJSONstring }

procedure TRscJSONstring.AfterConstruction;
begin
  inherited;
  FValue := '';
end;

class function TRscJSONstring.Generate(const wsValue: WideString):
  TRscJSONstring;
begin
  result := TRscJSONstring.Create;
  result.FValue := wsValue;
end;

function TRscJSONstring.GetAValue: Variant;
begin
  result := FValue;
end;

class function TRscJSONstring.SelfType: TRscJSONtypes;
begin
  result := jsString;
end;

class function TRscJSONstring.SelfTypeName: string;
begin
  result := 'jsString';
end;

procedure TRscJSONstring.SetValue(const AValue: Variant);
begin
  FValue := VarToWideStr(AValue);
end;

{ TRscJSONWidestring }

procedure TRscJSONWidestring.AfterConstruction;
begin
  inherited;
  FValue := '';
end;

class function TRscJSONWidestring.Generate(
  const wsValue: WideString): TRscJSONWidestring;
begin
  result := TRscJSONWidestring.Create;
  result.FValue := wsValue;
end;

function TRscJSONWidestring.GetAValue: Variant;
begin
  result := FValue;
end;

class function TRscJSONWidestring.SelfType: TRscJSONtypes;
begin
  result := jsWideString;
end;

class function TRscJSONWidestring.SelfTypeName: string;
begin
  result := 'jsWideString';
end;

procedure TRscJSONWidestring.SetValue(const AValue: Variant);
begin
  FValue := VarToWideStr(AValue);
end;

{ TlkJSONboolean }

procedure TRscJSONboolean.AfterConstruction;
begin
  FValue := false;
end;

class function TRscJSONboolean.Generate(AValue: Boolean):
  TRscJSONboolean;
begin
  result := TRscJSONboolean.Create;
  result.Value := AValue;
end;

function TRscJSONboolean.GetAValue: Variant;
begin
  result := FValue;
end;

class function TRscJSONboolean.SelfType: TRscJSONtypes;
begin
  Result := jsBoolean;
end;

class function TRscJSONboolean.SelfTypeName: string;
begin
  Result := 'jsBoolean';
end;

procedure TRscJSONboolean.SetValue(const AValue: Variant);
begin
  FValue := boolean(AValue);
end;

{ TlkJSONnull }

function TRscJSONnull.Generate: TRscJSONnull;
begin
  result := TRscJSONnull.Create;
end;

function TRscJSONnull.GetAValue: Variant;
begin
  result := variants.Null;
end;

class function TRscJSONnull.SelfType: TRscJSONtypes;
begin
  result := jsNull;
end;

class function TRscJSONnull.SelfTypeName: string;
begin
  result := 'jsNull';
end;

{ TlkJSONcustomlist }

function TRscJSONCustomArray._Add(obj: TRscJSONbase): Integer;
begin
  if not Assigned(obj) then
    begin
      result := -1;
      exit;
    end;
  result := fList.Add(obj);
end;

procedure TRscJSONCustomArray.AfterConstruction;
begin
  inherited;
  fList := TList.Create;
end;

procedure TRscJSONCustomArray.BeforeDestruction;
var
  i: Integer;
begin
  for i := (Count - 1) downto 0 do _Delete(i);
  fList.Free;
  inherited;
end;

procedure TRscJSONCustomArray._Delete(iIndex: Integer);
var
  idx: Integer;
begin
  if not ((iIndex < 0) or (iIndex >= Count)) then
    begin
      if fList.Items[iIndex] <> nil then
        TRscJSONbase(fList.Items[iIndex]).Free;
      idx := pred(fList.Count);
      if iIndex<idx then
        begin
          fList.Items[iIndex] := fList.Items[idx];
          fList.Delete(idx);
        end
      else
        begin
          fList.Delete(iIndex);
        end;
    end;
end;

function TRscJSONCustomArray.GetChild(idx: Integer): TRscJSONbase;
begin
  if (idx < 0) or (idx >= Count) then
    begin
      result := nil;
    end
  else
    begin
      result := fList.Items[idx];
    end;
end;

function TRscJSONCustomArray.GetCount: Integer;
begin
  result := fList.Count;
end;

function TRscJSONCustomArray._IndexOf(obj: TRscJSONbase): Integer;
begin
  result := fList.IndexOf(obj);
end;

procedure TRscJSONCustomArray.SetChild(idx: Integer; const AValue:
  TRscJSONbase);
begin
  if not ((idx < 0) or (idx >= Count)) then
    begin
      if fList.Items[idx] <> nil then
        TRscJSONbase(fList.Items[idx]).Free;
      fList.Items[idx] := AValue;
    end;
end;

procedure TRscJSONCustomArray.ForEach(fnCallBack: TRscJSONFuncEnum;
  pUserData:
  pointer);
var
  iCount: Integer;
  IsContinue: Boolean;
  anJSON: TRscJSONbase;
  wsObject: string;
begin
  if not assigned(fnCallBack) then exit;
  IsContinue := true;
  for iCount := 0 to GetCount - 1 do
    begin
      anJSON := ForEachElement(iCount, wsObject);
      if assigned(anJSON) then
        fnCallBack(wsObject, anJSON, pUserData, IsContinue);
      if not IsContinue then break;
    end;
end;

function TRscJSONCustomArray.GetField(AName: Variant):TRscJSONbase;
var
  index: Integer;
begin
  if VarIsNumeric(AName) then
    begin
      index := integer(AName);
      result := GetChild(index);
    end
  else
    begin
      result := inherited GetField(AName);
    end;
end;

function TRscJSONCustomArray.GetValue(const Index: Integer): TRscJSONbase;
begin
  Result := GetChild(index);
end;

function TRscJSONCustomArray.ForEachElement(idx: Integer; var nm:
  string): TRscJSONbase;
begin
  nm := inttostr(idx);
  result := GetChild(idx);
end;

function TRscJSONCustomArray.getInt64(idx: Integer): Int64;
var
  jn: TRscJSONnumber;
begin
  jn := Child[idx] as TRscJSONnumber;
  if not assigned(jn) then result := 0
  else result := round(int(jn.Value));
end;

function TRscJSONCustomArray.getInt(idx: Integer): Integer;
var
  jn: TRscJSONbase;
begin
  try
    jn := Child[idx] as TRscJSONnumber;
    if not assigned(jn) then result := 0
    else result := round(int(jn.Value));
  except
    result := 0;
  end;
end;

function TRscJSONCustomArray.getString(idx: Integer): string;
var
  js: TRscJSONstring;
begin
  js := Child[idx] as TRscJSONstring;
  if not assigned(js) then result := ''
  else result := VarToStr(js.Value);
end;

function TRscJSONCustomArray.getWideString(idx: Integer): WideString;
var
  js: TRscJSONWidestring;
begin
  js := Child[idx] as TRscJSONWidestring;
  if not assigned(js) then result := ''
  else result := VarToWideStr(js.Value);
end;

function TRscJSONCustomArray.getDouble(idx: Integer): Double;
var
  jn: TRscJSONnumber;
begin
  jn := Child[idx] as TRscJSONnumber;
  if not assigned(jn) then result := 0
  else result := jn.Value;
end;

function TRscJSONCustomArray.getBoolean(idx: Integer): Boolean;
var
  jb: TRscJSONboolean;
begin
  jb := Child[idx] as TRscJSONboolean;
  if not assigned(jb) then result := false
  else result := jb.Value;
end;

function TRscJSONCustomArray.getRscJSONbase(idx: Integer): TRscJSONbase;
var
  jb: TRscJSONbase;
begin
  jb := Child[idx] as TRscJSONbase;
  if not assigned(jb) then result := nil
  else result := jb;
end;

{ TRscJSONobjectmethod }

procedure TRscJSONobjectmethod.AfterConstruction;
begin
  inherited;
  FValue := nil;
  FName := '';
end;

procedure TRscJSONobjectmethod.BeforeDestruction;
begin
  FName := '';
  if FValue <> nil then
    begin
      FValue.Free;
      FValue := nil;
    end;
  inherited;
end;

class function TRscJSONobjectmethod.Generate(const aname: WideString;
  aobj: TRscJSONbase): TRscJSONobjectmethod;
begin
  result := TRscJSONobjectmethod.Create;
  result.FName := aname;
  result.FValue := aobj;
end;

procedure TRscJSONobjectmethod.SetName(const AValue: string);
begin
  FName := AValue;
end;

{ TRscJSONlist }

function TRscJSONArray.Add(const Elemento: TRscJSONbase): Integer;
begin
  result := _Add(Elemento);
end;

function TRscJSONArray.Add(const Elemento: Boolean): Integer;
begin
  Result := self.Add(TRscJSONboolean.Generate(Elemento));
end;

function TRscJSONArray.Add(const Elemento: double): Integer;
begin
  Result := self.Add(TRscJSONnumber.Generate(Elemento));
end;

function TRscJSONArray.Add(const Elemento: string): Integer;
begin
  Result := self.Add(TRscJSONstring.Generate(Elemento));
end;

function TRscJSONArray.Add(const Elemento: WideString): Integer;
begin
  Result := self.Add(TRscJSONWidestring.Generate(Elemento));
end;

function TRscJSONArray.Add(const Elemento: Integer): Integer;
begin
  Result := self.Add(TRscJSONnumber.Generate(Elemento));
end;

function TRscJSONArray.Add(const Elemento: Int64): Integer;
begin
  Result := self.Add(TRscJSONnumber.Generate(Elemento));
end;  

procedure TRscJSONArray.Delete(idx: Integer);
begin
  _Delete(idx);
end;

class function TRscJSONArray.Generate: TRscJSONArray;
begin
  result := TRscJSONArray.Create;
end;

function TRscJSONArray.IndexOf(obj: TRscJSONbase): Integer;
begin
  result := _IndexOf(obj);
end;

class function TRscJSONArray.SelfType: TRscJSONtypes;
begin
  result := jsList;
end;

class function TRscJSONArray.SelfTypeName: string;
begin
  result := 'jsList';
end;

{ TRscJSONobject }

function TRscJSONobject.AddPair(const aName: string; const aValue:
  TRscJSONbase): Integer;
var
  mth: TRscJSONobjectmethod;
begin
  if not assigned(aValue) then
    begin
      result := -1;
      exit;
    end;
  mth := TRscJSONobjectmethod.Create;
  mth.FName := aName;
  mth.FValue := aValue;
  result := self._Add(mth);
end;

procedure TRscJSONobject.RemovePair(Index: Integer);
begin
  _Delete(Index);
end;

procedure TRscJSONobject.RemovePair(Name: string);
var
  Index: integer;
begin
  Index :=  IndexOfName(Name);
  if Index > -1 then
    _Delete(Index);
end;

class function TRscJSONobject.Generate:
  TRscJSONobject;
begin
  result := TRscJSONobject.Create;
end;

function TRscJSONobject.IndexOfName(const aName: string): Integer;
var
  mth: TRscJSONobjectmethod;
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    begin
      mth := TRscJSONobjectmethod(fList.Items[i]);
      if mth.Name = aName then
        begin
          result := i;
          break;
        end;
    end;
end;

function TRscJSONobject.IndexOfObject(aobj: TRscJSONbase): Integer;
var
  mth: TRscJSONobjectmethod;
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    begin
      mth := TRscJSONobjectmethod(fList.Items[i]);
      if mth.FValue = aobj then
        begin
          result := i;
          break;
        end;
    end;
end;

function TRscJSONobject.AddPair(const aName: string; const aValue: double): Integer;
begin
  Result := self.AddPair(aName, TRscJSONnumber.Generate(aValue));
end;

function TRscJSONobject.AddPair(const aName: string; const aValue: Boolean): Integer;
begin
  Result := self.AddPair(aName, TRscJSONboolean.Generate(aValue));
end;

function TRscJSONobject.AddPair(const aName: string; const aValue: string): Integer;
begin
  Result := self.AddPair(aName, TRscJSONstring.Generate(aValue));
end;

function TRscJSONobject.AddPair(const aName: string; const aValue: WideString): Integer;
begin
  Result := self.AddPair(aName, TRscJSONWidestring.Generate(aValue));
end;

function TRscJSONobject.AddPair(const aName: string; const aValue: Integer): Integer;
begin
  Result := self.AddPair(aName, TRscJSONnumber.Generate(aValue));
end;

function TRscJSONobject.AddPair(const aName: string;
  const aValue: Int64): Integer;
begin
  Result := self.AddPair(aName, TRscJSONnumber.Generate(aValue));
end;

class function TRscJSONobject.SelfType: TRscJSONtypes;
begin
  Result := jsObject;
end;

class function TRscJSONobject.SelfTypeName: string;
begin
  Result := 'jsObject';
end;

function TRscJSONobject.GetNameOf(idx: Integer): string;
var
  mth: TRscJSONobjectmethod;
begin
  if (idx < 0) or (idx >= Count) then
    begin
      result := '';
    end
  else
    begin
      mth := Child[idx] as TRscJSONobjectmethod;
      result := mth.Name;
    end;
end;

function TRscJSONobject.ForEachElement(idx: Integer;
  var nm: string): TRscJSONbase;
begin
  nm := GetNameOf(idx);
  result := GetValue(idx);
end;

function TRscJSONobject.GetField(AName: Variant):TRscJSONbase;
begin
  if VarIsStr(AName) then
    result := GetValue(VarToWideStr(AName))
  else
    result := inherited GetField(AName);
end;

constructor TRscJSONobject.Create;
begin
  inherited Create;
end;

destructor TRscJSONobject.Destroy;
begin
  inherited;
end;

function TRscJSONobject.GetValue(Index: integer): TRscJSONbase;
var
  nm: WideString;
begin
  nm := GetNameOf(Index);
  if nm <> '' then
    begin
      result := Field[nm];
    end
  else
    begin
      result := nil;
    end;
end;

function TRscJSONobject.GetValue(Name: string): TRscJSONbase;
var
  mth: TRscJSONobjectmethod;
  i: Integer;
begin
  i := IndexOfName(Name);
  if i = -1 then
    begin
      Result := nil;
    end
  else
    begin
      mth := TRscJSONobjectmethod(fList.Items[i]);
      Result := mth.FValue;
    end;
end;

{ TRscJSON }

class function TRscJSON.LoadFromString(const JsonStr: string): TRscJSONbase;
var
{$IF CompilerVersion <= 15} //Delphi 6 and old
  DecimalSeparator: Char;
  ThousandSeparator: Char;
  DateSeparator: Char;
  TimeSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
{$ELSE}
  fs: TFormatSettings;
{$IFEND}

  function js_base(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean; forward;

  function xe(idx: Integer): Boolean;
  begin
    result := idx <= length(JsonStr);
  end;

  procedure skip_spc(var idx: Integer);
  begin
    while (xe(idx)) and (ord(JsonStr[idx]) < 33) do
      inc(idx);
  end;

  procedure add_child(var o, c: TRscJSONbase);
  begin
    if o = nil then
      begin
        o := c;
      end
    else
      begin
        if o is TRscJSONobjectmethod then
          begin
            TRscJSONobjectmethod(o).FValue := c;
          end
        else if o is TRscJSONArray then
          begin
            TRscJSONArray(o)._Add(c);
          end
        else if o is TRscJSONobject then
          begin
            TRscJSONobject(o)._Add(c);
          end;
      end;
  end;

  function js_boolean(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    js: TRscJSONboolean;
  begin
    skip_spc(idx);
    if copy(JsonStr, idx, 4) = 'true' then
      begin
        result := true;
        ridx := idx + 4;
        js := TRscJSONboolean.Create;
        js.FValue := true;
        add_child(o, TRscJSONbase(js));
      end
    else if copy(JsonStr, idx, 5) = 'false' then
      begin
        result := true;
        ridx := idx + 5;
        js := TRscJSONboolean.Create;
        js.FValue := false;
        add_child(o, TRscJSONbase(js));
      end
    else
      begin
        result := false;
      end;
  end;

  function js_null(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    js: TRscJSONnull;
  begin
    skip_spc(idx);
    if copy(JsonStr, idx, 4) = 'null' then
      begin
        result := true;
        ridx := idx + 4;
        js := TRscJSONnull.Create;
        add_child(o, TRscJSONbase(js));
      end
    else
      begin
        result := false;
      end;
  end;

  function js_integer(idx: Integer; var ridx: Integer): Boolean;
  begin
    result := false;
    while (xe(idx)) and (IsCharInSet(JsonStr[idx], ['0'..'9'])) do
      begin
        result := true;
        inc(idx);
      end;
    if result then ridx := idx;
  end;

  function js_number(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    js: TRscJSONnumber;
    ws: string;
  begin
    skip_spc(idx);
    result := xe(idx);
    if not result then exit;
    if IsCharInSet(JsonStr[idx], ['+','-']) then
      begin
        inc(idx);
        result := xe(idx);
      end;
    if not result then exit;
    result := js_integer(idx, idx);
    if not result then exit;
    if (xe(idx)) and (JsonStr[idx] = '.') then
      begin
        inc(idx);
        result := js_integer(idx, idx);
        if not result then exit;
      end;
    if (xe(idx)) and (IsCharInSet(JsonStr[idx], ['e', 'E'])) then
      begin
        inc(idx);
        if (xe(idx)) and (IsCharInSet(JsonStr[idx], ['+','-'])) then inc(idx);
        result := js_integer(idx, idx);
        if not result then exit;
      end;
    if not result then exit;
    js := TRscJSONnumber.Create;
    ws := copy(JsonStr, ridx, idx - ridx);

    {$IF CompilerVersion >= 16} //Delphi 7 and last
    js.FValue := StrToFloat(ws, fs);
    {$ELSE}
    js.FValue := StrToFloat(ws);
    {$IFEND}

    add_child(o, TRscJSONbase(js));
    ridx := idx;
  end;

  function js_string(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;

    function strSpecialChars(const s: string): string;
    var
      i, j : integer;
    begin
      i := Pos('\', s);
      if (i = 0) then
        Result := s
      else
      begin
        Result := Copy(s, 1, i-1);
        j := i;
        repeat
          if (s[j] = '\') then
          begin
            inc(j);
            case s[j] of
              '\': Result := Result + '\';
              '"': Result := Result + '"';
              '''': Result := Result + '''';
              '/': Result := Result + '/';
              'b': Result := Result + #8;
              'f': Result := Result + #12;
              'n': Result := Result + #10;
              'r': Result := Result + #13;
              't': Result := Result + #9;
              'u':
                begin
                  Result := Result + code2utf(strtoint('$' + copy(s, j + 1, 4)));
                  inc(j, 4);
                end;
            end;
          end
          else
            Result := Result + s[j];
          inc(j);
        until j > length(s);
      end;
    end;

  var
    js: TRscJSONstring;
    fin: Boolean;
    ws: String;
    i,j,widx: Integer;
  begin
    skip_spc(idx);

    result := xe(idx) and (JsonStr[idx] = '"');
    if not result then exit;

    inc(idx);
    widx := idx;

    fin:=false;
    REPEAT
      i := 0;
      j := 0;
      while (widx<=length(JsonStr)) and (j=0) do
        begin
          if (i=0) and (JsonStr[widx]='\') then i:=widx;
          if (j=0) and (JsonStr[widx]='"') then j:=widx;
          inc(widx);
        end;

      if j=0 then
        begin
          result := false;
          exit;
        end;

      if (i=0) or (j<i) then
        begin
          ws := copy(JsonStr,idx,j-idx);
          idx := j;
          fin := true;
        end
      else
        begin
          widx:=i+2;
        end;
    UNTIL fin;

    ws := strSpecialChars(ws);
    inc(idx);

    js := TRscJSONstring.Create;
    {$IF CompilerVersion >= 20.0} // Delphi 2009 and later
    js.FValue := UTF8ToString(UTF8Encode(ws));
    {$ELSE}
    js.FValue := UTF8Decode(ws);
    {$IFEND}
    add_child(o, TRscJSONbase(js));
    ridx := idx;
  end;

  function js_list(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    js: TRscJSONArray;
  begin
    result := false;
    try
      js := TRscJSONArray.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := JsonStr[idx] = '[';
      if not result then exit;
      inc(idx);
      while js_base(idx, idx, TRscJSONbase(js)) do
        begin
          skip_spc(idx);
          if (xe(idx)) and (JsonStr[idx] = ',') then inc(idx);
        end;
      skip_spc(idx);
      result := (xe(idx)) and (JsonStr[idx] = ']');
      if not result then exit;
      inc(idx);
    finally
      if not result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TRscJSONbase(js));
          ridx := idx;
        end;
    end;
  end;

  function js_method(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    mth: TRscJSONobjectmethod;
    ws: TRscJSONstring;
  begin
    result := false;
    try
      ws := nil;
      mth := TRscJSONobjectmethod.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := js_string(idx, idx, TRscJSONbase(ws));
      if not result then exit;
      skip_spc(idx);
      result := xe(idx) and (JsonStr[idx] = ':');
      if not result then exit;
      inc(idx);
      mth.FName := ws.FValue;
      result := js_base(idx, idx, TRscJSONbase(mth));
    finally
      if ws <> nil then ws.Free;
      if result then
        begin
          add_child(o, TRscJSONbase(mth));
          ridx := idx;
        end
      else
        begin
          mth.Free;
        end;
    end;
  end;

  function js_object(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  var
    js: TRscJSONobject;
  begin
    result := false;
    try
      js := TRscJSONobject.Create;
      skip_spc(idx);
      result := xe(idx);
      if not result then exit;
      result := JsonStr[idx] = '{';
      if not result then exit;
      inc(idx);
      while js_method(idx, idx, TRscJSONbase(js)) do
        begin
          skip_spc(idx);
          if (xe(idx)) and (JsonStr[idx] = ',') then inc(idx);
        end;
      skip_spc(idx);  
      result := (xe(idx)) and (JsonStr[idx] = '}');
      if not result then exit;
      inc(idx);
    finally
      if not result then
        begin
          js.Free;
        end
      else
        begin
          add_child(o, TRscJSONbase(js));
          ridx := idx;
        end;
    end;
  end;

  function js_base(idx: Integer; var ridx: Integer; var o:
    TRscJSONbase): Boolean;
  begin
    skip_spc(idx);
    result := js_boolean(idx, idx, o);
    if not result then result := js_null(idx, idx, o);
    if not result then result := js_number(idx, idx, o);
    if not result then result := js_string(idx, idx, o);
    if not result then result := js_list(idx, idx, o);
    if not result then result := js_object(idx, idx, o);
    if result then ridx := idx;
  end;

var
  idx: Integer;
begin
  {$IF CompilerVersion >= 24} // Delphi XE3 and newer
    {$IF Defined(MSWINDOWS)}
      fs := TFormatSettings.Create('pt-BR');
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$ELSE}
      fs := TFormatSettings.Invariant; // Use invariant settings for non-Windows platforms
      fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
    {$IFEND}
  {$ELSEIF CompilerVersion >= 16} // Delphi 6 do not have GetLocaleFormatSettings
    GetLocaleFormatSettings(GetThreadLocale, fs);
    fs.DecimalSeparator := '.';//json sempre será¡ (.) ponto
  {$ELSE}
  DecimalSeparator := SysUtils.DecimalSeparator;
  ThousandSeparator := SysUtils.ThousandSeparator;
  DateSeparator  := SysUtils.DateSeparator;
  TimeSeparator  := SysUtils.TimeSeparator;
  ShortDateFormat  := SysUtils.ShortDateFormat;
  LongDateFormat  := SysUtils.LongDateFormat;
  ShortTimeFormat := SysUtils.ShortDateFormat;
  LongTimeFormat  := SysUtils.LongTimeFormat;
  {$IFEND}
  try
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := '.';
    SysUtils.ThousandSeparator := ',';
    SysUtils.DateSeparator := '/';
    SysUtils.TimeSeparator := ':';
    SysUtils.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.LongDateFormat := 'dddd, dd mmmm yyyy';
    SysUtils.ShortDateFormat := 'hh:nn';
    SysUtils.LongTimeFormat := 'hh:nn:ss';
    {$IFEND}

    result := nil;
    if JsonStr = '' then exit;
    try
      idx := 1;
      if copy(JsonStr,idx,3)=#239#187#191 then
        begin
          inc(idx,3);
          if idx>length(JsonStr) then exit;
        end;
      if not js_base(idx, idx, result) then FreeAndNil(result);
    except
      if assigned(result) then FreeAndNil(result);
    end;
  finally
    {$IF CompilerVersion <= 15} //Delphi 6 and old
    SysUtils.DecimalSeparator := DecimalSeparator;
    SysUtils.ThousandSeparator := ThousandSeparator;
    SysUtils.DateSeparator := DateSeparator;
    SysUtils.TimeSeparator := TimeSeparator;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongDateFormat := LongDateFormat;
    SysUtils.ShortDateFormat := ShortDateFormat;
    SysUtils.LongTimeFormat := LongTimeFormat;
    {$IFEND}
  end;
end;

class function TRscJSON.LoadFromStream(src: TStream): TRscJSONbase;
var
  ws: string;
  len: int64;
begin
  result := nil;
  if not assigned(src) then exit;
  len := src.Size - src.Position;
  SetLength(ws, len);
  src.Read(pchar(ws)^, len);
  result := LoadFromString(ws);
end;

class procedure TRscJSON.SaveToStream(obj: TRscJSONbase; dst: TStream);
var
  ws: string;
begin
  if not assigned(obj) then exit;
  if not assigned(dst) then exit;
  ws := obj.ToJson;
  dst.Write(pchar(ws)^, length(ws));
end;

class function TRscJSON.LoadFromFile(srcname: string): TRscJSONbase;
var
  fs: TFileStream;
begin
  result := nil;
  if not FileExists(srcname) then exit;
  try
    fs := TFileStream.Create(srcname, fmOpenRead);
    result := LoadFromStream(fs);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

class procedure TRscJSON.SaveToFile(obj: TRscJSONbase; dstname: string);
var
  fs: TFileStream;
begin
  if not assigned(obj) then exit;
  try
    fs := TFileStream.Create(dstname, fmCreate);
    SaveToStream(obj, fs);
  finally
    if Assigned(fs) then FreeAndNil(fs);
  end;
end;

{ ERscIntException }

constructor ERscIntException.Create(idx: Integer; msg: string);
begin
  self.idx := idx;
  inherited Create(msg);
end;





initialization

end.

