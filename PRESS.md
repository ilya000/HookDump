# HookDump — press, reception and references

HookDump was one of the best-known Russian "spy programs" (keyloggers) of the late
1990s and early 2000s. It was distributed freely, written about in the computer press,
and included in security and anti-virus books.[^wiki]

Crucially, the program **originated as a legitimate monitor** — written for a university
department, on commission from the head of the department, to track the time and purpose
of use of the department's office computers (see [NOTICE.md](NOTICE.md)). Because its
purpose was lawful computer-use auditing rather than covert attack, **it also entered the
academic and technical literature**: it is discussed not only in security/anti-virus
books but is used in a textbook on electronic publications as an example of software for
**collecting interface-usage statistics**[^vul] — essentially early UX instrumentation.

---

## Press

### Компьютерра (Computerra) — "Шпионские штучки", Николай Масленников, 21 Sep 1999
The weekly magazine *Computerra*, reviewing programs of this class, called HookDump 2.8
the best of them:[^cterra]

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

### Хакер (Xakep) — "Hook Dump", 30 Jan 2001
*Xakep* described it succinctly as a spy program and hosted `hookdump.zip` for
download:[^xakep][^xakeparc]

> «Программа-шпион. Ведет запись всего, что было набрано на клавиатуре или кликнуто мышью.»

with one reservation about the UI:

> «Правда, прога имеет кривоватый интерфейс, что несколько портит впечатление.»

---

## Academic and technical literature

- **В. А. Вул — «Электронные издания»** (БХВ-Петербург, 2003). Chapter 8 uses HookDump as
  an example of software for collecting interface-usage statistics.[^vul]
- **Олег Зайцев — «Rootkits, Spyware/Adware, Keyloggers and Backdoors: обнаружение и
  защита»** (БХВ-Петербург, 2006). HookDump cited among notable keyloggers.[^zaytsev]
- **Игорь Гулев — «Создаём вирус и антивирус»** (ДМК Пресс, Москва, 2000).[^gulev]
- **Антон А. Орлов — «Тайны и секреты компьютера».**[^orlov]
- **В. И. Громов, Г. А. Васильев — «Энциклопедия безопасности».**[^gromov]

---

## How it was characterised

- A *user-activity monitoring system* as well as *spyware* — the same tool served both
  legitimate interface-usage statistics (Vul) and covert monitoring.
- Peak popularity: **late 1990s**.
- Repeatedly singled out as **best in class** among contemporary keyloggers (Computerra).
- Known for being **invisible in the Windows Task Manager** and for **context logging** of
  password fields (e.g. hidden Dial-Up Networking passwords).

*Quotations are reproduced for documentary purposes from the cited publications.*

---

## References

[^wiki]: *HookDump* // Русская Википедия. URL: https://ru.wikipedia.org/wiki/HookDump —
    archived from the original on 10 January 2026:
    https://web.archive.org/web/20260110051704/https://ru.wikipedia.org/wiki/HookDump

[^cterra]: Масленников Н. *Шпионские штучки* // Компьютерра. — 1999. — № 316 (21 сентября
    1999). URL: http://old.computerra.ru/1999/316/195937/ — archived from the original on
    8 December 2023:
    https://web.archive.org/web/20231208135116/https://old.computerra.ru/1999/316/195937/

[^xakep]: *Hook Dump* // Хакер (Xakep). — 30 января 2001. URL:
    https://xakep.ru/2001/01/30/11850/ — archived from the original on 6 October 2025:
    https://web.archive.org/web/20251006040730/https://xakep.ru/2001/01/30/11850/

[^xakeparc]: Жигулин М. *Hook Dump* // Архив «Хакер» (xakep-archive.ru), вып. 003.
    URL: http://xakep-archive.ru/xa/003/086/1.asp.htm — archived from the original on
    13 January 2020:
    https://web.archive.org/web/20200113212907/http://xakep-archive.ru/xa/003/086/1.asp.htm

[^vul]: Вул В. А. *Электронные издания.* — СПб.: БХВ-Петербург, 2003. — ISBN
    978-5-94157-047-8. Гл. 8 (пример использования HookDump для сбора статистики
    использования интерфейсов). Google Books:
    https://books.google.com/books?id=7kC6AgAAQBAJ

[^zaytsev]: Зайцев О. В. *Rootkits, Spyware/Adware, Keyloggers and Backdoors: обнаружение
    и защита.* — СПб.: БХВ-Петербург, 2006. — ISBN 978-1-931769-59-4. Google Books:
    https://books.google.com/books?id=faDVAwAAQBAJ

[^gulev]: Гулев И. А. *Создаём вирус и антивирус.* — М.: ДМК Пресс, 2000. — ISBN
    5-89818-087-7. URL: http://flibusta.site/b/320770 — archived from the original on
    31 May 2025:
    https://web.archive.org/web/20250531000659/http://flibusta.site/b/320770

[^orlov]: Орлов А. А. *Тайны и секреты компьютера.* URL:
    http://www.rulit.me/books/tajny-i-sekrety-kompyutera-read-204171-98.html — archived
    from the original on 29 May 2025:
    https://web.archive.org/web/20250529045717/https://www.rulit.me/books/tajny-i-sekrety-kompyutera-read-204171-98.html

[^gromov]: Громов В. И., Васильев Г. А. *Энциклопедия безопасности.* URL:
    http://www.e-reading.club/book.php?book=17128 — archived from the original on
    1 December 2024:
    https://web.archive.org/web/20241201025618/https://www.e-reading.club/book.php?book=17128
