Unit Main;

INTERFACE

Uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, Buttons;

Type
  TMainForm = Class(TForm)
    ClearButton: TButton;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Procedure ClearButtonClick(Sender: TObject);
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    Private
    Procedure WMUser(Var Message: TMessage); Message WM_USER;
    Protected
  End;

Var
 MainForm: TMainForm;

IMPLEMENTATION
Uses SysUtils;
{$R *.DFM}

Function SetKeyboardHook(Wnd: HWND): BOOL; stdcall; external 'HookDLL.dll' name 'SetKeyboardHook';
Function RemoveKeyboardHook: BOOL; stdcall; external 'HookDLL.dll' name 'RemoveKeyboardHook';

Procedure TMainForm.WMUser(var Message: TMessage);
Begin
  Memo1.Lines.Add('Code: '+IntToStr(Message.WParam)+';  Char: '+Chr(Message.wParam));
End;

Procedure TMainForm.ClearButtonClick(Sender: TObject);
Begin
  Memo1.Lines.Clear;
End;

Procedure TMainForm.BitBtn1Click(Sender: TObject);
Begin
  If NOT SetKeyboardHook(Handle) Then
    MessageBox(Handle, 'Unable to set hook', PChar(Application.Title), MB_OK OR MB_ICONHAND);
End;

Procedure TMainForm.BitBtn2Click(Sender: TObject);
Begin
  If NOT RemoveKeyboardHook Then
    MessageBox(Handle, 'Unable to remove hook', PChar(Application.Title), MB_OK OR MB_ICONHAND);
End;

End.
