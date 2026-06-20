{
  HookDump  -  controlling application project (Delphi demo)
  Author:   Ilya V. Osipov ("iLya")  -  https://github.com/ilya000
  Written:  late 1990s - early 2000s (Delphi hook demo), Nizhny Novgorod
  Project:  https://github.com/ilya000/HookDump
  Encoding: re-encoded from the original Windows-1251 (CP1251) to UTF-8.
  Original: byte-exact historical source preserved at src/historical-originals/successor-hookproj/HOOKPROJ.DPR
}

program HookProj;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
