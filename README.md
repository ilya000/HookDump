# HookDump

A keyboard / mouse logging program for 16- and 32-bit Windows (Windows 3.x, 95/98),
written in Object Pascal by **iLya — Ilya V. Osipov** in **Nizhny Novgorod, 1996–1997**.

In its day HookDump was **one of the best-known Russian "spy programs" (keyloggers)**:
freely distributed, repeatedly named **best in its class** by the computer press, and
cited in security and anti-virus literature. It has its own articles in the
[Russian](https://ru.wikipedia.org/wiki/HookDump) and
[Ukrainian](https://uk.wikipedia.org/wiki/HookDump) Wikipedias.

This repository preserves the original program as a **historical software artifact**.
The author releases the sources under the **MIT License** so that anyone may study them.

**The program does not run on modern systems.** It was built for 16-/32-bit Windows
(3.x / 95 / 98); its binaries and hooking technique do not work on current 64-bit
Windows. It is preserved here for historical and educational study only.

![HookDump 2.8 interface — "Keyboard Hook Dumper", 1996–97](web/img/hookdump-screenshot.jpg)

*HookDump 2.8 interface — "Keyboard Hook Dumper", (C) iLya Osipov, N-Novgorod, 1996–97.
Screenshot by Iexeru, [CC BY-SA 4.0](https://commons.wikimedia.org/wiki/File:HookDump.jpg),
via Wikimedia Commons.*

- Home page: http://ctrl8.com/HookDump
- Source (MIT): https://github.com/ilya000/HookDump
- Author: iLya — Ilya V. Osipov · https://github.com/ilya000
- Original site: `www.ilya.nn.ru` (later archived under `old.osipov.ru`)
- Press, reviews and references: [PRESS.md](PRESS.md)

## Author's intent and origin

HookDump was **never conceived by the author as a destructive or malicious tool**. It
was written as a **monitoring / activity-logging program** for the computer on which it
was installed — to record how, when and for what purpose that machine was used.

It was originally developed **for a university department, on commission from the head of
the department**, to keep track of the time and purpose of use of the department's office
(work) computers. The contemporary press of the era later framed it as a "spy program."

Precisely because its purpose was **legitimate computer-use auditing** rather than covert
attack, HookDump also **entered the academic and technical literature**: beyond the
security/anti-virus books, it is used in a textbook on electronic publications as an
example of software for **collecting interface-usage statistics** (V. A. Vul,
*Электронные издания*, 2003) — in effect, early UX instrumentation. The full, footnoted
list of sources, with Wayback Machine archived versions, is in [PRESS.md](PRESS.md).

> Historical note: in the 1990s this was described, in the style of the time, as a
> "program-spy." By modern definitions it is a **keylogger**. It is published here as a
> record of early work and for study. Do not use it, or code derived from it, to capture
> anyone's input without their consent and lawful authority. See [NOTICE.md](NOTICE.md).

---

## Why it mattered (historical reference)

HookDump appeared when Windows 3.x / 95 had essentially no built-in protection against
input monitoring, and it became a reference example of how far a small Pascal program
could go. What made it notable at the time:

**Core features**
- Global keyboard hook via `SetWindowsHookEx(WH_KEYBOARD, …)` installed from a DLL, so
  every running application's keystrokes flowed through it.
- Logged **everything typed and clicked**, system-wide, to a file.
- Recorded **context** for each event: which program, which window title, which field —
  with timestamps.
- Optional **mouse-click** logging.
- Configurable granularity: log only alphanumerics + cursor keys, or **every** key
  including Caps Lock, Shift, Tab and the function keys.
- **AutoStartUp**: launch automatically with Windows and begin recording right after boot.
- Output as `.hk` text files in any chosen directory; optional **XOR obfuscation** of the
  log (`XorBase`) and write **buffering** (`BufSize`).
- A substantial (English) help file; whole package just over **50 KB**.

**Unique / standout solutions for its era**
- **Invisible to the user and to the Windows Task Manager** — the running process did not
  show up in the task list, which is precisely what made the press single it out.
- **Context logging of password fields** — it could capture *hidden* passwords, such as
  those stored in masked Dial-Up Networking fields, by reading the field context rather
  than just the visible characters.
- **Cross-process shared state via file mapping**: the hook DLL is injected into every
  process, so HookDump used a named shared memory section
  (`CreateFileMapping`/`MapViewOfFile`) to share the target window handle and the hook
  handle between the injected copies and the controlling application — a clean solution
  to the "DLL has per-process data" problem of Win16/Win32 hooks.
- **A managed uninstall path**: because it ran hidden, removal required relaunching it in
  visible mode with the `/V` switch and exiting — a deliberate design rather than an
  afterthought.
- **Dual use, ahead of its time**: the very same instrumentation was later cited in a
  textbook (V. A. Vul, *Электронные издания*, 2003) as a way to **collect interface-usage
  statistics** — essentially UX analytics, years before that term was common.

**Lineage**: HookDump grew out of the author's earlier program **HookRus**, a Russian
keyboard-layout patcher for Windows; the hooking core was reused and extended.

See [PRESS.md](PRESS.md) for the contemporary reviews (Computerra called version 2.8
"the best program in its class", 1999) and the full list of publications.

---

## How it works

The design is two parts: a **hook DLL** (`src/HOOKDLL.DPR`) and a small **controlling
application** (`src/MAIN.PAS`). All of the interesting work is in the DLL. (The recovered
`src/` is the demo/test build, which shows the hooking mechanism; the file-logging and the
hiding trick below live in the full `HOOKDUMP.EXE`, of which only the binary survives.)

**1. Shared state across every process.** A global `WH_KEYBOARD` hook injects the DLL into
*every* process. DLL data is per-process, so the shared state (the app's window handle and
the hook handle) lives in one **named file-mapping** visible to all copies:

```pascal
Const GlobMapID = 'Global Keyboard Hook Demo {917C91AA-...}';
Type  TShareInf = Record AppWndHandle: HWND; OldHookHandle: HHOOK; hm: THandle; End;

Procedure DLLEntryPoint(dwReason: DWORD); stdcall;     // on DLL_PROCESS_ATTACH:
Begin
  MapHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(TShareInf), GlobMapID);
  ShareInf  := MapViewOfFile(MapHandle, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TShareInf));
End;
```

**2. Install the hook and deliver keystrokes.** The app calls `SetKeyboardHook(Handle)`;
the DLL remembers the window and arms the system hook. Each keystroke is forwarded to that
window via `WM_USER`, then the hook chain continues with `CallNextHookEx`:

```pascal
Function SetKeyboardHook(Wnd: HWND): BOOL; stdcall;
Begin
  ShareInf^.AppWndHandle  := Wnd;
  ShareInf^.OldHookHandle := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHook, HInstance, 0);
  ...

Function KeyboardHook(Code: Integer; ParamW: WPARAM; ParamL: LPARAM): LRESULT; stdcall;
Begin
  If Code IN [HC_ACTION, HC_NOREMOVE] Then
    SendMessage(ShareInf^.AppWndHandle, WM_USER, ParamW, Code);   // key code -> window
  Result := CallNextHookEx(ShareInf^.OldHookHandle, Code, ParamW, ParamL);
End;
```

**3. Application side** (`MAIN.PAS`) — import from the DLL and receive the codes:

```pascal
Function SetKeyboardHook(Wnd: HWND): BOOL; stdcall; external 'HookDLL.dll' name 'SetKeyboardHook';

Procedure TMainForm.WMUser(var Message: TMessage);   // message WM_USER
Begin
  Memo1.Lines.Add('Code: '+IntToStr(Message.WParam)+';  Char: '+Chr(Message.wParam));
End;
```

### The key trick — making the program "disappear"

Once the hook is set, the DLL is already resident inside other processes and (in the full
build) writing the log — so the visible application is no longer needed. HookDump's trick:

- The program **exits, leaving the hook DLL resident.** No window, no process in the task
  list — only the invisible DLL living inside other processes. This is the "invisible in
  Task Manager" behaviour the press noted.
- To stop Windows from unloading the DLL automatically when the application exits, the
  **DLL was loaded twice**, so its reference count is **2**. Windows of that era, on
  cleanup, decrements the count by only one — so the DLL (and the active hook) stays alive.
- Removal therefore required deliberately relaunching in **visible mode (`/V`)** and
  unloading cleanly.

In short: the system hook has already spread the DLL across processes, and an artificially
raised reference count keeps the OS from unloading it once the original EXE is gone.

---

## The 2.8 release

The distributed archive `hookdump.zip` (dated 1998-01-09) contained four files:

| File | Purpose |
|------|---------|
| `HOOKDUMP.EXE` | the program (21,760 bytes) |
| `HOOKDMP.DLL`  | the hook DLL injected system-wide |
| `HOOKDUMP.HLP` | Windows help file |
| `HOOKDUMP.INI` | configuration |

The release archive and the historical binaries are preserved locally under
[`_backup/`](#repository-layout) (not tracked in git — see below).

### Configuration — `HOOKDUMP.INI`

```ini
[StartUp]
Show=00          ; start hidden
Dir=C:\          ; log directory; if absent, the Temp dir is used
file=_Hook       ; base file name; else a unique name with extension .hk
XorBase=85       ; XOR key used when XorOutput is on
BufSize=255      ; write buffer size

[Options]
WriteBasicKey=01    ; log ordinary keys
WritePopKey=00      ; log key-up events
WritePushKey=00     ; log key-down events
WriteExeName=01     ; record the active program name
WriteWindowName=01  ; record the active window title
AnsiToOem=00        ; ANSI -> OEM translation of logged text
RegardMouse=01      ; also log mouse clicks
XorOutput=00        ; obfuscate the log with XorBase
UseBuffer=01        ; buffer writes
```

---

## Repository layout

```
HookDump/
├─ src/                 Object Pascal sources (MIT, tracked) — the part to study
│  ├─ HOOKDLL.DPR       the keyboard-hook DLL (SetWindowsHookEx, file-mapping shared state)
│  ├─ HOOKPROJ.DPR      a demo/test application project (Delphi 32-bit)
│  ├─ MAIN.PAS          the test form: prints key codes, Set/Remove hook buttons
│  ├─ MAIN.DFM          the test form layout
│  └─ HOOKPROJ.RES      compiled resource for the demo project
├─ web/
│  └─ index.html        project home page (ctrl8.com/HookDump)
├─ README.md  PRESS.md  CHANGELOG.md  NOTICE.md  LICENSE
└─ _backup/             local-only archive — NOT tracked by git
   ├─ release-2.8/hookdump.zip                 the distributed 2.8 archive
   └─ original/
      ├─ MY_PROG_HOOK/  HOOKDMP.DLL, HOOKDUMP.HLP/.GID/.INI
      ├─ hookproj/      full original project incl. HOOKPROJ.exe, HOOKDLL.dll, .dcu
      ├─ hookd.htm      original Russian product page (CP1251)
      └─ hookde.htm     original English product page
```

`src/` holds the **demo/test project** that exercises the hook DLL: `MAIN.PAS` calls
`SetKeyboardHook` / `RemoveKeyboardHook` exported from `HOOKDLL.dll` and prints incoming
key codes to a memo. The shipped `HOOKDUMP.EXE` is the file-logging build of the same
technique.

**What is and isn't in git.** The Object Pascal **sources** (`src/`) are published under
MIT for study. The compiled **Windows binaries and the release archive** are kept only in
`_backup/` (git-ignored): they are 1990s keylogger executables, of historical interest
but not something to ship in a public repository.

---

## Building

These are mid-1990s Delphi-era Object Pascal sources. They are kept for historical and
educational study; there is no modern build wired up. To compile them you would need a
period Delphi, or a port to **Free Pascal / Lazarus** targeting Win32. The Windows hook
APIs used (`SetWindowsHookEx`, `CallNextHookEx`, `UnhookWindowsHookEx`, file mapping for
cross-process state) still exist on modern Windows, but the program is **not** intended
to be rebuilt or run as live software.

> Note on language: the Russian Wikipedia article describes the original release as
> written in Turbo Pascal (Win16, 21,760-byte EXE). The sources recovered here are the
> later **Delphi / Object Pascal** project (the demo `HOOKPROJ.exe` is a 32-bit build),
> so the two builds differ in toolchain and size.

---

## History (versions)

- **HookRus** — earlier Russian keyboard-layout patcher; HookDump grew out of its hook code.
- **1996** — first release (per Russian Wikipedia).
- **2.5** — glitch when logging into Windows under a different name.
- **2.6** — no warning window on repeated hidden launch; uninstall via `/V` (visible mode);
  the 2.5 login-name glitch fixed.
- **2.7** — version documented on the English product page.
- **2.8** — version on the Russian product page; release archive dated 1998-01-09;
  reviewed as best in class by *Computerra* (1999).

Created 1997-10-23 (per the product page), Nizhny Novgorod. See [CHANGELOG.md](CHANGELOG.md).

---

## License and rights

Source code: **MIT License** — see [LICENSE](LICENSE). Copyright © 1996–1998, 2026
Ilya V. Osipov. Commercial and economic rights to the author's software and content are
held by Anna Club LLC (Florida); the author retains authorship. The historical binaries
are provided **as is**, for study only — see [NOTICE.md](NOTICE.md).
