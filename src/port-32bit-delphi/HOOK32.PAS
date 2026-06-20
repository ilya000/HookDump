{
  HookDump  -  32-bit Delphi port — main unit
  Author:   Ilya V. Osipov ("iLya")  -  https://github.com/ilya000
  Written:  late 1990s (32-bit Delphi port), Nizhny Novgorod
  Project:  https://github.com/ilya000/HookDump
  Encoding: re-encoded from the original Windows-1251 (CP1251) to UTF-8.
  Original: byte-exact historical source preserved at src/historical-originals/port-32bit-delphi/HOOK32.PAS
}

unit Hook3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
