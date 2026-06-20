# HookDump — press, reception and references

HookDump was one of the best-known Russian "spy programs" (keyloggers) of the late
1990s and early 2000s. It was distributed freely, written about in the computer press,
and included in security and anti-virus books.[^wiki][^wikiuk] It is, as of today, of
historical interest only: it was a 16-bit program whose system-wide hook depended on the
16-bit Windows multitasking model, and it does not run on modern (32-/64-bit) Windows.

Crucially, the program **originated as a legitimate monitor** — written for a university
department, on commission from the head of the department, to track the time and purpose
of use of the department's office computers (see [NOTICE.md](NOTICE.md)). Because its
purpose was lawful computer-use auditing rather than covert attack, **it also entered the
academic and technical literature**: it is discussed not only in security/anti-virus
books but is used in a textbook on electronic publications as an example of software for
**collecting interface-usage statistics**[^vul] — essentially early UX instrumentation.

---

## Press

### Computerra (Компьютерра) — "Spy Gadgets", 21 Sep 1999
The weekly magazine *Computerra*, in the column "Spy Gadgets" ("Шпионские штучки") by
Nikolai Maslennikov (Николай Масленников), reviewing programs of this class, called
HookDump 2.8 the best of them:[^cterra]

> "HookDump 2.8 is, in my view, the best program in this class"
>
> *(original: «программа HookDump 2.8 — самая лучшая, на мой взгляд, в этом классе»)*

The review highlighted its flexible configuration (choosing which keystrokes to log —
alphanumerics and cursor keys only, or every key including Caps Lock, Shift, Tab and
function keys), logging of program/window/field context with timestamps, capture of
hidden Dial-Up Networking passwords, optional mouse-click logging, an `AutoStartUp`
option for launching with Windows, a size of just over 50 KB, `.hk` text logs in any
chosen directory via `hookdump.ini`, and a substantial (English) help file. It
concluded that the program left

> "the most pleasant impression"  *(original: «самое приятное впечатление»)*

— simple to install and completely invisible while running.

### Xakep (Хакер) — "Hook Dump", 30 Jan 2001
*Xakep* described it succinctly as a spy program and hosted `hookdump.zip` for
download:[^xakep][^xakeparc]

> "A spy program. It records everything that was typed on the keyboard or clicked with the mouse."
>
> *(original: «Программа-шпион. Ведет запись всего, что было набрано на клавиатуре или кликнуто мышью.»)*

with one reservation about the UI:

> "True, the app has a clumsy interface, which somewhat spoils the impression."
>
> *(original: «Правда, прога имеет кривоватый интерфейс, что несколько портит впечатление.»)*

---

## Academic and technical literature

- **V. A. Vul (В. А. Вул) — *Electronic Publications* (Электронные издания)** (BHV-Petersburg,
  2003). Chapter 8 uses HookDump as an example of software for collecting
  interface-usage statistics.[^vul]
- **Oleg Zaytsev (Олег Зайцев) — *Rootkits, Spyware/Adware, Keyloggers and Backdoors:
  Detection and Protection* (…: обнаружение и защита)** (BHV-Petersburg, 2006). HookDump
  cited among notable keyloggers.[^zaytsev]
- **Igor Gulev (Игорь Гулев) — *Creating a Virus and an Antivirus* (Создаём вирус и
  антивирус)** (DMK Press, Moscow, 2000).[^gulev]
- **Anton A. Orlov (Антон А. Орлов) — *Secrets and Mysteries of the Computer* (Тайны и
  секреты компьютера).**[^orlov]
- **V. I. Gromov & G. A. Vasilyev (В. И. Громов, Г. А. Васильев) — *Encyclopedia of
  Security* (Энциклопедия безопасности).**[^gromov]

---

## How it was characterised

- A *user-activity monitoring system* as well as *spyware* — the same tool served both
  legitimate interface-usage statistics (Vul) and covert monitoring.
- Peak popularity: **late 1990s**.
- Repeatedly singled out as **best in class** among contemporary keyloggers (Computerra).
- Known for being **invisible in the Windows Task Manager** and for **context logging** of
  password fields (e.g. hidden Dial-Up Networking passwords).

*Quotations are reproduced verbatim, for documentary purposes, from the cited publications;
English translations are editorial.*

---

## References

