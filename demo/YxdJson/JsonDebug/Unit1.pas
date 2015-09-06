unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure ToRecordClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses yxdjson, YxdRtti; //, YxdPersistent;

{$R *.dfm}
type
  // ������Ϣ
  // 0:��; 1:�ǼǷ���,2:ע���Ǽǣ�3:��¼��4:�ǳ�;5:��ʱ;6:�����7:���񴥷�
  TSend_Type = (stNone, stRegister, stUnRegister, stLogin, stLogout, stTimer,
    stInterval, stService);
  // ��Ϣ����
  TMsg_Type = (mtInnerSys, mtInnerUser, mtSvcSys, mtSvcUser);
TAppMsg = record
    Sess_Id: string; // ��¼sessID������Ҫʱ��Ÿ�ֵ
    Sess_Ids:string;// ���sessionID������Ͷ���̣߳�����ѭ��������߳�
    ID: string; // ��ϢΨһID
    Sender_ID: string; // ������ID
    Sender_Name: string; // ����������
    Groups: string; // ��Ϣ��������
    Title: string; // ��Ϣ����
    Msg_Info: string; // ��Ϣ��Ϣ
    Msg_Type: TMsg_Type; // ��Ϣ����
    Send_Type: TSend_Type; // ��������
    SEND_START_TIME: TTime; // ������ʼ�ͽ�ֹʱ��
    SEND_End_TIME: TTime; // ������ʼ�ͽ�ֹʱ��
    Weeks: Integer; // ��1����2����������7��ȫѡ Ϊ 127����ѡ��Ϊ0
    Timers: string; // JSON�ַ���
    Timers_Delay: Integer; // ��ʱ�ӳ�
    Create_Time: TDateTime;
    Start_Time: TDateTime; // ��Ч��ʼʱ��
    End_Time: TDateTime; // ��Ч��ֹʱ��
    Using: Boolean; // ʹ��
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  Msg: TAppMsg;
  Json: JSONObject;
begin
  FillChar(Msg, SizeOf(Msg), 0);
  Msg.Msg_Info := '��Ϣ��Ϣ';
  Msg.ID := '0001';
  Msg.Sender_Name := 'RecordToJson Test';
  Json := JSONObject.Create;
  try
    Json.PutRecord<TAppMsg>('Msg', Msg);
    ShowMessage(Json.ToString);
  finally
    Json.Free;
  end;
end;

procedure TForm1.ToRecordClick(Sender: TObject);
var
  json:JSONObject;
  AppMsg:TAppMsg;
  t: Cardinal;
  i: Integer;
begin
  json:=JSONObject.Create;
  json.Parse(mmo1.Text);
  //json.ToRecord<TAppMsg>(AppMsg);
  t := GetTickCount;
  for I := 0 to 100000 do
    json.ToRecord<TAppMsg>(AppMsg);
  t := GetTickCount - t;
  ShowMessage(AppMsg.Msg_Info);
  ShowMessage(Format('%d ��, ��ʱ %dms', [i, t]));
  json.Free;
end;

end.
