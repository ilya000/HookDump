
program HideProg;

{$D (C),96 iLya Osipov -=Hide Prog=- ilya@kis.ru}


uses WinTypes, WinProcs, Strings, ioGDI, WinCrt, WinDos,ToolHelp,Switch,ioString;



procedure WinMain;
var s:String;
begin
  S:=ParamStr(1)+#0;
  WinExec(@S[1],SW_Hide);
  Halt(0);
end;


begin
  WinMain;
end.;
