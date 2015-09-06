unit main;

interface
{$I 'qdac.inc'}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, YxdStr,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,yxdjson, YxdRtti, qstring, qjson;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    mmResult: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button9: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    mmResult2: TMemo;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoCopyIf(ASender,AItem:TQJson;var Accept:Boolean;ATag:Pointer);
    procedure DoDeleteIf(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer);
    procedure DoFindIf(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer);
    procedure DoCopyIfY(ASender: JSONBase; AItem:PJSONValue;var Accept:Boolean;ATag:Pointer);
    procedure DoDeleteIfY(ASender: JSONBase; AChild:PJSONValue;var Accept:Boolean;ATag:Pointer);
    procedure DoFindIfY(ASender: JSONBase; AChild:PJSONValue;var Accept:Boolean;ATag:Pointer);
  public
    { Public declarations }
    function Add(X,Y:Integer):Integer;
  end;
type
  TRttiTestSubRecord=record
    Int64Val: Int64;
    UInt64Val: UInt64;
    UStr: String;
    AStr:AnsiString;
    SStr:ShortString;
    IntVal: Integer;
    MethodVal: TNotifyEvent;
    SetVal: TBorderIcons;
    WordVal: Word;
    ByteVal: Byte;
    ObjVal: TObject;
    DtValue: TDateTime;
    tmValue: TTime;
    dValue:TDate;
    CardinalVal: Cardinal;
    ShortVal: Smallint;
    CurrVal: Currency;
    EnumVal: TAlign;
    CharVal: Char;
    VarVal:Variant;
    ArrayVal: TBytes;
    {$IFDEF UNICODE}
    IntArray:TArray<Integer>;
    {$ENDIF}
  end;
  TRttiUnionRecord=record
    case Integer of
       0:(iVal:Integer);
//       1:(bVal:Boolean);
    end;

  TRttiTestRecord=record
    Name:QStringW;
    Id:Integer;
    SubRecord:TRttiTestSubRecord;
    UnionRecord:TRttiUnionRecord;
  end;
  //Test for user
  TTitleRecord = packed record
    Title: TFileName;
    Date: TDateTime;
  end;

  TTitleRecords = packed record
    Len: Integer;
    TitleRecord: array[0..100] of TTitleRecord;
  end;
  TFixedRecordArray=array[0..1] of TRttiUnionRecord;
  TRttiObjectRecord=record
    Obj:TStringList;
  end;
  TDeviceType = (dtSM3000,dtSM6000,dtSM6100,dtSM7000,dtSM8000);
  //��λ����������
  TRCU_Cmd = record
    ID:string;   //����ID Ϊ����������豸����+.+INDEX
    DevcType:TDeviceType;//�豸���ͣ����� SM-6000
    Rcu_Kind:Integer;//�������
    Name:string; //�������ƣ�����̵���
    KEY_IDX:Integer;//������������˫����ϼ���ֵ����255
    SHOW_IDX:Integer;//��ʾ˳��
    {$IFDEF UNICODE}
    Cmds:TArray<TArray<Byte>>;// �����ֽ�,�п����Ƕ��ģʽ
    {$ENDIF}
    //����ֵ����
    ResultValue:string;//����ֵ����Ĺ�ʽ��json���ʽ
    RCU_Type_ID:string;// ��������ID
    RCU_Type_Name:string; //�����������ƣ����� �� SM-6000
//    procedure Clear;
  end;
  //������Ϣ����һ����ϵ�����
  TSence = record
    Name:string;//��������
    {$IFDEF UNICODE}
    Cmds:TArray<string>;//TArray<TPlc_Cmd>;
    {$ENDIF}
  end;
  //ÿ���ͷ���Ϣ
  TRoom = record
    Hotel_ID:string; //�Ƶ�ID
    Hotel_Code:string; //�Ƶ����
    Room_ID:string;  //�ͷ�ID
    ROOM_Name:string; //��ʵ�Ŀͷ�����
    //�ͷ���ţ�X��X��X��X�� = X.X.X.X
    Room_Code:string;//�ͷ��� Ϊ�˱��ڿͻ��˵��ã�Room_Code������
    RCU_TYPE_ID:string;//���������豸
    RCU_Type_Name:string;     //RCU����
    RCU_HOST:string;
    RCU_Port:string;
    {$IFDEF UNICODE}
    Cmds:TArray<TRCU_Cmd>;//ԭʼ��������Ϣ
    {$ENDIF}
    //�ͷ�����豸��Ϣ�Լ��豸����
//    Cmd_Name_Ids:TNameValueRow;  // ID�����ƶ�Ӧ ������������ԭ��������
    //�Ƶ�ͷ���ĳ�����Ϣ��һ��������Ӧ��������
    {$IFDEF UNICODE}
    Sences:TArray<TSence>;
    {$ENDIF}
//    procedure Clear;
  end;
var
  Form1: TForm1;

implementation
uses typinfo{$IFDEF UNICODE},rtti{$ENDIF};
{$R *.dfm}

function GetFileSize(AFileName:String):Int64;
var
  sr:TSearchRec;
  AHandle:Integer;
begin
AHandle:=FindFirst(AFileName,faAnyFile,sr);
if AHandle=0 then
  begin
  Result:=sr.Size;
  FindClose(sr);
  end
else
  Result:=0;
