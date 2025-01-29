// アイコンは以下よりダウンロード
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
    アラーム: TMemo;
    Label1: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private 宣言 }
    procedure LoadMessageFile(const FilePath: string);
  public
    { Public 宣言 }
    MessageTitle: string;
    MessageText: string;
    SoundStart_Period: TDateTime;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$WRITEABLECONST ON}    // 割り当て可能な型付き定数 = True にする

// =============================================================================
// フォーム生成時の処理
// =============================================================================
procedure TForm1.Button1Click(Sender: TObject);
begin
  sndPlaySound(nil, 0); // 音を止める
  Application.Terminate;
end;

// メッセージを復元する
procedure TForm1.Button2Click(Sender: TObject);
begin
  Label1.Caption := MessageTitle;
  アラーム.Text := MessageText;
end;

// ウィンドウが開いて最初に実行する
procedure TForm1.FormCreate(Sender: TObject);
var
  MessageFile: string;
  LValue: string;
begin
  // 引数の処理をする
  // コマンドライン引数を処理する
  MessageTitle := 'アラーム'; // ホスト名が指定されない場合は 「アラームと表示」
  MessageText := '障害が発生しました';
  // /host スイッチが存在するか確認する
  if FindCmdLineSwitch('host', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageTitle := '機器 : ' + LValue; // /host の次の引数がホスト名
    end;
  end;
  // /message スイッチが存在するか確認する
  if FindCmdLineSwitch('message', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageText := LValue; // /message の次の引数がメッセージ
    end;
  end;
  // /fmessage スイッチが存在するか確認する
  if FindCmdLineSwitch('fmessage', LValue) then
  begin
    if LValue <> '' then
    begin
      MessageFile := LValue; // /fmessage の次の引数がメッセージの書かれているファイルへのパス
      LoadMessageFile(MessageFile);
    end;
  end;

  // ウィンドウの処理
  // Label1.Caption := '対象 : ' + HostName;
  Label1.Caption := MessageTitle;
  アラーム.Text := MessageText;

  DoubleBuffered := True; // ダブルバッファリングを ON にしてちらつきを抑える
  アラーム.ParentColor := True; // 背景色を継承する
  アラーム.BorderStyle := bsNone; // 枠を消す
  // アラーム.ScrollBars := ssBoth; // 水平および垂直スクロールバーを有効にする
  Timer1.Interval := 300; // タイマーのインターバルを設定（400ミリ秒 = 0.4秒）
  Timer1.Enabled := True; // タイマーを有効にする

  // 最前面に移動
  SetWindowPos(Form1.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);
  sndPlaySound('a.wav', SND_ASYNC + SND_LOOP); // 音を無限ループさせる
  SoundStart_Period := IncMillisecond(Now, 0); // 30秒後が来たら音を止める
end;

procedure TForm1.LoadMessageFile(const FilePath: string);
var
  FileContent: TStringList;
begin
  // ファイルの存在を確認
  if FileExists(FilePath) then
  begin
    FileContent := TStringList.Create;
    try
      // UTF-8 のファイルを読み込む
      FileContent.LoadFromFile(FilePath, TEncoding.UTF8);
      // ファイルの内容を文字列変数に代入
      MessageText := FileContent.Text;
    except
      on E: Exception do
      begin
        MessageText := 'ファイルを読み込む際にエラーが発生しました: ' + E.Message;
      end;
    end;
    FileContent.Free;
  end
  else
  begin
    MessageText := '指定されたメッセージファイルがありません';
  end;
end;

// タイマー割り込み処理
procedure TForm1.Timer1Timer(Sender: TObject);
const
  // 静的変数を宣言
  // 割り当て可能な型付き定数を利用
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

// 二重起動の検出
// https://qiita.com/ht_deko/items/83cd0ab35c90a9a6cea1
var
  MutexExists: Boolean;
  oMutex: TMutex;

const
  MUTEX_NAME = '1yen-Popup-Window'; // 二重起動判別の名前
begin
  MutexExists := True;
  Application.ShowMainForm := False; // 二重起動でないと分かるまでウィンドウを表示しない
  try
    oMutex := TMutex.Create(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
  except
    on E: EOSError do
      MutexExists := False;
  end;
  if MutexExists then
    Application.Terminate; // 二重起動なら終了

  var
  cMutex := TMutex.Create(nil, False, MUTEX_NAME);
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
    Application.ShowMainForm := True; // 二重起動でないなら表示
    Application.Run;
  finally
    cMutex.Free;
  end;

  FreeAndNil(oMutex);

end.end.
