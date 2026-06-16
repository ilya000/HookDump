object MainForm: TMainForm
  Left = 312
  Top = 175
  Width = 454
  Height = 333
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ClearButton: TButton
    Left = 12
    Top = 262
    Width = 75
    Height = 25
    Caption = 'ClearButton'
    TabOrder = 0
    OnClick = ClearButtonClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 4
    Width = 321
    Height = 243
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 358
    Top = 18
    Width = 75
    Height = 25
    Caption = 'SetHook'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 356
    Top = 54
    Width = 75
    Height = 25
    Caption = 'RemoveHook'
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