end;
function TForm1.Add(X, Y: Integer): Integer;
begin
Result:=X+Y;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  AJson,AItem:TQJson;
  YJson: JSONObject;
  YItem: PJSONValue;
  S:String;
begin
s := '';
AJson:=TQJson.Create;
try
  AJson.Add('Item1',0);
  AJson.Add('Item2',true);
  AJson.Add('Item3',1.23);
  for AItem in AJson do
    begin
    S:=S+AItem.Name+' => '+AItem.AsString+#13#10;
    end;
  mmResult.Lines.Add(S);
finally
  AJson.Free;
end;
s := '';
YJson:=JSONObject.Create;
try
  YJson.put('Item1',0);
  YJson.put('Item2',true);
  YJson.put('Item3',1.23);
  for YItem in YJson do
    begin
    S:=S+YItem.FName+' => '+YItem.AsString+#13#10;
    end;
  mmResult2.Lines.Add(S);
finally
  YJson.Free;
end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
begin
YJson:=JSONObject.Create;
try
  //ǿ��·�����ʣ����·�������ڣ���ᴴ��·����·���ָ���������./\֮һ
  YJson.ForcePath('demo1.item[0].name').AsString:='102';
  YJson.ForcePath('demo1.item[0].name').AsString:='103';
  YJson.ForcePath('demo1.item[1].name').AsString:='100';
  try
    ShowMessage('YxdJSON �����������׳�һ���쳣');
    YJson.ForcePath('demo1[0].item[1]').AsString:='200';
  except
    //���Ӧ���׳��쳣��demo1�Ƕ��������飬�����Ǵ��
  end;
  //���ʵ�6��Ԫ�أ�ǰ5��Ԫ�ػ��Զ�����Ϊnull
  YJson.ForcePath('demo2[5]').AsInteger:=103;
  //ǿ�ƴ���һ�����������Ȼ�����Add��������ӳ�Ա
  YJson.ForcePath('demo3[]').AsJsonArray.add(1.23);
  //����Ĵ��뽫����"demo4":[{"Name":"demo4"}]�Ľ��
  YJson.ForcePath('demo4[].Name').AsString:='demo4';
  //ֱ��ǿ��·������
  YJson.ForcePath('demo5[0]').AsString:='demo5';
  mmResult2.Text:=YJson.ToString(4);
  mmResult2.Lines.add(YJson.ForcePath('demo1.item[1]').GetPath());
finally
  YJson.Free;
end;
AJson:=TQJson.Create;
try
  //ǿ��·�����ʣ����·�������ڣ���ᴴ��·����·���ָ���������./\֮һ
  AJson.ForcePath('demo1.item[0].name').AsString:='1';
  AJson.ForcePath('demo1.item[1].name').AsString:='100';
  try
    ShowMessage('QJson �����������׳�һ���쳣');
    AJson.ForcePath('demo1[0].item[1]').AsString:='200';
  except
    //���Ӧ���׳��쳣��demo1�Ƕ��������飬�����Ǵ��
  end;
  //���ʵ�6��Ԫ�أ�ǰ5��Ԫ�ػ��Զ�����Ϊnull
  AJson.ForcePath('demo2[5]').AsInteger:=103;
  //ǿ�ƴ���һ�����������Ȼ�����Add��������ӳ�Ա
  AJson.ForcePath('demo3[]').Add('Value',1.23);
  //����Ĵ��뽫����"demo4":[{"Name":"demo4"}]�Ľ��
  AJson.ForcePath('demo4[].Name').AsString:='demo4';
  //ֱ��ǿ��·������
  AJson.ForcePath('demo5[0]').AsString:='demo5';
  mmResult.Text:=AJson.AsJson;
finally
  AJson.Free;
end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
  AList:TQJsonItemList;
  YList:JSONList;
begin
AJson:=TQJson.Create;
try
  AJson.Parse(
    '{'+
    '"object":{'+
    ' "name":"object_1",'+
    ' "subobj":{'+
    '   "name":"subobj_1"'+
    '   },'+
    ' "subarray":[1,3,4]'+
    ' },'+
    '"array":[100,200,300,{"name":"object"}]'+
    '}');
  AList:=TQJsonItemList.Create;
  AJson.ItemByRegex('sub.+',AList,true);
  mmResult.Lines.Add('ItemByRegex�ҵ�'+IntToStr(AList.Count)+'�����');
  AList.Free;
  mmResult.Lines.Add('ItemByPath(''object\subobj\name'')='+AJson.ItemByPath('object\subobj\name').AsString);
  mmResult.Lines.Add('ItemByPath(''object\subarray[1]'')='+AJson.ItemByPath('object\subarray[1]').AsString);
  mmResult.Lines.Add('ItemByPath(''array[1]'')='+AJson.ItemByPath('array[1]').AsString);
  mmResult.Lines.Add('ItemByPath(''array[3].name'')='+AJson.ItemByPath('array[3].name').AsString);
finally
  AJson.Free;
