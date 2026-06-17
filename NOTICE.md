# NOTICE — historical artifact and responsible use

HookDump is a Windows keyboard / mouse logging program written in 1996–1997. The source
code is published under the **MIT License** (see [LICENSE](LICENSE)) so that anyone may
**study** it as a piece of late-1990s Windows software history. This notice records the
rights and the responsible-use expectations that accompany it.

## Author's intent and origin
HookDump was **never intended by its author as a destructive or malicious program**. It
was built as a **monitor** — to log activity on the computer on which it was installed,
recording how and when that machine was used. It was originally written **for a
university department, commissioned by the head of the department**, to monitor the time
and purpose of use of the department's office (work) computers.

## Rights
- Copyright © 1996–1998, 2026 Ilya V. Osipov ("iLya"), Nizhny Novgorod.
- Released by the author under the MIT License (see [LICENSE](LICENSE)) as a historical
  software artifact.

## Source and historical binaries
- The **original source** (Borland Pascal for Windows, 16-bit) was recovered and is
  published in `src/` under the MIT License. The historical version releases (v1.5 … v2.8),
  including the period binaries, are published under `versions/`.
- **The program does not run on modern systems.** It was a **16-bit Windows** program
  (Windows 3.x, and the Win16 subsystem of 95/98). Its system-wide hook depended on the
  16-bit shared-address-space multitasking model; the move to 32-bit isolated per-process
  address spaces broke it, and it will not execute on current 64-bit Windows.
- **Do not run the binaries on a live system.** They are functionally a keylogger.

## Third-party assets
- `web/img/hookdump-screenshot.jpg` — screenshot of the HookDump interface, by Wikimedia
  Commons user **Iexeru**, licensed **CC BY-SA 4.0**
  (https://commons.wikimedia.org/wiki/File:HookDump.jpg). This image is *not* covered by
  the MIT License above; reuse it under CC BY-SA 4.0 with attribution.

## Responsible use
- The MIT grant covers studying, copying and modifying the **source code**. It is not an
  invitation to deploy keylogging against people.
- Do not use this software, or code derived from it, to monitor, surveil, or capture the
  input of any person without that person's informed consent and lawful authority.
  Capturing keystrokes — including passwords — without consent is illegal in most
  jurisdictions. The author and rights holder accept no liability for misuse.
