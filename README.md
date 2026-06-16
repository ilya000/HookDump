# HookDump

A keyboard / mouse logging program for 16- and 32-bit Windows (Windows 3.1 through
Windows 95 and later), written in Delphi / Object Pascal in **Nizhny Novgorod in 1997**.
This repository preserves the original program as a **historical software artifact**.

Home page: http://ctrl8.com/HookDump
Author: iLya — Ilya V. Osipov · https://github.com/ilya000
Original site: `www.ilya.nn.ru` (later archived under `old.osipov.ru`)

---

## What it does

HookDump installs a global Windows keyboard hook (`SetWindowsHookEx(WH_KEYBOARD, …)`)
from a DLL and records, to a file, everything typed on the keyboard and clicked with
the mouse while it runs in the background. For each event it also notes which program,
window and field it happened in.

It was derived from an earlier program by the same author — **HookRus**, a Russian
keyboard-layout patcher for Windows — and grew out of that hooking code.

The latest release (2.8, archive dated 1998-01-09) ships four files:

| File | Purpose |
|------|---------|
| `HOOKDUMP.EXE` | the program |
| `HOOKDMP.DLL`  | the hook DLL that is injected system-wide |
| `HOOKDUMP.HLP` | Windows help file |
| `HOOKDUMP.INI` | configuration |

> Note on terminology: in 1997 this was described, in period style, as a "program-spy."
> By modern definitions it is a **keylogger**. It is preserved here only as a record of
> the author's early work. See [NOTICE.md](NOTICE.md).

---

## How it worked (from the original 1997–98 documentation)

- The program embeds itself into the system and becomes invisible to the user, writing
  every action to a file: keystrokes, mouse clicks, and the program / window / field
  context in which they happened.
- The output file is created automatically in a chosen directory with a unique or
  specified name. Recording begins immediately after the OS starts.
- Writes happen immediately or are buffered; the normal state of the file is *closed*.
- To uninstall, the program had to be relaunched **in visible mode** with the `/V`
  switch and then exited — after which it could be safely removed.

### Configuration — `HOOKDUMP.INI`

```ini
[StartUp]
Show=00          ; start hidden
Dir=C:\          ; target directory for the log; if absent, the Temp dir is used
file=_Hook       ; base file name; if absent, a unique name with extension .hk is created
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
├─ src/                 Delphi / Object Pascal sources (buildable set)
│  ├─ HOOKDLL.DPR       the keyboard-hook DLL (SetWindowsHookEx, CallNextHookEx, …)
│  ├─ HOOKPROJ.DPR      the demo/test application project
│  ├─ MAIN.PAS          the test form: prints key codes, Set/Remove hook buttons
│  ├─ MAIN.DFM          the test form layout
│  └─ HOOKPROJ.RES      compiled resource for the project
├─ release/
│  └─ hookdump.zip      historical 2.8 release (the four files above)
│                       SHA-256 4a28eff0883fda50483cd559ee5ce54e06d0248683db0b22ab61e8d5b58bbeb5
├─ web/
│  └─ index.html        project home page (ctrl8.com/HookDump)
└─ _backup/             local-only historical binaries (not in git)
   └─ binaries/         HOOKPROJ.exe, HOOKDLL.dll, HOOKDMP.DLL, HOOKDUMP.HLP/.GID/.INI
```

The `src/` folder is the **demo/test project** that exercises the hook DLL (`HOOKDLL`):
`MAIN.PAS` calls `SetKeyboardHook` / `RemoveKeyboardHook` exported from `HOOKDLL.dll`
and prints incoming key codes to a memo. The shipped `HOOKDUMP.EXE` is the
file-logging build of the same hooking technique; the compiled binaries are kept under
`_backup/binaries/` and are not tracked by git.

---

## Building

These are mid-1990s Delphi sources (Delphi 2/3 era). They are kept for historical and
educational study; there is no modern build wired up. To compile them you would need a
period Delphi, or a port to **Free Pascal / Lazarus** targeting Win32. The Windows hook
APIs used (`SetWindowsHookEx`, `CallNextHookEx`, `UnhookWindowsHookEx`, file-mapping for
cross-process state) still exist on modern Windows, but the program is **not** intended
to be rebuilt or run as live software.

---

## History

- **HookRus** — earlier Russian keyboard-layout patcher; HookDump grew out of its hook code.
- **2.5** — had a glitch when a user logged into Windows under a different name.
- **2.6** — no longer shows a warning window when relaunched hidden while an instance is
  already running hidden; uninstall via `/V` (visible mode); the 2.5 login-name glitch fixed.
- **2.7** — version documented on the English product page.
- **2.8** — version on the Russian product page; the release archive is dated 1998-01-09.

Created 1997-10-23, Nizhny Novgorod.

See [CHANGELOG.md](CHANGELOG.md).

---

## License and rights

Preserved as a historical artifact. Copyright © 1997 Ilya V. Osipov. Commercial and
economic rights are held by Anna Club LLC (Florida); the author retains authorship.
Provided **as is**, without warranty of any kind. Not for malicious use. See
[NOTICE.md](NOTICE.md).