end;
yJson:=JSONObject.Create;
try
  yJson.Parse(
    '{'+
    '"object":{'+
    ' "name":"object_1",'+
    ' "subobj":{'+
    '   "name":"subobj_1"'+
    '   },'+
    ' "subarray":[1,3,4]'+
    ' },'+
    '"array":[100,200,300,{"name":"object"}]'+
    '}');
  YList := JSONList.Create;
  yJson.ItemByRegex('sub.+',YList,true);
  mmResult2.Lines.Add('ItemByRegex�ҵ�'+IntToStr(YList.Count)+'�����');
  YList.Free;
  mmResult2.Lines.Add('ItemByPath(''object\subobj\name'')='+yJson.ItemByPath('object\subobj\name', '\').AsString);
  mmResult2.Lines.Add('ItemByPath(''object\subarray[1]'')='+yJson.ItemByPath('object\subarray[1]', '\').AsString);
  mmResult2.Lines.Add('ItemByPath(''array[1]'')='+yJson.ItemByPath('array[1]').AsString);
  mmResult2.Lines.Add('ItemByPath(''array[3].name'')='+yJson.ItemByPath('array[3].name').AsString);
finally
  yJson.Free;
end;
end;

procedure TForm1.Button13Click(Sender: TObject);
{$IFNDEF UNICODE}
begin
  ShowMessage('��֧�ֵĹ���');
{$ELSE}
var
  AJson:TQJson;
  AValue:TValue;
  YJSON: JSONObject;
begin
AJson:=TQJson.Create;
try
  with AJson.Add('Add') do
    begin
    Add('X').AsInteger:=100;
    Add('Y').AsInteger:=200;
    end;
  AValue:=AJson.ItemByName('Add').Invoke(Self);
  mmResult.Lines.Add(AJson.AsJson);
  mmResult.Lines.Add('.Invoke='+IntToStr(AValue.AsInteger));
finally
  AJson.Free;
end;
YJSON:=JSONObject.Create;
try
  with YJSON.AddChildObject('Add') do
    begin
    Add('X').AsInteger:=100;
    Add('Y').AsInteger:=200;
    end;
  AValue:=YJSON.getItem('Add').AsJsonObject.Invoke(Self);
  mmResult2.Lines.Add(YJSON.ToString(4));
  mmResult2.Lines.Add('.Invoke='+IntToStr(AValue.AsInteger));
finally
  YJSON.Free;
end;
{$ENDIF}
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  yjson: JSONObject;
begin
  yjson := JSONObject.Create;
  try
    yjson.PutObject('test', Self);
    yjson.GetJsonObject('test').GetItem('Caption').AsString := 'YxdJson RTTI Test';
    yjson.GetJsonObject('test').ToObject(Self);
    mmResult2.Text := yjson.ToString(4);
  finally
    yjson.Free;
  end;
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
  S:String;
begin
AJson:=TQJson.Create;
try
  AJson.Add('Text').AsString:='Hello,�й�';
  ShowMessage(AJson.Encode(True,True));
  AJson.Parse(AJson.Encode(True,True));
  ShowMessage(AJson.AsJson);
finally
  AJson.Free;
end;
YJson:=JSONObject.Create;
try
  YJson.put('Text', 'Hello,�й�');
  ShowMessage(YJson.tostring(4, True));
  YJson.Parse(YJson.tostring(4, True));
  ShowMessage(YJson.ToString(4));
finally
  YJson.Free;
end;
end;

procedure TForm1.Button16Click(Sender: TObject);
var
  AJson:TQJson;
  Yjson: JSONObject;
  procedure DoTry(S:QStringW);
  begin
  if AJson.TryParse(S) then
    ShowMessage(AJson.AsString)
  else
    ShowMessage('QJson ����ʧ��'#13#10+S);
  end;
  procedure DoTry2(S:JSONString);
  begin
  if Yjson.TryParse(S) then
    ShowMessage(Yjson.ToString)
  else
    ShowMessage('YJson ����ʧ��'#13#10+S);
  end;
begin
AJson:=TQJson.Create;
try
  DoTry('{aaa}');
  DoTry('{"aaa":100}');
finally
  AJson.Free;
end;
Yjson:=JSONObject.Create;
try
  DoTry2('{aaa}');
  DoTry2('{"aaa":100}');
finally
  Yjson.Free;
end;
end;

procedure TForm1.Button17Click(Sender: TObject);
var
  YJson:JSONObject;
begin
YJson:=JSONObject.Create;
try
  //ǿ��·�����ʣ����·�������ڣ���ᴴ��·����·���ָ���������./\֮һ
  YJson.ForcePath('demo1.item[0].name').AsString:='1';
  YJson.ForcePath('demo1.item[0].name').AsString:='122';
  YJson.ForcePath('demo1.item[1].name').AsString:='100';
  //����Ĵ��뽫����"demo4":[{"Name":"demo4"}]�Ľ��
  YJson.ForcePath('demo4[].Name').AsString:='demo4';
  mmResult2.Text:=YJson.ToString(4);
finally
  YJson.Free;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
  I:Integer;
  T:Cardinal;
begin
AJson:=TQJson.Create;
try
  T:=GetTickCount;
  for I := 0 to 1000000 do
    AJson.Add('_'+IntToStr(I),Now);
  T:=GetTickCount-T;
  mmResult.Clear;
  mmResult.Lines.Add('qjson ���1000,000�������ʱ:'+IntToStr(T)+'ms');
finally
  AJson.Free;
end;
yJson:=JSONObject.Create;
try
  T:=GetTickCount;
  for I := 0 to 1000000 do
    yJson.put('_'+IntToStr(I),Now);
  T:=GetTickCount-T;
  mmResult2.Clear;
  mmResult2.Lines.Add('yjson ���1000,000�������ʱ:'+IntToStr(T)+'ms');
finally
  yJson.Free;
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AJson:TQJson;
  YJSON:JSONObject;
  TestRecord:TRttiTestRecord;
begin
AJson:=TQJson.Create;
YJson:=JSONObject.Create;
try
  TestRecord.Id:=10001;
  TestRecord.Name:='Complex Record';
  TestRecord.UnionRecord.iVal:=100;
  TestRecord.SubRecord.Int64Val:=1;
  TestRecord.SubRecord.UInt64Val:=2;
  TestRecord.SubRecord.UStr:='Test String';
  TestRecord.SubRecord.IntVal:=3;
  TestRecord.SubRecord.MethodVal:=Button2Click;
  TestRecord.SubRecord.SetVal:=[{$IFDEF UNICODE}TBorderIcon.{$ENDIF}biSystemMenu];
  TestRecord.SubRecord.WordVal:=4;
  TestRecord.SubRecord.ByteVal:=5;
  TestRecord.SubRecord.ObjVal:=Button2;
  TestRecord.SubRecord.DtValue:=Now;
  TestRecord.SubRecord.tmValue:=Time;
  TestRecord.SubRecord.dValue:=Now;
  TestRecord.SubRecord.CardinalVal:=6;
  TestRecord.SubRecord.ShortVal:=7;
  TestRecord.SubRecord.CurrVal:=8.9;
  TestRecord.SubRecord.EnumVal:={$IFDEF UNICODE}TAlign.{$ENDIF}alTop;
  TestRecord.SubRecord.CharVal:='A';
  TestRecord.SubRecord.VarVal:=VarArrayOf(['VariantArray',1,2.5,true,false]);
  SetLength(TestRecord.SubRecord.ArrayVal,3);
  TestRecord.SubRecord.ArrayVal[0]:=100;
  TestRecord.SubRecord.ArrayVal[1]:=101;
  TestRecord.SubRecord.ArrayVal[2]:=102;
  AJson.Add('IP','192.168.1.1');
  with AJson.Add('FixedTypes') do
    begin
    AddDateTime('DateTime',Now);
    Add('Integer',1000);
    Add('Boolean',True);
    Add('Float',1.23);
    Add('Array',[1,'goods',true,3.4]);
    {$IFDEF UNICODE}
    Add('RTTIObject').FromRtti(Button2);
    Add('RTTIRecord').FromRecord(TestRecord);
    {$ENDIF}
    end;
  with AJson.Add('AutoTypes') do
    begin
    Add('Integer','-100');
    Add('Float','-12.3');
    Add('Array','[2,''goods'',true,4.5]');
    Add('Object','{"Name":"Object_Name","Value":"Object_Value"}');
    Add('ForceArrayAsString','[2,''goods'',true,4.5]',jdtString);
    Add('ForceObjectAsString','{"Name":"Object_Name","Value":"Object_Value"}',jdtString);
    end;
  with AJson.Add('AsTypes') do
    begin
    Add('Integer').AsInteger:=123;
    Add('Float').AsFloat:=5.6;
    Add('Boolean').AsBoolean:=False;
    Add('VarArray').AsVariant:=VarArrayOf([9,10,11,2]);
    Add('Array').AsArray:='[10,3,22,99]';
    Add('Object').AsObject:='{"Name":"Object_2","Value":"Value_2"}';
    end;
  mmResult.Clear;
  mmResult.Lines.Add('QJSON ��Ӳ��Խ��:');
  mmResult.Lines.Add(AJson.Encode(True));
  YJson.put('IP','192.168.1.1');
  with YJson.addChildObject('FixedTypes') do
    begin
    putDateTime('DateTime',Now);
    put('Integer',1000);
    put('Boolean',True);
    put('Float',1.23);
    addChildArray('Array',[1,'goods',true,3.4]);
    {$IFDEF UNICODE}
    putObject('RTTIObject', Button2);
    putRecord('RTTIRecord', TestRecord);
    {$ENDIF}
    end;
  with YJson.addChildObject('AutoTypes') do
    begin
    put('Integer','-100');
    putJSON('Float','-12.3');
    putJSON('Array','[2,''goods'',true,4.5]');
    putJSON('Object','{"Name":"Object_Name","Value":"Object_Value"}');
    put('ForceArrayAsString','[2,''goods'',true,4.5]');
    put('ForceObjectAsString','{"Name":"Object_Name","Value":"Object_Value"}');
    end;
  with YJson.addChildObject('AsTypes') do
    begin
    put('Integer', 123);
    put('Float', 5.6);
    put('Boolean', False);
    put('VarArray', VarArrayOf([9,10,11,2]));
    putJSON('Array', '[10,3,22,99]');
    putJSON('Object', '{"Name":"Object_2","Value":"Value_2"}');
    end;
  mmResult2.Clear;
  mmResult2.Lines.Add('YxdJSON ��Ӳ��Խ��:');
  mmResult2.Lines.Add(YJson.ToString(4));
finally
  AJson.Free;
  YJson.Free;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
  T:Cardinal;
  i: Integer;
  Speed:Cardinal;
  procedure PreCache;
  var
    AStream:TMemoryStream;
  begin
  AStream:=TMemoryStream.Create;
  try
    AStream.LoadFromFile(OpenDialog1.FileName);
  finally
    AStream.Free;
  end;
  end;
begin
if OpenDialog1.Execute then
  begin
//  uJsonTest;
  try
  YJson:=JSONObject.Create;
  try
    T:=GetTickCount;
    for i := 0 to 2 do
      YJson.LoadFromFile(OpenDialog1.FileName);
    T:=GetTickCount-T;
    if T>0 then
      Speed:=(GetFileSize(OpenDialog1.FileName)*1000 div T)
    else
      Speed:=0;
    mmResult2.Clear;
    mmResult2.Lines.Add('���ص�JSON�ļ����ݣ�');
    mmResult2.Lines.Add(YJson.ToString(4));
    mmResult2.Lines.Add('YxdJson������ʱ:'+IntToStr(T)+'ms���ٶ�:'+RollupSize(Speed));
    //mmResult2.Lines.Add(YJson.ToString(4));
  finally
    YJson.Free;
  end;
  except end;
  end;

  try
  AJson:=TQJson.Create;
  try
    T:=GetTickCount;
    for i := 0 to 2 do
    AJson.LoadFromFile(OpenDialog1.FileName);
    T:=GetTickCount-T;
    if T>0 then
      Speed:=(GetFileSize(OpenDialog1.FileName)*1000 div T)
    else
      Speed:=0;
    mmResult.Clear;
    mmResult.Lines.Add('���ص�JSON�ļ����ݣ�');
    mmResult.Lines.Add(AJson.Encode(True));
    mmResult.Lines.Add('QJson������ʱ:'+IntToStr(T)+'ms���ٶ�:'+RollupSize(Speed));
  finally
    AJson.Free;
  end;
  except end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  AJson:TQJson;
  YJson:JSONObject;
  II:Integer;
  T1,T2:Cardinal;
  Speed:Cardinal;
begin
if SaveDialog1.Execute then
  begin
  AJson:=TQJson.Create;
  try
    mmResult.Clear;
    T1:=GetTickCount;
    with AJson.Add('Integers',jdtObject) do
      begin
      for II := 0 to 2000000 do
        Add('Node'+IntToStr(II)).AsInteger :=II;
      end;
    T1:=GetTickCount-T1;
    T2:=GetTickCount;
    AJson.SaveToFile(SaveDialog1.FileName,teAnsi,false);
    T2:=GetTickCount-T2;
    if T2>0 then
      Speed:=(GetFileSize(SaveDialog1.FileName)*1000 div T2)
    else
      Speed:=0;
    mmResult.Lines.Add('QJSON ����200������ʱ'+IntToStr(T1)+'ms,������ʱ:'+IntToStr(T2)+'ms���ٶȣ�'+RollupSize(Speed));
  finally
    AJson.Free;
  end;
  YJson:=JSONObject.Create;
  try
    mmResult2.Clear;
    T1:=GetTickCount;
    with YJson.AddChildObject('Integers') do
      begin
      for II := 0 to 2000000 do
        add('Node'+IntToStr(II)).AsInteger := II;
      end;
    T1:=GetTickCount-T1;
    T2:=GetTickCount;
    YJson.SaveToFile(SaveDialog1.FileName, 4, YxdStr{$IFDEF UNICODE}.TTextEncoding{$ENDIF}.teAnsi,false);
    T2:=GetTickCount-T2;
    if T2>0 then
      Speed:=(GetFileSize(SaveDialog1.FileName)*1000 div T2)
    else
      Speed:=0;
    mmResult2.Lines.Add('YxdJSON ����200������ʱ'+IntToStr(T1)+'ms,������ʱ:'+IntToStr(T2)+'ms���ٶȣ�'+RollupSize(Speed));
  finally
    YJson.Free;
  end;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  AJson:TQJson;
  yjson: JSONObject;
begin
AJson:=TQJson.Create;
try
  AJson.Parse('{"results":[],"status":102,"msg":"IP\/SN\/SCODE\/REFERER Illegal:"}');
  mmResult.Text := (AJson.Encode(True));
finally
  AJson.Free;
end;
yjson:=JSONObject.Create;
try
  yjson.Parse('{"results":[],"status":102,"msg":"IP\/SN\/SCODE\/REFERER Illegal:"}');
  mmResult2.Text := (yjson.ToString(4));
finally
  yjson.Free;
end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  ARec, BRec: TRttiTestSubRecord;
  AJson,ACopy:TQJson;
  YJson,YCopy:JSONObject;
  t: Cardinal;
  I: Integer;
begin
{$IFNDEF UNICODE}
  ShowMessage('�������ڵ�ǰIDE�в���֧��.');
{$ELSE}
  ARec.Int64Val:=1;
  ARec.UInt64Val:=2;
  ARec.UStr:='Test String';
  ARec.AStr:='AnsiString';
  ARec.SStr:='ShortString';
  ARec.IntVal:=3;
  ARec.MethodVal:=Button2Click;
  ARec.SetVal:=[{$IFDEF UNICODE}TBorderIcon.{$ENDIF}biSystemMenu];
  ARec.WordVal:=4;
  ARec.ByteVal:=5;
  ARec.ObjVal:=Button2;
  ARec.DtValue:=Now;
  ARec.tmValue:=Time;
  ARec.dValue:=Now;
  ARec.CardinalVal:=6;
  ARec.ShortVal:=7;
  ARec.CurrVal:=8.9;
  ARec.EnumVal:={$IFDEF UNICODE}TAlign.{$ENDIF}alTop;
  ARec.CharVal:='A';
  ARec.VarVal:=VarArrayOf(['VariantArray',1,2.5,true,false]);
  SetLength(ARec.ArrayVal,3);
  ARec.ArrayVal[0]:=100;
  ARec.ArrayVal[1]:=101;
  ARec.ArrayVal[2]:=102;
  SetLength(ARec.IntArray,2);
  ARec.IntArray[0]:=300;
  ARec.IntArray[1]:=200;
  BRec := ARec;
  t := GetTickCount;
  for i := 0 to 1000 do begin
  AJson:=TQJson.Create;
  try
    {$IFDEF UNICODE}
    AJson.Add('Record').FromRecord(ARec);
    ACopy:=AJson.ItemByName('Record').Copy;
    ACopy.ItemByName('Int64Val').AsInt64:=100;
    ACopy.ItemByPath('UStr').AsString:='UnicodeString-ByJson';
    ACopy.ItemByPath('AStr').AsString:='AnsiString-ByJson';
    ACopy.ItemByPath('SStr').AsString:='ShortString-ByJson';
    ACopy.ItemByPath('EnumVal').AsString:='alBottom';
    ACopy.ItemByPath('SetVal').AsString:='[biHelp]';
    ACopy.ItemByPath('ArrayVal').AsJson:='[10,30,15]';
    ACopy.ItemByPath('VarVal').AsVariant:=VarArrayOf(['By Json',3,4,false,true]);
    ACopy.ToRecord<TRttiTestSubRecord>(ARec);
    ACopy.Free;
    AJson.Add('NewRecord').FromRecord(ARec);
    {$ENDIF}

    mmResult.text := (AJson.AsJson);
  finally
    AJson.Free;
  end;
  end;
  t := GetTickCount - t;
  mmResult.Lines.add(Format('QJson %dms.', [t]));
  ARec := BRec;
  t := GetTickCount;
  for i := 0 to 1000 do begin
  YJson:=JSONObject.Create;
  try
    {$IFDEF UNICODE}
    YJson.PutRecord('Record', ARec);
    YCopy:=YJson.getItem('Record').AsJsonObject.Clone;
    YCopy.getItem('Int64Val').AsInt64:=100;
    YCopy.ItemByPath('UStr').AsString:='UnicodeString-ByJson';
    YCopy.ItemByPath('AStr').AsString:='AnsiString-ByJson';
    YCopy.ItemByPath('SStr').AsString:='ShortString-ByJson';
    YCopy.ItemByPath('EnumVal').AsString:='alBottom';
    YCopy.ItemByPath('SetVal').AsString:='[biHelp]';
    YCopy.ItemByPath('ArrayVal').AsJsonArray.Parse('[10,30,15]');
    YCopy.ItemByPath('VarVal').AsVariant:=VarArrayOf(['By Json',3,4,false,true]);
    YCopy.ToRecord<TRttiTestSubRecord>(ARec);
    YCopy.Free;
    YJson.PutRecord('NewRecord', ARec);
    {$ENDIF}

    mmResult2.text := (YJson.ToString(4));
  finally
    YJson.Free;
  end;
  end;
  t := GetTickCount - t;
  mmResult2.Lines.add(Format('YxdJson %dms.', [t]));
  {$ENDIF}
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  AStream:TMemoryStream;
  AJson:TQJson;
  S:QStringW;
  AEncode:TTextEncoding;
begin
AStream:=TMemoryStream.Create;
AJson:=TQJson.Create;
try
  AJson.DataType:=jdtObject;
  S:='{"record1":{"id":100,"name":"name1"}}'#13#10+
    '{"record2":{"id":200,"name":"name2"}}'#13#10+
    '{"record3":{"id":300,"name":"name3"}}'#13#10;
  //UCS2
  mmResult.Lines.Add('Unicode 16 LE����:');
  AEncode:=teUnicode16LE;
  AStream.Size:=0;
  SaveTextW(AStream,S,False);
  AStream.Position:=0;
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add('��һ�ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�����ν������:');
  mmResult.Lines.Add(AJson.AsJson);
  //UTF-8
  mmResult.Lines.Add('UTF8����:');
  AEncode:=teUtf8;
  AStream.Size:=0;
  SaveTextU(AStream,qstring.Utf8Encode(S),False);
  AStream.Position:=0;
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'��һ�ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�����ν������:');
  mmResult.Lines.Add(AJson.AsJson);
  //ANSI
  mmResult.Lines.Add(#13#10'ANSI����:');
  AEncode:=teAnsi;
  AStream.Size:=0;
  SaveTextA(AStream,qstring.AnsiEncode(S));
  AStream.Position:=0;
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add('��һ�ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�����ν������:');
  mmResult.Lines.Add(AJson.AsJson);
  //UCS2BE
  mmResult.Lines.Add(#13#10'Unicode16BE����:');
  AEncode:=teUnicode16BE;
  AStream.Size:=0;
  SaveTextWBE(AStream,S,False);
  AStream.Position:=0;
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add('��һ�ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
  mmResult.Lines.Add(AJson.AsJson);
  AJson.Clear;
  AJson.ParseBlock(AStream,AEncode);
  mmResult.Lines.Add(#13#10'�����ν������:');
  mmResult.Lines.Add(AJson.AsJson);
finally
  AStream.Free;
  AJson.Free;
end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  AJson,AItem:TQJson;
  YJson, A, B: JSONObject;
  YItem: JSONArray;
  YItemValue: PJSONValue;
  II:Integer;
  DynArray:array of Integer;
  RecordArray:array of TRttiUnionRecord;
begin
AJson:=TQJson.Create;
try
  //�������Ԫ�ص�N�ַ�ʽ��ʾ
  // 1. ֱ�ӵ���Add����Ԫ���ı��ķ�ʽ
  AJson.Add('AddArrayText','["Item1",100,null,true,false,123.4]',jdtArray);//jdtArray���ʡ�Ի��Զ����ԣ������ȷ֪�����Ͳ�Ҫ�����ж����ӿ���
  // 2. ֱ���������
  AJson.Add('AddArray',['Item1',100,Null,True,False,123.4]);
  // 3. ֱ����VarArrayOf��ֵ
  AJson.Add('AsVariant').AsVariant:=VarArrayOf(['Item1',100,Null,True,False,123.4]);
  //���ڶ�̬���飬����
  SetLength(DynArray,5);
  DynArray[0]:=100;
  DynArray[1]:=200;
  DynArray[2]:=300;
  DynArray[3]:=400;
  DynArray[4]:=500;
  AJson.Add('DynArray').AsVariant:=DynArray;
  {$IFDEF UNICODE}
  SetLength(RecordArray,2);
  RecordArray[0].iVal:=1;
  RecordArray[1].iVal:=2;
  with AJson.Add('RecordArray',jdtArray) do
    begin
    for II := 0 to High(RecordArray) do
      Add.FromRecord(RecordArray[II]);
    end;
  {$ENDIF}
//  AJson.Add('RecordArray').AsVariant:=RecordArray;
// 4. ֱ����AsArray�����������ļ�
  AJson.Add('AsArray').AsArray:='["Item1",100,null,true,false,123.4]';
  // 5. �ֶ�������Ԫ��
  with AJson.Add('Manul') do
    begin
    DataType:=jdtArray;
    Add.AsString:='Item1';
    Add.AsInteger:=100;
    Add;
    Add.AsBoolean:=True;
    Add.AsBoolean:=False;
    Add.AsFloat:=123.4;
    end;
  // ��Ӷ���������������ͣ�ֻ���ӽ�㻻���Ƕ���Ϳ�����
  AJson.Add('Object',[TQJson.Create.Add('Item1',100).Parent,TQJson.Create.Add('Item2',true).Parent]);
  mmResult.Lines.Add(AJson.AsJson);
  //���������е�Ԫ��
  mmResult.Lines.Add('ʹ��for inö������Manul��Ԫ��ֵ');
  II:=0;
  for AItem in AJson.ItemByName('Manul') do
     begin
     mmResult.Lines.Add('Manul['+IntToStr(II)+']='+AItem.AsString);
     Inc(II);
     end;
  mmResult.Lines.Add('ʹ����ͨforѭ��ö������Manul��Ԫ��ֵ');
  AItem:=AJson.ItemByName('Manul');
  for II := 0 to AItem.Count-1 do
     mmResult.Lines.Add('Manul['+IntToStr(II)+']='+AItem[II].AsString);
finally
  FreeObject(AJson);
end;
YJson:=JSONObject.Create;
try
  //�������Ԫ�ص�N�ַ�ʽ��ʾ
  // 1. ֱ�ӵ���Add����Ԫ���ı��ķ�ʽ
  YJson.putJSON('AddArrayText','["Item1",100,null,true,false,123.4]');//jdtArray���ʡ�Ի��Զ����ԣ������ȷ֪�����Ͳ�Ҫ�����ж����ӿ���
  // 2. ֱ���������
  YJson.put('AddArray',['Item1',100,Null,True,False,123.4]);
  // 3. ֱ����VarArrayOf��ֵ
  YJson.put('AsVariant', VarArrayOf(['Item1',100,Null,True,False,123.4]));
  //���ڶ�̬���飬����
  SetLength(DynArray,5);
  DynArray[0]:=100;
  DynArray[1]:=200;
  DynArray[2]:=300;
  DynArray[3]:=400;
  DynArray[4]:=500;
  YJson.put('DynArray', DynArray);
  {$IFDEF UNICODE}
  SetLength(RecordArray,2);
  RecordArray[0].iVal:=1;
  RecordArray[1].iVal:=2;
  with YJson.AddChildArray('RecordArray') do
    begin
    for II := 0 to High(RecordArray) do
      putRecord(RecordArray[II]);
    end;
  {$ENDIF}
//  AJson.Add('RecordArray').AsVariant:=RecordArray;
// 4. ֱ����AsArray�����������ļ�
  YJson.putJSON('AsArray', '["Item1",100,null,true,false,123.4]');
  // 5. �ֶ�������Ԫ��
  with YJson.AddChildArray('Manul') do
    begin
    Add('Item1');
    Add(100);
    Add(NULL);
    Add(True);
    Add(False);
    Add(123.4);
    end;
  // ��Ӷ���������������ͣ�ֻ���ӽ�㻻���Ƕ���Ϳ�����
  a := JSONObject.Create;
  a.Put('Item1', 100);
  b := JSONObject.Create;
  b.Put('Item2', True);
  YJson.AddChildArray('Object',[a, b]);
  mmResult2.Lines.Add(YJson.ToString(4));
  //���������е�Ԫ��
  mmResult2.Lines.Add('ʹ��for inö������Manul��Ԫ��ֵ');
  II:=0;
  for YItemValue in YJson.GetJsonArray('Manul') do
     begin
     mmResult2.Lines.Add('Manul['+IntToStr(II)+']='+YItemValue.AsString);
     Inc(II);
     end;
  mmResult2.Lines.Add('ʹ����ͨforѭ��ö������Manul��Ԫ��ֵ');
  YItem:=YJson.GetJsonArray('Manul');
  for II := 0 to YItem.Count-1 do
     mmResult2.Lines.Add('Manul['+IntToStr(II)+']='+YItem[II].AsString);
finally
  FreeObject(YJson);
end;
end;

procedure TForm1.Button9Click(Sender: TObject);
const
  TMPSTR = '{'+
    '"object":{'+
    ' "name":"object_1",'+
    ' "subobj":{'+
    '   "name":"subobj_1"'+
    '   },'+
    ' "subarray":[1,3,4]'+
    ' },'+
    '"array":[100,200,300,{"name":"object"}]'+
    '}';
var
  AJson,AItem:TQJson;
  YJSON:JSONObject;
  YItem:JSONObject;
begin
AJson:=TQJson.Create;
try
  AJson.Parse(TMPSTR);
  {$IFDEF UNICODE}
  AItem:=AJson.CopyIf(nil,procedure(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=(AChild.DataType<>jdtArray);
    end);
  {$ELSE}
  AItem:=AJson.CopyIf(nil,DoCopyIf);
  {$ENDIF}
  mmResult.Lines.Add('CopyIf�����Ƴ�����������������н��');
  mmResult.Lines.Add(AItem.AsJson);
  mmResult.Lines.Add('FindIf������ָ���Ľ��');
  {$IFDEF UNICODE}
  mmResult.Lines.Add(AItem.FindIf(nil,true,procedure(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=(AChild.Name='subobj');
    end).AsJson);
  {$ELSE}
  mmResult.Lines.Add(AItem.FindIf(nil,true,DoFindIf).AsJson);
  {$ENDIF}
  mmResult.Lines.Add('ɾ���������е�subobj���');
  {$IFDEF UNICODE}
  AItem.DeleteIf(nil,true,procedure(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=(AChild.Name='subobj');
    end);
  {$ELSE}
  AItem.DeleteIf(nil,true,DoDeleteIf);
  {$ENDIF}
  mmResult.Lines.Add(AItem.AsJson);
finally
  FreeObject(AItem);
  FreeObject(AJson);
end;

YJson:=JSONObject.Create;
try
  YJson.Parse(TMPSTR);
  {$IFDEF UNICODE}
  YItem:=YJson.CopyIf(nil,procedure(ASender: JSONBase; AChild: PJSONValue;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=not Assigned(AChild.AsJsonArray);
    end) as JSONObject;
  {$ELSE}
  YItem:=YJson.CopyIf(nil,DoCopyIfY) as JSONObject;
  {$ENDIF}
  mmResult2.Lines.Add('CopyIf�����Ƴ�����������������н��');
  mmResult2.Lines.Add(YItem.ToString(4));
  mmResult2.Lines.Add('FindIf������ָ���Ľ��');
  {$IFDEF UNICODE}
  mmResult2.Lines.Add(YItem.FindIf(nil,true,procedure(ASender: JSONBase; AChild: PJSONValue;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=(AChild.FName='subobj');
    end).ToString(4));
  {$ELSE}
  mmResult2.Lines.Add(YItem.FindIf(nil,true,DoFindIfY).ToString(4));
  {$ENDIF}
  mmResult2.Lines.Add('ɾ���������е�subobj���');
  {$IFDEF UNICODE}
  YItem.DeleteIf(nil,true,procedure(ASender: JSONBase; AChild: PJSONValue;var Accept:Boolean;ATag:Pointer)
    begin
    Accept:=(AChild.FName='subobj');
    end);
  {$ELSE}
  YItem.DeleteIf(nil,true,DoDeleteIfY);
  {$ENDIF}
  mmResult2.Lines.Add(YItem.ToString(4));
finally
  FreeObject(YItem);
  FreeObject(YJson);
end;

end;

procedure TForm1.DoCopyIf(ASender, AItem: TQJson; var Accept: Boolean;
  ATag: Pointer);
begin
Accept:=(AItem.DataType<>jdtArray);
end;
procedure TForm1.DoCopyIfY(ASender: JSONBase; AItem: PJSONValue;
  var Accept: Boolean; ATag: Pointer);
begin
Accept:=not Assigned(AItem.AsJsonArray);
end;

procedure TForm1.DoDeleteIf(ASender,AChild:TQJson;var Accept:Boolean;ATag:Pointer);
begin
Accept:=(AChild.Name='subobj');
end;

procedure TForm1.DoDeleteIfY(ASender: JSONBase; AChild: PJSONValue;
  var Accept: Boolean; ATag: Pointer);
begin
Accept:=(AChild.FName='subobj');
end;

procedure TForm1.DoFindIf(ASender, AChild: TQJson; var Accept: Boolean;
  ATag: Pointer);
begin
Accept:=(AChild.Name='subobj');
end;

procedure TForm1.DoFindIfY(ASender: JSONBase; AChild: PJSONValue;
  var Accept: Boolean; ATag: Pointer);
begin
Accept:=(AChild.FName='subobj');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
ReportMemoryLeaksOnShutdown:=True;
OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
end;

procedure TForm1.Panel1Click(Sender: TObject);
var
  S:QStringA;
begin
S:='Hello,world';
ShowMessage(S);
end;

end.
