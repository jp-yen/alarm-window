object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #12450#12521#12540#12512#12364#30330#29983#12375#12414#12375#12383
  ClientHeight = 400
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    640
    400)
  TextHeight = 15
  object Button1: TButton
    Left = 240
    Top = 335
    Width = 185
    Height = 57
    Anchors = [akBottom]
    Caption = 'Close'
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = #28216#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 24
    Top = 8
    Width = 585
    Height = 321
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clMenuText
    Font.Height = -16
    Font.Name = #28216#12468#12471#12483#12463
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      585
      321)
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 95
      Height = 31
      Caption = #12450#12521#12540#12512
      Font.Charset = ANSI_CHARSET
      Font.Color = clMenuText
      Font.Height = -24
      Font.Name = #28216#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
    end
    object アラーム: TMemo
      Left = 8
      Top = 32
      Width = 569
      Height = 280
      Anchors = [akLeft, akTop, akRight, akBottom]
      EditMargins.Auto = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clMenuText
      Font.Height = -48
      Font.Name = #28216#12468#12471#12483#12463
      Font.Style = [fsBold]
      Lines.Strings = (
        #12450#12521#12540#12512)
      ParentFont = False
      TabOrder = 0
    end
  end
  object Button2: TButton
    Left = 24
    Top = 363
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'restore'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 700
    OnTimer = Timer1Timer
    Left = 65528
    Top = 384
  end
end
