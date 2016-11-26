object Form1: TForm1
  Left = 1136
  Top = 340
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bump Generator'
  ClientHeight = 110
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 60
    Height = 13
    Caption = 'Source type:'
  end
  object Button1: TButton
    Left = 168
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Start!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object log: TMemo
    Left = 128
    Top = 0
    Width = 153
    Height = 81
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '0.05'
  end
  object check_backup: TCheckBox
    Left = 8
    Top = 88
    Width = 113
    Height = 17
    Caption = 'Back Up source '
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object radio_bump: TRadioButton
    Left = 8
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Bump'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object radio_nmap: TRadioButton
    Left = 8
    Top = 64
    Width = 113
    Height = 17
    Caption = 'NMap'
    TabOrder = 5
  end
  object od1: TOpenDialog
    DefaultExt = '.dds'
    Filter = 'DirectDraw Surface|*.dds'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Select Uncompressed Stalker Bump Map'
    Left = 256
    Top = 80
  end
end
