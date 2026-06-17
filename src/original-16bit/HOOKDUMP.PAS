
program HookDump;

{$R HookDump}

uses WinTypes, WinProcs, SysUtils, ioGDI {,ToolHelp}
     ,Messages, Switch,ioString,tlhelp32;



const
  AppName = 'iLya_Prog_HookDump';
  DllName = 'HookDmp';
  IniName : string = 'HookDump.ini'#0;
 { TxtName : string = 'HookDmp.txt'#0;}
  TxtName : string = 'HookDump.hlp'#0;

{$I types}

const
  idm_About = 100;
  stWriteBasic = 'WriteBasicKey';
  stWritePush = 'WritePushKey';
  stWritePop = 'WritePopKey';
  stUseMouse = 'RegardMouse';
  stExeName = 'WriteExeName';
  stWndName = 'WriteWindowName';
  stAnsiToOem = 'AnsiToOem';
  stUseBuffer = 'UseBuffer';
  stXorOutput = 'XorOutput';
  stXorBase = 'XorBase';
  stBufSize = 'BufSize';
  stWndExeTime = 'WriteWndExeTime';

var
  StartDir:String;
  dir,fileN:String;
  dY,dM,dD,dDW,dH,dMM,dS,dS100:Word;

Var hHookDLL:THandle;
  Menu:hMenu;
  Show:Integer;
  UrlFile: Text;

Procedure SETlpfnNextHook(P:TFarProc);
  Far; external DllName index 2;
{Function OpenDump(F,Z:String):Boolean;
  Far; external DllName index 3;}
{Function CloseDump(Z:String):Boolean;
  Far; external DllName index 4;}
{Procedure RegisterRusInd(Wnd:HWnd);
  Far; external DllName index 5;}
Procedure InitWindow(Wnd:HWnd; var _FileN:String; var First:boolean);
Far; external DllName index 7;
Procedure DoneWindow(Wnd:HWnd);
Far; external DllName index 8;
Procedure SetStatus(S:TSt);
Far; external DllName index 9;

function About(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;
begin
  About := True;
  case Message of
    wm_InitDialog:
      Exit;
    wm_Command:
      if (WParam = id_Ok) or (WParam = id_Cancel) then
      begin
        EndDialog(Dialog, 1);
        Exit;
      end;
  end;
  About := False;
end;




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
     SetBkMode(PaintDC,TRANSPARENT);
     St:='"Keyboard Hook Dumper" Ver '+int2str(Hi(Version))+'.'+int2str(Lo(Version))+' beta  1996-97';
     TextOut(PaintDC,10,5,@st,Length(st));
     St:='(C) iLya Osipov E-Mail:ilya000@usa.net N-Novgorod';
     TextOut(PaintDC,10,25,@st[1],Length(st));
     St:='Now using dir\file: "'+FileN+'"';
     TextOut(PaintDC,10,50,@st[1],Length(st));
     St:='';
     TextOut(PaintDC,10,65,@st[1],Length(st));
  End;

Procedure UnloadLibrary;
(*var Q:TModuleEntry;
    H:THandle;
    I:word;
    Dll:Array [0..8] of char;*)
begin
(*  FreeLibrary(hHookDLL);
  Dll:='HOOKDMP'#0#0;
  Q.dwSize := SizeOf(TModuleEntry);
  H:=ModuleFindName(@Q,Dll);
  {if Q.hModule<>hHookDLL Then MessageBox(GetFocus,Q.szExePath,'Error',mb_Ok);}
  if H=0 Then MessageBox(GetFocus,'0','Error',mb_Ok)
  else for i:=1 to Q.wUsageFlags-1 do
   FreeLibrary(H);*)
end;

{****************************************************************}
var Second:Boolean;
Procedure Init(Window: HWnd);
var S:String;
begin

  InitWindow(Window,fileN,Second);
  {  if Second Then "v2.5"}
  if Second and ((ParamStr(1)='/V')or(Show=1)) Then {"v2.6"}
  MessageBox(GetFocus,'The HookDump is running in hiden mode.'#13'Now starting in visible mode',
    'Second Start',MB_ICONINFORMATION or MB_OK);
end;

Procedure Done(Window: HWnd; AndDLL:Boolean);
begin
  if AndDLL Then begin
    case MessageBox(GetFocus,'Close the Dump ?'#13#13+
                    'Yes - Exit and close hook; '+
                    'No - Hide','Exit',
                    MB_ICONQUESTION or MB_YESNOCANCEL) of
     IDCANCEL:;
     IDNO:
      begin
        DoneWindow(Window);
        DestroyWindow(Window);
      end;
     IDYES:
      begin
        DoneWindow(Window);
        UnloadLibrary;
        DestroyWindow(Window);
      end;
    end;
  end
  else begin
    DoneWindow(Window);
    DestroyWindow(Window);
  end;
end;


Procedure GetOption(S:String; var B:boolean; MI:word);
var W:word;
begin
  S:=S+#0;
  W:=GetPrivateProfileInt('Options',@S[1],byte(B),@IniName[1]);
  B:= W<>0;
  if W=0
    Then CheckMenuItem(Menu,MI,mf_UnChecked)
    Else CheckMenuItem(Menu,MI,mf_Checked);
  SetStatus(St);
end;
Procedure InvertOption(S:String; var B:boolean; MI:word);
var ss:string;
begin
  S:=S+#0;
  b:= not B;
  ss:=inttostr(byte(B))+#00;
  WritePrivateProfileString('Options',@S[1],@SS[1],@IniName[1]);
  if not B
    Then CheckMenuItem(Menu,MI,mf_UnChecked)
    Else CheckMenuItem(Menu,MI,mf_Checked);
  SetStatus(St);
end;

Function isInstall:boolean;
var S:string;
begin
(*  S:=#0;
  byte(S[0]):=GetProfileString('Windows','Load','',@S[1],255);
  isInstall:=pos(ParamStr(0),S)<>0;*)
  result:=true;
end;

Procedure Install;
var S:string;
begin
(*  S:=#0;
  byte(S[0]):=GetProfileString('Windows','Load','',@S[1],255);
  if S='' Then S:=ParamStr(0)+#0
  else S:=S+' '+ParamStr(0)+#0;
    WriteProfileString('Windows','Load',@S[1]); *)
end;

Procedure UnInstall;
var S:string; i,j:Byte;
begin
(*  S:=#0;
  byte(S[0]):=GetProfileString('Windows','Load','',@S[1],255);
  i:=pos('HOOKDUMP',S);
  if I<>0 Then Begin
    While not((I=1) or (S[I] in [' ',';',',',#13,#0,#10])) do I:=I-1;
    J:=I+1;
    While not((S[J] in [' ',';',',',#13,#0,#10])) do J:=J+1;
    Delete(S,I,J-I+1);
    S:=S+#0;
    WriteProfileString('Windows','Load',@S[1]);
  end;  *)
end;


Var
  PaintDC: HDC;
  WinDC: HDC;
  PaintInfo: TPaintStruct;
  {First:Boolean;}
  AboutProc: TFarProc;



function WindowProc(Window: HWnd; Message, WParam: Word;
  LParam: Longint): Longint; export;
var
  xPos,yPos:Word;
  S:String;
begin
  WindowProc := 0;
  case Message of
    wm_Destroy:
      begin
        DoneWindow(Window);
        PostQuitMessage(0);
        Exit;
      end;
    wm_Close:
      begin
        Done(Window,True);
        {DestroyWindow;}
      end;
    wm_Paint:
      begin
        PaintDC:=BeginPaint(Window,PaintInfo);
        {if isIconic(Window)
          then DrawIconic(PaintDC,PaintInfo)
          else} Draw(PaintDC,PaintInfo);
        EndPaint(Window,PaintInfo);
        Exit;
      end;
    wm_NCPaint:
      begin
        WindowProc := DefWindowProc(Window, Message, WParam, LParam);
        WinDC:=GetWindowDC(Window);
        {if isIconic(Window)
          then DrawIconic(WinDC,PaintInfo)
          else} DrawWinDC(WinDC,PaintInfo);
        ReleaseDC(Window,WinDC);
        Exit;
      end;
    wm_Create:
      Begin
        SysMenuEdit(Window);
      end;
    wm_Command:
      Begin
        Case wParam of
          201:Done(Window,True);
          202:Done(Window,False);
          300:{WinExec(passtr('notepad '+TxtName),SW_SHOW);}
              WinHelp(Window,passtr(TxtName),HELP_INDEX,0);
          301,302: begin
                Assign(UrlFile,'HOOKD.URL');
                ReWrite(UrlFile);
                WriteLn(UrlFile,'[InternetShortcut]');
                if wParam=301 Then
                  WriteLn(UrlFile,'URL=http://www.halyava.ru/ilya/hookde.htm')
                else
                  WriteLn(UrlFile,'URL=http://www.halyava.ru/ilya/hookd.htm');
                Close(UrlFile);
                WinExec('start HOOKD.URL',SW_SHOW);
              end;
          500: begin
               AboutProc := MakeProcInstance(@About, HInstance);
               DialogBox(HInstance, 'AboutBox', Window, AboutProc);
               FreeProcInstance(AboutProc);
               Exit;
             end;
          101:begin
              if Show=0 Then Show:=1 else Show:=0;
              if Show=0
              Then CheckMenuItem(Menu,101,mf_Checked)
              Else CheckMenuItem(Menu,101,mf_UnChecked);
              S:=IntToStr(show)+#0;
              WritePrivateProfileString('StartUp','Show',@s[1],@IniName[1]);
            end;
          102:begin
                if not isInstall
                 Then Install
                 Else UnInstall;
                if isInstall
                 Then CheckMenuItem(Menu,102,mf_Checked)
                 Else CheckMenuItem(Menu,102,mf_UnChecked);
             end;
          451:InvertOption(stWriteBasic,st.WriteBasic,451);
          452:InvertOption(stWritePush,st.WritePush,452);
          453:InvertOption(stWritePop,st.WritePop,453);
          454:InvertOption(stUseMouse,st.UseMouse,454);
          401:InvertOption(stExeName,st.ExeName,401);
          403:InvertOption(stWndName,st.WndName,403);
          404:InvertOption(stWndExeTime,st.WndExeTime,404);
          410:InvertOption(stAnsiToOem,st.AnsiToOem,410);
          411:InvertOption(stXorOutput,st.XorOutput,411);
          444:InvertOption(stUseBuffer,st.UseBuffer,444);
        end;
      end;
    else WindowProc := DefWindowProc(Window, Message, WParam, LParam);
  end;
  {WindowProc := DefWindowProc(Window, Message, WParam, LParam);}
end;

type TVerProc = Function:Word;


procedure WinMain;
var
  Window:  HWnd;
  Message: TMsg;
  Result:  Integer;
  Hook:    Pointer;
  Ver:     Pointer;
  V:       Word;
  S:       String;
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
    lpszMenuName: 'MENU';
    lpszClassName: AppName);
{it's a test itadrt}
begin
  {S:=ParamStr(0)+#0;
  FileSplit(@S[1],@StartDir[1],@S[1],@S[1]);
  StartDir:=strpas(@StartDir[1]);
  if StartDir[length(StartDir)]<>'\' then StartDir:=StartDir+'\';}

  StartDir:=GetDirName(ParamStr(0));
  IniName:=StartDir+IniName;
  TxtName:=StartDir+TxtName;


  Menu:=LoadMenu(hInstance,'MENU');
  Show:=GetPrivateProfileInt('StartUp','Show',1,@IniName[1]);
  if Show=0
  Then CheckMenuItem(Menu,101,mf_Checked)
  Else CheckMenuItem(Menu,101,mf_UnChecked);
  if isInstall
  Then CheckMenuItem(Menu,102,mf_Checked)
  Else CheckMenuItem(Menu,102,mf_UnChecked);

  GetOption(stWriteBasic,st.WriteBasic,451);
  GetOption(stWritePush,st.WritePush,452);
  GetOption(stWritePop,st.WritePop,453);
  GetOption(stUseMouse,st.UseMouse,454);
  GetOption(stExeName,st.ExeName,401);
  GetOption(stWndName,st.WndName,403);
  GetOption(stWndExeTime,st.WndExeTime,404);
  GetOption(stAnsiToOem,st.AnsiToOem,410);
  GetOption(stXorOutput,st.XorOutput,411);
  GetOption(stUseBuffer,st.UseBuffer,444);


  dir:=ParamStr(1);
  dir:=dir+#0;
  GetPrivateProfileString('StartUp','Dir',@dir[1],@dir[1],sizeof(dir),@IniName[1]);
  dir:=strpas(@dir[1]);
  if Dir='' Then begin
    (*dir:=strpas(GetEnvVar('TEMP'));*)
    Dir:='c:\';
  end;
  if dir[length(dir)]<>'\' then dir:=dir+'\';

  DecodeDate(NOW,dY,dM,dD);
  DecodeTime(NOW,dH,dMM,dS,dS100);
  FileN:=inttostr(dM)+inttostr(dD)+inttostr(dH)+inttostr(dMM)+'.hk';
  GetPrivateProfileString('StartUp','File',@fileN[1],@fileN[1],sizeof(fileN),@IniName[1]);
  FileN:=strpas(@FileN[1]);
  if pos('.',FileN)=0 Then FileN:=FileN+'.hk';
  FileN:=Dir+FileN;

  st.XorBase:=GetPrivateProfileInt('StartUp',stXorBase,st.XorBase,@IniName[1]);
  st.BufSize:=GetPrivateProfileInt('StartUp',stBufSize,st.BufSize,@IniName[1]);
  SetStatus(St);

  if HPrevInst = 0 then
  begin
    WindowClass.hInstance := HInstance;
    WindowClass.hIcon := LoadIcon(HInstance,'ICON_1');
    WindowClass.hCursor := LoadCursor(0, idc_Arrow);
    WindowClass.hbrBackground := HBrush(COLOR_BTNFACE{COLOR_WINDOW}+1);
    {GetStockObject(white_Brush);}
    RegisterClass(WindowClass);
  end
  else begin
    if SwitchToPrevInst(AppName) then halt;
  end;
  Window := CreateWindow(
    AppName,
    'Hook Dump',
    {ws_PopUp}
    ws_OverlappedWindow and not ( WS_THICKFRAME or WS_MAXIMIZEBOX),
    cw_UseDefault,
    cw_UseDefault,
    {cw_UseDefault}{350}256+170,
    {cw_UseDefault}{350}128,
    0,
    Menu,
    HInstance,
    nil);

  Init(Window);

  if (Show=0) and (ParamStr(1)<>'/V') {and (not Second)"v2.5"} Then
  begin
    ShowWindow(Window,SW_Hide);
    DestroyWindow(Window);
  end
  else
  begin
    ShowWindow(Window,SW_SHOW{SW_Hide});
  end;

  UpdateWindow(Window);

  {Init Hook -----}
  hHookDLL:=LoadLibrary(DllName+'.dll');
  if hHookDLL<32 Then MessageBox(GetFocus,'HookDMP.dll not found',' Lib-Error ',mb_Ok);
  Hook:=GetProcAddress(hHookDLL,'MsgHookProc');
  if Hook=nil Then MessageBox(GetFocus,'Function MsgHookProc not found in HookDMP.dll','Error!',mb_Ok);
  (*SETlpfnNextHook(SetWindowsHook(WH_GETMESSAGE,Hook););*)

  Ver:=GetProcAddress(hHookDLL,'VerProc');
  if Ver=nil Then MessageBox(GetFocus,'Function VerProc not found in HookDMP.dll','Error',mb_Ok)
  else begin
    V:=TVerProc(Ver);
    if V<>Version Then Begin
      S:='Version HookDump.EXE '+inttostr(Hi(Version))+'.'+inttostr(Lo(Version))+
      ' <> HookDMP.DLL '+inttostr(Hi(V))+'.'+inttostr(Lo(V))+#00;
      MessageBox(GetFocus,@S[1],'Error',mb_Ok)
     end;
  end;

  while GetMessage(Message, 0, 0, 0) do
  begin
    TranslateMessage(Message);
    DispatchMessage(Message);
  end;


  {DONE Hook}
  {UnhookWindowsHook(WH_GETMESSAGE,Hook);    ?????}
  {FreeLibrary(hHookDLL);
  FreeLibrary(hHookDLL);
  FreeLibrary(hHookDLL);}




  Halt(Message.wParam);
end;



begin
  WinMain;
end.;
