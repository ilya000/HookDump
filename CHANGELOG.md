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

## Origins — 1996–1997
- First release in **1996** (per the Russian Wikipedia article).
- Product page dated 1997-10-23, Nizhny Novgorod.
- Derived from **HookRus**, the author's earlier Russian keyboard-layout patcher for Windows.

## Reception
- **Computerra**, "Шпионские штучки" (1999-09-21) — called HookDump 2.8 "the best program
  in its class."
- **Xakep / Хакер** (2001-01-30) — featured it and hosted `hookdump.zip`.
- Cited in security/anti-virus books and used as a UX-instrumentation example
  (V. A. Vul, *Электронные издания*, 2003). See [PRESS.md](PRESS.md).

---

## Restoration (2026)
- Recovered the Object Pascal sources, the original product pages, and the historical 2.8
  release from the author's local archives.
- Established HookDump as a standalone project: sources published under the **MIT License**
  in `src/`; all archives and Windows binaries consolidated locally under `_backup/`
  (not tracked in git).
- Compiled the historical reference and press record (Computerra, Xakep, books) into
  `README.md` and `PRESS.md`.
- Release integrity: `hookdump.zip` SHA-256
  `4a28eff0883fda50483cd559ee5ce54e06d0248683db0b22ab61e8d5b58bbeb5`.
