program hook32;

uses
  Forms,windows,
  Hookmain in 'Hookmain.pas' {FrmMain},
  global in 'global.pas',
  Option in 'Option.pas' {FrmOpti},
  about in 'about.pas' {FrmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Hook32 (C),iLya';

  Application.CreateForm(TFrmMain, FrmMain);

// ShowWindow(FrmMain.Handle, SW_HIDE);
  Application.CreateForm(TFrmOpti, FrmOpti);
  Application.CreateForm(TFrmAbout, FrmAbout);
  Application.Run;
end.
