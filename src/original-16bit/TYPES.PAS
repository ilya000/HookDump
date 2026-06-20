{
  HookDump  -  shared options/types record (included via {$I types})
  Author:   Ilya V. Osipov ("iLya")  -  https://github.com/ilya000
  Written:  1996-1998 (HookDump 2.x; recovered snapshot, Jan 1998), Nizhny Novgorod
  Project:  https://github.com/ilya000/HookDump
  Encoding: re-encoded from the original Windows-1251 (CP1251) to UTF-8.
  Original: byte-exact historical source preserved at src/historical-originals/original-16bit/TYPES.PAS
}

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
