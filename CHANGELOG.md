# Changelog

All entries below are reconstructed from the original 1997–1998 product pages
(`hookd.htm` in Russian, `hookde.htm` in English) preserved in the `old.osipov.ru`
archive. Dates are taken from those pages and from the release archive timestamps.

## 2.8 — release archive dated 1998-01-09
- Version advertised on the Russian product page as the current release.
- Distributed as `hookdump.zip`: `HOOKDUMP.EXE`, `HOOKDMP.DLL`, `HOOKDUMP.HLP`,
  `HOOKDUMP.INI`.

## 2.7
- Version documented on the English product page.

## 2.6
- No longer shows a warning window when launched again in hidden mode while an
  instance is already present in the system in hidden mode.
- Uninstall procedure: relaunch forcibly in visible mode with the `/V` switch, then
  exit, after which the program can be removed.
- Fixed the 2.5 glitch that occurred when logging into the system under a different name.

## 2.5
- Known glitch when a user logged into Windows under a different name (fixed in 2.6).

## Origins — 1997
- Created 1997-10-23 in Nizhny Novgorod.
- Derived from **HookRus**, the author's earlier Russian keyboard-layout patcher for Windows.

---

## Restoration (2026)
- Recovered the Delphi / Object Pascal sources and the historical 2.8 release from the
  author's local archives.
- Established HookDump as a standalone project with tracked sources under `src/`,
  the release archive under `release/`, and historical Windows binaries kept locally
  under `_backup/` (not tracked).
- Release integrity: `hookdump.zip` SHA-256
  `4a28eff0883fda50483cd559ee5ce54e06d0248683db0b22ab61e8d5b58bbeb5`.
