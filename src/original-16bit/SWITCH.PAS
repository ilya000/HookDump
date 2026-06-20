{
  HookDump  -  single-instance / window-switch helper unit
  Author:   Ilya V. Osipov ("iLya")  -  https://github.com/ilya000
  Written:  1996-1998 (HookDump 2.x; recovered snapshot, Jan 1998), Nizhny Novgorod
  Project:  https://github.com/ilya000/HookDump
  Encoding: re-encoded from the original Windows-1251 (CP1251) to UTF-8.
  Original: byte-exact historical source preserved at src/historical-originals/original-16bit/SWITCH.PAS
}


{*******************************************************}
{                                                       }
{       Delphi Unit SWITCH.PAS                          }
{                                                       }
{       by Alexander Petrushev, 1996                    }
{                                                       }
{       Special thanks to                               }
{       * Philippe Galiatsatos, elgege@micronet.fr      }
{       * Serge Petrov, 2:5030/168.2                    }
{                                                       }
{*******************************************************}
{  USAGE:                                               }
{  ------                                               }
{  Insert SWITCH into USES clause of project source.    }
{                                                       }
{  NOTE:                                                }
{  -----                                                }
{  You must add WS_CAPTION into CreateWindow flags      }
{  (TApplication.Create in FORMS.PAS):                  }
{  ...                                                  }
{  FHandle := CreateWindow(WindowClass.lpszClassName,   }
{  ModuleName, WS_CAPTION + WS_POPUP + WS_VISIBLE +     }
{  ...         ^^^^^^^^^^                               }
{*******************************************************}

unit Switch;

interface

function SwitchToPrevInst(ClassName:PChar): Boolean;

implementation

uses
  WinProcs, WinTypes,
    SysUtils;

function GetWindowOnTop(InstHandle: THandle; ClassName:PChar): HWnd;
var
  Wnd: HWnd;                { Window handle, for iterating through windows}
  sz: array[0..250] of char;
  ApplicationWnd: HWnd;
begin
(*  Wnd := GetTopWindow(0); { Get HWnd for the desktop to start }
  ApplicationWnd := 0;
  { First we must set ApplicationWnd for TApplication Delphi class }
  while (Wnd <> 0) do begin
    { If it is visible and the owner is the desktop... }
    if (IsWindowVisible(Wnd) and (GetWindow(Wnd, GW_OWNER) = 0)) then begin
      { Get the HInstance of the window Wnd }
      { if the new HInstance matches the one passed in, save it }
      if GetWindowWord(Wnd, GWW_HINSTANCE) = InstHandle then begin
        GetClassName(Wnd, sz, 250);
        if 0 = StrComp(sz,ClassName {'TApplication'}) then begin
          ApplicationWnd := Wnd;
          break;
        end;
      end;
    end;
    Wnd := GetWindow(Wnd, GW_HWNDNEXT); { Get the next running window }
  end;
  GetWindowOnTop := Wnd;*)
end;

function SwitchToPrevInst(ClassName:PChar): Boolean;
var
  PrevInstWnd: HWnd;
begin
  if hPrevInst = 0 then begin
    SwitchToPrevInst := False;
  end
  else begin
    PrevInstWnd := GetWindowOnTop(hPrevInst,ClassName);
    if IsIconic(PrevInstWnd) then
      ShowWindow(PrevInstWnd, SW_RESTORE)
    else
      BringWindowToTop(PrevInstWnd);
    SwitchToPrevInst := True;
  end;
end;

{initialization
  if SwitchToPrevInst then halt;}
end.