[^wiki]: *HookDump* // Russian Wikipedia (Русская Википедия). URL:
    https://ru.wikipedia.org/wiki/HookDump — archived from the original on 10 January 2026:
    https://web.archive.org/web/20260110051704/https://ru.wikipedia.org/wiki/HookDump

[^wikiuk]: *HookDump* // Ukrainian Wikipedia (Українська Вікіпедія). URL:
    https://uk.wikipedia.org/wiki/HookDump — archived from the original on 10 April 2026:
    https://web.archive.org/web/20260410063419/https://uk.wikipedia.org/wiki/HookDump

[^cterra]: Nikolai Maslennikov (Николай Масленников). *Spy Gadgets* ("Шпионские штучки") //
    Computerra (Компьютерра). — 1999. — No. 316 (21 September 1999). URL:
    http://old.computerra.ru/1999/316/195937/ — archived from the original on
    8 December 2023:
    https://web.archive.org/web/20231208135116/https://old.computerra.ru/1999/316/195937/

[^xakep]: *Hook Dump* // Xakep (Хакер). — 30 January 2001. URL:
    https://xakep.ru/2001/01/30/11850/ — archived from the original on 6 October 2025:
    https://web.archive.org/web/20251006040730/https://xakep.ru/2001/01/30/11850/

[^xakeparc]: Mikhail Zhigulin (Михаил Жигулин). *Hook Dump* // Xakep archive (Архив
    «Хакер», xakep-archive.ru), issue 003. URL: http://xakep-archive.ru/xa/003/086/1.asp.htm
    — archived from the original on 13 January 2020:
    https://web.archive.org/web/20200113212907/http://xakep-archive.ru/xa/003/086/1.asp.htm

[^vul]: V. A. Vul (В. А. Вул). *Electronic Publications* (Электронные издания). — St.
    Petersburg: BHV-Petersburg (БХВ-Петербург), 2003. — ISBN 978-5-94157-047-8. Ch. 8
    (example of using HookDump to collect interface-usage statistics). Full text (Moscow
    State University of Printing / МГУП), ch. VIII:
    http://www.hi-edu.ru/e-books/xbook119/01/part-009.htm — archived from the original on
    9 May 2021:
    https://web.archive.org/web/20210509142133/http://hi-edu.ru/e-books/xbook119/01/part-009.htm
    · Google Books: https://books.google.com/books?id=7kC6AgAAQBAJ

[^zaytsev]: O. V. Zaytsev (О. В. Зайцев). *Rootkits, Spyware/Adware, Keyloggers and
    Backdoors: Detection and Protection* (…: обнаружение и защита). — St. Petersburg:
    BHV-Petersburg (БХВ-Петербург), 2006. — ISBN 5-94157-868-7. Russian State Library
    (РГБ, search.rsl.ru), record: https://search.rsl.ru/ru/record/01002955084 — archived
    from the original on 16 October 2017:
    https://web.archive.org/web/20171016185032/http://search.rsl.ru:80/ru/record/01002955084
    · Google Books: https://books.google.com/books?id=faDVAwAAQBAJ

[^gulev]: I. A. Gulev (И. А. Гулев). *Creating a Virus and an Antivirus* (Создаём вирус и
    антивирус). — Moscow: DMK Press (ДМК Пресс), 2000. — ISBN 5-89818-087-7. URL:
    http://flibusta.site/b/320770 — archived from the original on 31 May 2025:
    https://web.archive.org/web/20250531000659/http://flibusta.site/b/320770

[^orlov]: A. A. Orlov (Антон А. Орлов). *Secrets and Mysteries of the Computer* (Тайны и
    секреты компьютера). URL:
    http://www.rulit.me/books/tajny-i-sekrety-kompyutera-read-204171-98.html — archived
    from the original on 29 May 2025:
    https://web.archive.org/web/20250529045717/https://www.rulit.me/books/tajny-i-sekrety-kompyutera-read-204171-98.html

[^gromov]: V. I. Gromov & G. A. Vasilyev (В. И. Громов, Г. А. Васильев). *Encyclopedia of
    Security* (Энциклопедия безопасности). URL: http://www.e-reading.club/book.php?book=17128
    — archived from the original on 1 December 2024:
    https://web.archive.org/web/20241201025618/https://www.e-reading.club/book.php?book=17128
