# HookDump — source code

The **original** HookDump source was recovered in 2026 from the author's encrypted
archives (`HOOK_DL2.RAR` / `HOOK3_00.RAR` inside `RW_COPY.RAR`, dated 1998-02-21). Three
code lines are kept here:

## `original-16bit/` — the original (Borland Pascal for Windows, 16-bit)
The genuine HookDump source, as shipped in versions up to 2.8.

- `HOOKDUMP.PAS` — the application (`program HookDump`): window, menu, options, the
  `/V` visible-mode and hidden-mode logic, INI handling, install via `WIN.INI [Windows] Load=`.
- `HOOKDMP.PAS` — the hook **DLL** (`library HookDmp`): the actual capture via a
  **`WH_GETMESSAGE`** hook (`MsgHookProc` → `DefHookProc`), writing keystrokes / mouse /
  program+window context to the log, with buffering, optional XOR obfuscation and
  ANSI→OEM translation; flushes on `ExitProc`.
- `TYPES.PAS` — shared types/options record (`{$I types}` include).
- `SWITCH.PAS` — single-instance / window-switch helper.

Uses the author's own Pascal-for-Windows units `ioGDI`, `ioString` (compiled `.TPW`
units preserved under `_backup/`; their own source was not in the archive).

## `port-32bit-delphi/` — 32-bit Delphi port
A later port of HookDump to 32-bit Delphi (VCL): `HOOK32.DPR`, `HOOK32.PAS`,
`HOOKMAIN`, `ABOUT`, `OPTION`, `GLOBAL`, `TYPES`, `SWITCH` (+ `.DFM` forms, `.RES`).

## `successor-hookproj/` — minimal Delphi hook demo
A small separate demo project (`HOOKDLL.DPR` + `HOOKPROJ`/`MAIN`) that exercises a
keyboard hook from a DLL. Recovered earlier; reuses the technique but is **not** the
original HookDump.

---

## Encoding & headers

The Pascal sources in `original-16bit/`, `port-32bit-delphi/` and `successor-hookproj/`
have been **re-encoded from the original Windows-1251 (CP1251) to UTF-8**, and each file
carries a short header comment (one-line description, author, date, link to this
repository, and a pointer to its historical original).

The **byte-exact, unmodified originals** (still CP1251) are preserved in
[`historical-originals/`](historical-originals) — see the README there. The complete
recovered working tree (binaries, compiled units, help sources, `ARHIV/` version archive
v1.5 … v2.8) is also kept locally under `_backup/original-source/`.
