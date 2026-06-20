Library HookDLL;

Uses
  Windows, Messages, SysUtils;

Const
  GlobMapID = 'Global Keyboard Hook Demo {917C91AA-88D5-4134-BB91-15161728594D}';

Type
  PShareInf = ^TShareInf;
  TShareInf = Record
                AppWndHandle: HWND;
                OldHookHandle: HHOOK;
                hm:THandle;
              End;

Var
  MapHandle: THandle = 0;
  ShareInf: PShareInf = nil;
  ptr:PByteArray;

Procedure DLLEntryPoint(dwReason: DWORD); stdcall;
Begin
  Case dwReason Of
    DLL_PROCESS_ATTACH:
      Begin
        MapHandle:=CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(TShareInf), GlobMapID);
        ShareInf:=MapViewOfFile(MapHandle, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TShareInf));
      End;
    DLL_PROCESS_DETACH:
      Begin
        UnMapViewOfFile(ShareInf);
        CloseHandle(MapHandle);
      End
  End;
End;

Function KeyboardHook(Code: Integer; ParamW: WPARAM; ParamL: LPARAM): LRESULT;stdcall;
Begin
  If Code IN [HC_ACTION, HC_NOREMOVE] Then
    Begin
      SendMessage(ShareInf^.AppWndHandle, WM_USER, ParamW, Code);
    End;
  Result := CallNextHookEx(ShareInf^.OldHookHandle, Code, ParamW, ParamL)
End;

Function SetKeyboardHook(Wnd: HWND): BOOL; stdcall;
Begin
  If ShareInf<>Nil Then
    Begin
      ShareInf^.AppWndHandle:=Wnd;
      ShareInf^.OldHookHandle:=SetWindowsHookEx(WH_KEYBOARD, @KeyboardHook, HInstance, 0);
      Result:=ShareInf^.OldHookHandle<>0;
    End
  Else Result:=False
End;

Function RemoveKeyboardHook: BOOL; stdcall;
Begin
  Result := UnhookWindowsHookEx(ShareInf^.OldHookHandle);
  CloseHandle(ShareInf^.hm);
End;

Exports
  SetKeyboardHook, RemoveKeyboardHook;

BEGIN
  If DLLProc = Nil Then DLLProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
END.

