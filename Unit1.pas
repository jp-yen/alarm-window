// �A�C�R���͈ȉ����_�E�����[�h
// https://icon-icons.com/ja/%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3/%E6%B0%97%E8%B1%A1%E8%AD%A6%E5%A0%B1-%E4%BF%A1%E5%8F%B7-%E3%83%88-exclamation/124159

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.DateUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, MMSystem, System.SyncObjs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Timer1: TTimer;
    �A���[��: TMemo;
    Label1: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private �錾 }
    procedure LoadMessageFile(const FilePath: string);
  public
    { Public �錾 }
    MessageTitle: string;
    MessageText: string;
    SoundStart_Period: TDateTime;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$WRITEABLECONST ON}    // ���蓖�ĉ\�Ȍ^�t���萔 = True �ɂ���

// =============================================================================
// �t�H�[���������̏���
// =============================================================================
procedure TForm1.Button1Click(Sender: TObject);
begin
  sndPlaySound(nil, 0); // �����~�߂�
  Application.Terminate;
end;

// ���b�Z�[�W�𕜌�����
procedure TForm1.Button2Click(Sender: TObject);
begin
  Label1.Caption := MessageTitle;
  �A���[��.Text := MessageText;
end;

// �E�B���h�E���J���čŏ��Ɏ��s����
procedure TForm1.FormCreate(Sender: TObject);
var
  MessageFile: string;
  LValue: string;
begin
  // �����̏���������
  // �R�}���h���C����������������
  MessageTitle := '�A���[��'; // �z�X�g�����w�肳��Ȃ��ꍇ�� �u�A���[���ƕ\���v
  MessageText := '��Q���������܂���';
  // /host �X�C�b�`�����݂��邩�m�F����
  if FindCmdLineSwitch('host', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageTitle := '�@�� : ' + LValue; // /host �̎��̈������z�X�g��
    end;
  end;
  // /message �X�C�b�`�����݂��邩�m�F����
  if FindCmdLineSwitch('message', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageText := LValue; // /message �̎��̈��������b�Z�[�W
    end;
  end;
  // /fmessage �X�C�b�`�����݂��邩�m�F����
  if FindCmdLineSwitch('fmessage', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageFile := LValue; // /fmessage �̎��̈��������b�Z�[�W�̏�����Ă���t�@�C���ւ̃p�X
      LoadMessageFile(MessageFile);
    end;
  end;

  // �E�B���h�E�̏���
  // Label1.Caption := '�Ώ� : ' + HostName;
  Label1.Caption := MessageTitle;
  �A���[��.Text := MessageText;

  DoubleBuffered := True; // �_�u���o�b�t�@�����O�� ON �ɂ��Ă������}����
  �A���[��.ParentColor := True; // �w�i�F���p������
  �A���[��.BorderStyle := bsNone; // �g������
  // �A���[��.ScrollBars := ssBoth; // ��������ѐ����X�N���[���o�[��L���ɂ���
  Timer1.Interval := 300; // �^�C�}�[�̃C���^�[�o����ݒ�i400�~���b = 0.4�b�j
  Timer1.Enabled := True; // �^�C�}�[��L���ɂ���

  // �őO�ʂɈړ�
  SetWindowPos(Form1.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);
  sndPlaySound('a.wav', SND_ASYNC + SND_LOOP); // ���𖳌����[�v������
  SoundStart_Period := IncMillisecond(Now, 0); // 30�b�オ�����特���~�߂�
end;

procedure TForm1.LoadMessageFile(const FilePath: string);
var
  FileContent: TStringList;
begin
  // �t�@�C���̑��݂��m�F
  if FileExists(FilePath) then
  begin
    FileContent := TStringList.Create;
    try
      // UTF-8 �̃t�@�C����ǂݍ���
      FileContent.LoadFromFile(FilePath, TEncoding.UTF8);
      // �t�@�C���̓��e�𕶎���ϐ��ɑ��
      MessageText := FileContent.Text;
    except
      on E: Exception do
      begin
        MessageText := '�t�@�C����ǂݍ��ލۂɃG���[���������܂���: ' + E.Message;
      end;
    end;
    FileContent.Free;
  end
  else
  begin
    MessageText := '�w�肳�ꂽ���b�Z�[�W�t�@�C��������܂���';
  end;
end;

// �^�C�}�[���荞�ݏ���
procedure TForm1.Timer1Timer(Sender: TObject);
const
  // �ÓI�ϐ���錾
  // ���蓖�ĉ\�Ȍ^�t���萔�𗘗p
  Toggle: Int8 = 0;
begin
  Timer1.Enabled := False;

  if Toggle = 0 then
  begin
    Panel1.Color := clRed;
    // Panel1.Repaint;
  end
  else
  begin
    Panel1.Color := clYellow;
    // Panel1.Repaint;
  end;
  Toggle := 1 - Toggle;

  if not(WithinPastMilliSeconds(Now, SoundStart_Period, 30000)) then
    sndPlaySound(nil, 0);

  Timer1.Enabled := True;
end;

// ��d�N���̌��o
// https://qiita.com/ht_deko/items/83cd0ab35c90a9a6cea1
var
  MutexExists: Boolean;
  oMutex: TMutex;

const
  MUTEX_NAME = '1yen-Popup-Window'; // ��d�N�����ʂ̖��O
begin
  MutexExists := True;
  Application.ShowMainForm := False; // ��d�N���łȂ��ƕ�����܂ŃE�B���h�E��\�����Ȃ�
  try
    oMutex := TMutex.Create(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
  except
    on E: EOSError do
      MutexExists := False;
  end;
  if MutexExists then
    Application.Terminate; // ��d�N���Ȃ�I��

  var
  cMutex := TMutex.Create(nil, False, MUTEX_NAME);
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
    Application.ShowMainForm := True; // ��d�N���łȂ��Ȃ�\��
    Application.Run;
  finally
    cMutex.Free;
  end;

  FreeAndNil(oMutex);

end.end.
