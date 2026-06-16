# HookDump — press, reception and references

HookDump was one of the best-known Russian "spy programs" (keyloggers) of the late
1990s and early 2000s. It was distributed freely, written about in the computer press,
included in security/anti-virus books, and even used as a teaching example. This file
collects what was published about it, with sources.

> The program also has its own article in the Russian Wikipedia:
> https://ru.wikipedia.org/wiki/HookDump

---

## Press

### Компьютерра (Computerra) — "Шпионские штучки", Николай Масленников, 21 Sep 1999
The weekly magazine *Computerra*, reviewing programs of this class, called HookDump 2.8
the best of them:

> «программа HookDump 2.8 — самая лучшая, на мой взгляд, в этом классе»

The review highlighted its flexible configuration (choosing which keystrokes to log —
alphanumerics and cursor keys only, or every key including Caps Lock, Shift, Tab and
function keys), logging of program/window/field context with timestamps, capture of
hidden Dial-Up Networking passwords, optional mouse-click logging, an `AutoStartUp`
option for launching with Windows, a size of just over 50 KB, `.hk` text logs in any
chosen directory via `hookdump.ini`, and a substantial (English) help file. It
concluded that the program left

> «самое приятное впечатление»

(the most pleasant impression) — simple to install and completely invisible while
running.

Source: http://old.computerra.ru/1999/316/195937/

### Хакер (Xakep) — "Hook Dump", 30 Jan 2001
*Xakep* described it succinctly as a spy program and hosted `hookdump.zip` for download:

> «Программа-шпион. Ведет запись всего, что было набрано на клавиатуре или кликнуто мышью.»

with one reservation about the UI:

> «Правда, прога имеет кривоватый интерфейс, что несколько портит впечатление.»

Source: https://xakep.ru/2001/01/30/11850/ · archive: http://xakep-archive.ru/xa/003/086/1.asp.htm

---

## Books and other references

- **Олег Зайцев — «Rootkits, Spyware/Adware, Keyloggers and Backdoors: обнаружение и
  защита»** (БХВ-Петербург, 2006). HookDump cited among notable keyloggers.
- **В. А. Вул — «Электронные издания»** (БХВ-Петербург, 2003). Chapter 8 uses HookDump
  as an example of collecting interface-usage statistics — i.e. as a legitimate UX /
  instrumentation tool, not only as spyware.
- **Игорь Гулев — «Создаём вирус и антивирус»** (ДМК Пресс, Москва, 2000).
- **Антон А. Орлов — «Тайны и секреты компьютера»**.
- **В. И. Громов, Г. А. Васильев — «Энциклопедия безопасности»**.

---

## How it was characterised

- A *user-activity monitoring system* as well as *spyware* — the same tool was used both
  for legitimate interface-usage statistics (Vul) and as a covert monitor.
- Peak popularity: **late 1990s**.
- Repeatedly singled out as **best in class** among contemporary keyloggers (Computerra).
- Known for being **invisible in the Windows Task Manager** and for **context logging**
  of password fields (e.g. hidden Dial-Up Networking passwords).

*Quotations are reproduced for documentary purposes from the cited publications.*
