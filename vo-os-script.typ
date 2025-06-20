#import "@local/templates:0.1.0": *

#show: generic.with(
  title: "VO Operating Systems",
  title_extra: "V1",
  date: "16.06.2025",
)

#v(6cm)
#align(center)[
  _Erstellt mit den hervorragenden Foliensätzen von Peter Thoman \
  und den Foliensätzen von Herr Radush, \
  die die Lehrveranstaltung Betriebssysteme leiten.
  _
]
#pagebreak()

#outline()
#pagebreak()

= Betriebssystem
== Definition:
- Software zur Verwaltung der Computerhardware
- Low-Level Grundlage der Anwendungsprogramme
- Interface zwischen User und Hardware

== Ziele:
- Ausführen von User-Programmen
- Benutzerfreundliche/einfache Lösung von Problemen _(higher level programming)_
- effiziente Nutzung der Hardware

= Struktur eines Computersystems
== Hardware
grundlegende Ressourcen wie:
- CPU,
- GPU,
- RAM,
- usw.

== Anwendungsprogramme
- Verwenden Ressourcen der Hardware um Probleme zu Lösen
- Programme wie Textverarbeitung, usw.

== Benutzer
- Mensch, Maschinen bzw. andere Computer

Das Betriebssystem stellt wie bereits angesprochen die Schnittstelle zwischen
Benutzer und Hardware bereit. Dabei stellt es eine angemessene Performance,
security und Benutzerfreundlichkeit bereit. Es kann in Ein- bzw.
Mehrfachbenutzergeräten und in Embeddedsystems verwendet werden. Hier stellt es
die Hardware Ressources und die Kontrolle für die einzelnen Prozesse bereit.

== Userinterface
- CLI (Command Line Interface)
- GUI (Graphical User Interface)

= Aufbau
== Kernel
- Startet mit als erstes beim Einschalten des Computers
- läuft im Hintergrund bis zum Abschalten des Systems

Es Wird zwischen Präemptiven und Kooperativen (nicht prämptiven) Kernels
unterschieden:
- *Präemptiv:*
Ein laufender Prozess kann von dem Betriebssystem unterbrochen werden, auch
wenn er nicht _freiwillig_ den Prozessor freigibt. Dies ist notwendig, wenn
eine Prozess mit höherer Priorität bereit ist auf dem Prozessor zu laufen.
- *Kooperativ:*
Ein laufender Prozess kann *nicht* von dem Betrisbsystem unterbrochen werden.
Dieser muss _freiwillig_ den Prozessor verlassen. Dies bringt eine langsamere
Reaktionszeit mit sich, zugrunde einer geringeren Komplexität. Bei schlechter
Programmieren kann ein Prozessor langfristig _verstopfen_.

== System services
- Systemprogramme und Deamons _(im Hintergrund laufende Prozesse, welche meist
  für den Benutzer nicht direkt sichtbar sind)_
- Treiber
- Systembibliotheken _(Libraries)_
- GUI
- CLI Schnittstelle

== Middleware
- erleichtern die Anwendung (.NET, ...)
- Datenbanken
- Grafik (X-Window System, ...)

#figure(image("/images/os-aufbau.png", width: 80%))

== Organistation
Die CPU und der Gerätekontroller ist durch den Systembus mit dem Speicher (RAM)
verbunden. Die Treiber der einzelnen Geräte ist die Schnittstelle zwischen der
wirklichen Hardware bzw. dem Gerätekontroller und dem restlichen System über
den Systembus. Dadurch wird ein gemeinsamer Zugriff auf den Speicher
ermöglicht. Durch Interrupts wird eine gleichzeitige Ausührung von der CPU und
den Geräten ermöglicht.

== Betriebssystem Ablauf
*Bootstrapping:*

+ Bios: (ROM)
+ Systeminitialisierung
+ Kernel wird geladen
+ Start der Systemdienste

= I/O Operation
Das Programm stellt eine I/O Request über das Betriebssystem an den
Gerätetreiber und lädt die benötigten Register. Der Gerätekontroller
prüft die Register und führt die angefragte Aktion aus _(z.b. Zeichen von
Tastatur lesen)_. Die Daten werden in einem lokalen Buffer gespeichert und der
Kontroller informiert über den Gerätetreiber das die Aktion abgeschlossen
wurde. Nun findet ein Interrupt ausgelöst vom Systembus statt, was die
Kontrolle an das System zurückgibt. Die Daten (und Statusinformationen)
können gelesen werden.

*Timeline:*
#figure(image("./images/io-timeline.png", width: 80%))

= Interrupts und Interrupt based Systems
Werden vom Gerätekontroller ausgelöst. Nach jedem CPU Cycle wird überprüft ob
ein Interrupt vorliegt. Der Interrupt wird von der CPU abgefangen und an einen
Interrupthandler weitergeleitet. Der Interrupthandler speichert die Adresse des
Unterbrochenen Befehls und die Register der CPU. Weiter wird der Interrupt
verarbeitet. Schlussendlich wird der Zustand vor dem Interrupt wieder
hergestellt. Jeder Interrupt hat einen Interruptvektor. Dieser beinhaltet die
Interrupt-Zahl, die Adresse des Interrupthandlers und die Interruptchain. Es
gibt _Unmaskierte(nicht ausschaltbar, z.b. Speicherfehler)_ und
_Maskierte(ausschaltbar)_ Interrupts. Interrupts haben unterschiedliche
Prioritäten.

*Interrupttypen:*
- Hardwareinterrupts (Geräte)
- Softwareinterrupts (Exception, Trap, Error, Syscall, Segfault, ...)


*Interrupt-cycle (I/O):*
#figure(image("./images/io-cycle.png", width: 50%))

== direct Memory-Access
#grid(
  columns: (50%, 50%),
  align: (left, center),
  [
    Zwischen nichtflüchtigem Speicher und dem Gerätekontroller. Wird genutzt um
    Daten in Blöcken direkt vom Buffer des Kontrollers im Hauptspeicher
    abzulegen. Der Abschluss wird der CPU durch einen Interrupt kommuniziert.
    Es findet eine Unterbrechung pro *Block* und *NICHT* pro *Byte* statt. Die
    CPU ist nicht beteiligt.
  ],
  image("./images/io-direct_mem.png", width: 80%),
)

== Dualmode
Bietet verbesserte Security. Es wird ein *Modus-Bit* benutzt um zu
signalisieren ob der:
- Kernelmode _(0)_,
oder der
- Usermode _(1)_
verwendet wird.

*Kernelmode:*
(auch Priviledgedmode, Systemmode, Supervisormode)

Startet den Kernel, ist verantworlich für Systemaufrufe und Interrupts. Lässt
Priviligierte Anweisungen zu.

*Usermode:*
- Usercommands-/code

#figure(image("./images/io-dualmode.png", width: 80%))

== Timer
Timer werden genutzt um die Beanspruchung von Ressourcen für bestimmte Prozesse
zu begrenzen. Nach einer bestimmten Zeit wird ein Interrupt getriggert um die
Kontrolle wieder zu erlangen. Dies kann verhindern, dass zum Beispiel
Endlosschleifen die CPU Ressourcen blockieren. Dies kann durch priveligierte
Anweisungen unterbunden werden.

*Fixed Timer:* fixe Zeitspanne _(z.b. $1 / 60$ sec)_

*Variable Timer:* Clockfrequency oder Counter

= Computer Organisation
== Speicherhierarchie
#figure(image("./images/mem_hierarchy.png", width: 80%))

== Von Neumann
#grid(
  columns: (50%, 50%),
  align: (left, center),
  [
    - Bus-System
    - Memory

    Der Hauptspeicher (RAM) ist das einzige von der CPU direkt zugreifbare
    Speichermedium. Wird meist als DRAM implementiert und ist flüchtig und
    wieder beschreibbar.

    Der Sekundärspeicher wird in einzelne logische Sektoren unterteilt die vom
    Speicherkontroller dann die Interaktion mit dem Computer ermöglicht.
  ],
  image("./images/mem-von_neumann.png", width: 80%),
)

== Gemeinsame Speichersysteme
#figure(image("./images/mem-combined.png", width: 80%))

== Clustersysteme
#grid(
  columns: (50%, 50%),
  align: (left, center),
  [
    *High availability:*
    - Error tolerant
    - (A-)Synchronous Clustering
    - Load splitting

    *High performance:*
    - Parallel
    - speed
  ],
  image("./images/os-cluster.png", width: 80%),
)

== Multiprozess Programmierung und Multitasking
Mehrere Benutzer können System parallel benutzen. Dabei können
Programme(/Prozesse) gleichzeitig rechnen. Dies ist besonders nützlich bei
Planung, Warteschlangen, Prioritäten, und generellem Lastausgleich, da die
Ressourcennutzung maximiert wird. Auch bei jeglicher I/O ist eine
Multiprocessing Ansatz sinnvoll, da Anfragen _gleichzeitig_ bearbeitet werden.

_Multiprocessing_ und _Multitasking_ sind unterschiedlich, da hier auf einem 1
Benutzersystem mehrere Prozesse/Anwendung gleichzeitig laufen.

= Ressourcen Verwaltung
== Prozessverwaltung
*Prozess:*
Ist ein Programm in Ausführung und eine Arbeitseinheit in dem System. Die
Ressourcen (CPU, Memory, I/O) stehen dem Prozess zur Verfügung und werden nach
der Beendigung freigegeben.

*Betriebssystem:*
Ist verantwortlich für das erstellen, löschen und unterbrechen der Prozesse,
sowie der Zuordnung der Ressourcen. Es ist außerdem verantwortlich für die
Synchronisation und der Inter-Prozesskommunikation. Außerdem ist es
verantwortlich für die Deadlock Behebung/Behandlung.


*Singlethread Prozess:*
Anweisungen werden sequentiell ausgeführt und in einem Programmcounter wird der
jeweilig nächste Schritt/Anweisung gespeichert.

*Multithread Prozess:*
Hier hält jeder Prozess seinen eigenen Programmcounter. Die Programmierung muss
parallelisiert werden

*Andere:* Userprozesse, OS-Prozesse, usw.

== Speicherverwaltung (flüchtig)
*Inhalt:*
Die Gesamtheit bzw. Teile des Programmcodes/Maschinencodes. Nötig um das Programm
schlussendlich auszuführen. Außerdem alle weiteren Daten die das Programm
benötigt, wie z.b. heap, stack, filehandles usw.

Das Betriebssystem verfolgt die Speicherverwendung und ist zuständig für
Speicher Zuordnung und Freigabe. Außerdem ist es zuständig für die Koordination
vom Laden und Freigeben von Daten aus dem Sekundärspeicher.

== Dateisystemverwaltung (nicht flüchtig)
Daten werden häufig in Dateisystemen gespeichert. Sie bieten eine einheitliche
und logische Ansicht der Informationsspeicherung. Eine Datei ist hier eine
logische abstrakte Einheit. Die Daten des Dateisystems werden in der Regel auf
dem Sekundär- bzw. Tertiärspeicher gespeichert.

Das Betriebssystem ist zuständig für die Verwaltung und Organisation, der
Zugriffskontrolle, dem Erstellen und Löschen, dem Bearbeiten und dem Zuordnen
im nichtflüchtigen Speicher.

== Massenspeicherverwaltung
Weiterhin werden Daten oft temporär(USB-Stick) oder langfristig(Backup-Drive)
gespeichert. Dies ist entscheidend für die Geschwindigkeit des
Computerbetriebs, da mehr Daten = mehr Arbeit für das System.

Das Betriebssystem ist zuständig für das Mounten, Unmounten, Freespace
managing, Zuteilung, I/O Planung, Partitionierung und dem Schutz der
Datenträger bzw. Daten.

== Cacheverwaltung
Der Cachespeicher ist ein vorrübergehender Speicher für das Speichern bei
Datenkopien. Der Cache ist meist wesentlich kleiner als der Speicher(RAM) und
besteht aus Registern, Befehlscache und Datencache.

Die Hardware ist für die Verwaltung der Cachezeilen, Cachetreffer(Lokalität),
Cachefehler, Cachekohärenz(Multiprocessing) und der Cacheersatzrichtlinien
zuständig.

== Zusammenfassung
#figure(image("./images/mem_summary.png", width: 80%))

Die Übertragung ist in der Reihenfolge:
$
  "secondary mem" -> "main memroy(RAM)" -> "cache" -> "hardware registers"
$

== Schutz und Sicherheit
Das Betriebssystem schützt die Daten mit Zugriffskontrolle _(only specific
Users and Groups)_, Verteigung gegen Angriffe bzw. unerwünschten Zugriff.

== Virtuallisierung
_"Betriebssystem in Betriebssystem"_

Oft auch als Emulation bekannt, wenn ein anderes (Gast-)Betriebssystem in einem
(Host-)Betriebssystem genutzt wird. Nützlich um Programme auf anderen
Plattformen zu testen bzw. zu entwickeln.

== Verteilte Systeme
Systeme die durch eine Schnittstelle miteinander verbunden sind. Meistens über
TCP/IP bzw. über LAN, WAN, MAN oder PAN. Die Kommunikation findet durch
Datenaustausch statt. Hier gibt es sogenannte Netzwerkbetriebssysteme die die
Illusion eines einzigen Systems mit vielen einzelnen Computern simuliert.

*Beispiele:* Traditionell (Server, Client); Peer-To-Peer (Clients that form a
system); Cloud Computing; usw.

= Systemcalls
Systemcalls bieten eine Schnittstelle zwischen dem Programmierer und dem
Betriebssystem. Sie ermöglichen Low-Level Befehle einfach in Higher-Level
Pogrammiersprachen zu verwenden. Beispiel ist die Win32-API auf Windows oder
die POSIX-API für UNIX. Aber auch die Java-API für die Java Virtuelle Maschine.

Für die Verwendung von Systemcalls werden Register und der Stack genutzt um
Daten bzw. Parameter an den jeweiligen Aufruf zu übergeben.

Unter einem Modularen Betriebssystem werden die Systemcalls zusätzlich zum
Betriebssystem gespeichert. Somit ist die Schnittstelle Modular und kann nach
belieben angepasst werden.

== POSIX
POSIX ist eine Standartisierte Programmierschnittstelle zum Betriebssystem
UNIX. Sie folgt dem ISO/IEC/IEEE 9945 Standard. Die `libc` Bibliothek folgt dem
POSIX Standard. UNIX alleine bietet Basis Definitionen, Konventionen und
Konzepte. Sie ist die schlussendliche System-Schnittstelle mit C-Systemaufrufen
und Header-Dateien.

#grid(
  columns: (50%, 50%),
  figure(image("./images/syscall1.png", width: 90%)), figure(image("./images/syscall2.png", width: 90%)),
)

== Systemcall Arten
*Prozesssteuerung:*
Zum Prozess Erstellen, Löschen, Laden und Ausführen, Abrufen und Festlegen von
Attributen, Warte- bzw. Signalereignisse, Speicher Zuweisung und Freigabe, core
dump, Debugger und Locking für gemeinsame Daten.

*Dateiverwaltung:*
Zum Erstellen, Löschen, Öffnen und Schließen von Dateien, Lesen, Schreiben und
Bearbeiten von Daten in Dateien und das Abrufen von Dateiattributen.

*Devicemanagement:*
Zum Anfordern und Freigeben von Geräten, Lesen, Schreiben und Bearbeiten von
Geräten, Abrufen und Festlegen von Gerät Attributen, sowie das logische An- und
Abkoppeln von Geräten

Diese Unterschiedlichen Arten von Systemcalls werden verwendet um bereits
vorhandene Informationen zu nutzen bzw. festzulegen. Sie sind wichtig um den
Zugriff zu schützen und die Kommunikation zwischen Prozessen zu organisieren.

== Microkernel
#figure(image("./images/os-microkernel.png", width: 80%))

= Prozesskonzept
== Prozess
Ein Prozess ist eine Ausführbare Datei auf der Festplatte die Programmcode
und/oder Textabschnitte enthält. Die Datei wird geladen und sequenziell
ausgeführt. Hier hat der Prozess wie bereits weiter oben angesprochen einen
Programcounter, Prozessorregister, einen Stack, globale Daten wie Variablen und
einen Heap auf dem Speicher dynamisch alloziert werden kann.

== Speicherstruktur
#figure(image("./images/process-mem_structure.png", width: 80%))

== Zustand
- `new`: wird gerade erstellt
- `ready`: bereit für Zuweisung (auf Prozessor)
- `running`: Ausführen der Anweisungen
- `waiting`: warten auf Ereignis
- `finished`: Ausführung abgeschlossen

== Prozesskontrollblock
#grid(
  columns: (50%, 50%),
  align: (left, center),
  [
    - Zustand
    - Programcounter
    - CPU-Register \ (Data in process dependant registers)
    - CPU-Schedulinginformation \ (Priority, Schedulingqueue pointer)
    - Speicherverwaltungsinformationen \ (Registers, Pagetable)
    - Abbrechungsinformation \ (CPU usage, Time, Timelimits)
    - I/O Statusinformation \ (Assigned Devices, open files)

    Jeder Thread hat auch einen eigenen Kontrollblock!
  ],
  figure(image("./images/process-control_block.png", width: 40%)),
)

== Linux
#figure(image("./images/process-linux.png", width: 80%))

= Prozessplanung
Die Prozesse in der Prozessqueue werden von Prozessplaner einem CPU-Kern
zugeordnet. Dies ist sinnvoll um die CPU-Auslastung zu maximieren und Prozesse
möglichst effizient und schnell einem CPU-Kern zuzuordnen. Dabei muss die
Prozessqueue verwaltet werden und die einzelnen CPU-Kerne, sowie I/O und
Interrupts auf Bereitschaft überprüft werden. Oft gibt es verschiedenen
Warteschlangen zwischen denen gewechselt werden muss.

== Queues
#figure(image("./images/process-queue.png", width: 80%))

Prozesse die bereit sind auf der CPU ausgeführt zu werden, warten in der
Ready-Queue darauf auf der CPU ausgeführt zu werden. Ist "Platz" auf der CPU
wird ein neuer Prozess aus der Ready-Queue auf der CPU ausgeführt. Während dem
Ausführen des Prozesses kann es dazu kommen das dieser die CPU wieder verlässt.
Dies passiert hier wenn eine I/O Anfrage anfällt, der Timer des Prozesses
abgelaufen ist, ein Kindprozess erstellt werden soll oder ein Interrupt die
Ausführung unterbricht. Wenn diese Anfragen/usw. verarbeitet wurden wird der
Prozess erneut in die Ready-Queue eingefügt. Dies passiert solange bis der
Prozess fertig ausgeführt ist und anstatt erneut in die Ready-Queue zu gelangen
den Kreislauf verlässt.

== Contextswitch
#grid(
  columns: (50%, 50%),
  align: (left, center),
  [
    Bei dem Kontext handelt es sich um die CPU Register, Zustand und
    Speicherinformation welche im Prozesskontrollblock gespeichert sind. Bei
    einem Kontextswitch wird der Kontrollblock eines Prozesses gespeichert und
    der eines anderen/neuen geladen. Wie bereits oben erklärt finden _ständig_
    Contextswitches statt, hervorfgerufen durch die oben erklärten
    Anfragen/Interrupts/usw. .
  ],
  figure(image("./images/process-contextswitch.png", width: 90%)),
)

= Prozessoperationen
== Prozesserstellung
Bei der Prozesserstellung erstellt ein (jetzt Eltern-)Prozess einen
Kindprozess. Dieser hat eine Prozessid (PID bzw. pid_t (POSIX)). Es wird
festgelegt ob die Daten des Elternprozesses (teilweise) geteilt werden oder
kopiert werden. Außerdem kann festgelegt werden ob auf den Kindprozess
schlussendlich gewartet werden soll oder ob dieser von alleine schließt, bzw.
ein Daemon ist. Somit wird ein Prozessbaum erstellt. Beispiel in Linux:
#figure(image("./images/process-tree.png", width: 80%))

Die Erstellung eines Kindprozesses unter UNIX folgt folgendem Schema:
```c
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>

int main(void) {
  pid_t pid = fork();                 /* Kindprozess erstellen */
  if (pid < 0) {
    fprintf(stderr, "Fork failed.");
    return 1;
  } else if (pid == 0) {              /* Kindprozess */
    execlp("/bin/ls", "ls", NULL);
  } else {                            /* Elternprozess */
    wait(NULL);                       /* Kindsbeendigung warten */
    printf("Child completed.");
  }
  return 0;
}
```

`fork()` erstellt einen Kindprocess als Duplikat des Elternprozesses.

`exec()` läd neues Programm in dem Kindprozess. Dieses ersetzt den
Speicherplatz des Kindprozesses.

`wait()` wartet auf die Beendigung des Kindprozesses

== Prozessterminierung
Ein Prozess terminiert wenn entweder die letzte Anweisung asugeführt wird oder
`exit(int status)` im Kindprozess aufgerufen wird. `wait(int *status)` wartet
auf die Beendigung des Kindes und kann den exit status code des Kindes abrufen.
`abort()` terminiert den Kindprozess vom Elternprozess aus. Wird nicht auf die
erstellten Kindprozesse gewartet werden entweder alle nicht terminierten Kinder
vom Betriebssystem terminiert (Cascading) oder es verbleiben verwaiste
Kindprozesse. Terminiert ein Kind ohne das der Elternprozess auf diesen wartet
nennt man das Zombieprozess.

= Threads
Da viele moderne und Interaktive Anwendungen mehrere Aufgaben parallel
ausführen wurde nach einer neuen Methode gesucht um Daten parallel zu
verarbeiten. Dafür bieten sich Threads an. Diese sind lightweight und
kompatibel mit neuen Miltithread-Kernels und Multithread Prozessoren.

Die Vorteile von Threads sind verbesserte Reaktionsfähigkeit auch wenn Teile
des Prozesses Blockieren, was besonders wichtig für Grafische
Benutzeroberflächen ist. Außerdem lassen sich die Ressourcen eines CPU-Kerns
und generell die Ressourcen besser teilen, da kein automatisches Kopieren der
Daten des Prozesses stattfindet. Die Threaderstellung ist zudem wesentlich
günstiger und Contextswitches bereiten weniger Overhead, da immernoch auf dem
selben Prozessorkern gerechnet wird. Multithread Anwendungen sind zudem besser
skalierbar auf neuen Multicore Systemen.

== Single vs. Multithreaded Programme
#figure(image("./images/threads-single_multi.png", width: 80%))

== Anwendung (Server)
#figure(image("./images/threads-server.png", width: 80%))

== Concurrency vs. Parallelism
*Concurrency:*
$
  T_1 = "Task 1"; T_2 = "Task 2"; \
  T_1 -> T_2 -> T_1 -> T_2 -> T_1 -> T_2 -> ...
$

*Parrallelism:*
$
  T_1 = "Task 1"; T_2 = "Task 2"; \
  T_1 -> T_1 -> T_1 -> ... \
  T_2 -> T_2 -> T_2 -> ...
$

== Parallelism
#figure(image("./images/threads-parallelism.png", width: 80%))

== Data vs Task Parallelism
Bei der Datenparallelisierung findet die selbe Berechnung auf unterschiedlichen
Daten statt. Bei der Taskparallelisierung finden unterschiedliche Berechnungen
auf den gleichen bzw. verschiedenen Daten statt.

Bei der Datenparallelisierung wird ein Datensatz in kleinere Teilstücke
zerlegt. Diese können mit dem gleichen Code von verschiedenen Prozessen
und/oder Threads verarbeitet werden. Dies findet häufig bei Matrix
Berechnungen oder Machine Learning statt.

Bei der Taskparallelisierung werden unterschiedliche Aufgabe/Berechnungen auf
dem selben oder unterschiedlichen Daten ausgeführt. Dies ist häufig bei
komplexen Problemen mit mehreren Arbeitsschritten und ideal wenn das
Gesamtproblem in einzelne kleinere Teilprobleme zerlegt werden kann.
Betriebssysteme verwenden häufig diesen Ansatz um zum Beispiel gleichzeitig
Daten zu verarbeiten und auf der Grafischen Oberfläche anzuzeigen.

== User- und Kernelthreads
#grid(
  columns: (48%, 48%),
  gutter: 1em,
  [
    *Userthreads:* \
    Verwaltung durch Schnittstelle des Betriebssystems:
    - POSIX: pthread
    - Windows: Threads
    - Java: Threads
  ],
  [
    *Kernelthreads:* \
    Verwaltung durch den Kernel
    - Linux
    - Windows
    - MacOS
    - ...
  ],
)

#figure(image("./images/threads-user_kernel.png", width: 50%))

== Multithreading Modelle

#grid(
  columns: (48%, 48%),
  gutter: 1em,
  [
    *Many-to-One:* \
    Meherere Benutzer werden einem einzelnen Kernel-Thread zugeordnet. Das
    Blockieren eines Threads blockiert alle anderen. Dadurch ist möglicherweise
    keine Parallelisierung möglich. Dieser Ansatz wird von wenigen
    Betriebssystemen genutzt
  ],
  [
    *One-to-one:* \
    Jedem Benutzer wird ein Kernel-Thread zugeordnet. Das bietet mehr
    Parallelität bringt jedoch den Nachteil das die Anzahl der Threads pro
    Benutzer möglicher begrenzt ist. Linux und Windows benutzen diesen Ansatz.
  ],

  figure(image("./images/threads-many_one.png", width: 90%)), figure(image("./images/threads-one_one.png", width: 85%)),
  [
    *Many-to-Many:* \
    Viele Benutzer-Threads werden vielen Kernel-Threads zugeordnet. Dies
    benötigt eine ausreichende Anzahl an Kernel-Threads. Dieser Ansatz wird von
    Windows mit Thread-Fiber-Package verwendet, wird jedoch nicht häufig
    verwendet.
  ],
  [
    *2-Layers:* \
    Ähnlich wie der Many-to-Many Ansatz. Bindung von Benutzer-Threads an
    Kernel-Threads möglich, wenn in Benutzung.
  ],

  figure(image("./images/threads-many_many.png", width: 90%)),
  figure(image("./images/threads-2_layers.png", width: 90%)),
)

== PThread (POSIX Threads)
Wie bereits weiter oben angesprochen ist pthread die POSIX Schnittstelle für
Threads auf UNIX Systemen.

#figure(image("./images/threads-pthread.png", width: 80%))

== fork und exec
fork dupliziert den aufrufenden Thread bzw. den Prozess der den Thread
gestartet hat. exec ersetzt den laufenden Prozess und somit auch alle erstellen
Threads.

== Signals und Interrupts
Signale, die erzeugt durch ein bestimmtes Ereignis und an einen Prozess
übermittelt, werden vom Kernel Signalhandler bzw. einem Benutzerdefinierten
Signalhandler verarbeitet. Die Übermittlung an die Threads des Prozesses findet
entweder für alle Threads, bestimmte Threads oder einen bestimmten Thread für
alle Signale statt.

== Abbruch
Es wird zwischen Asynchronen und Verzögerten Abbrüchen unterschieden. Ein
Asynchroner Abbruch beendet den Thread sofort, wohingegen ein verzögerter
Abbruch bei bestimmten Abbruchpunkten beendet.

Für den Abbruch benutzen wir `pthread_setcancelstate(...);` und für den Typen
`pthread_setcanceltype(...);`. Mit `pthread_testcancel();` wird überprüft ob
der Thread abgebrochen werden soll. `pthread_cancel(thread_id);` bricht den
Thread mit der entsprechenden Id ab. Auch Threads die abgebrochen werden müssen
mit `pthread_join(tid, NULL);` wieder mit dem main thread bzw. dem
Elternprozess verbunden werden. Die Abbruch Typen sind Off/NULL, Deferred und
Asynchronous.

= Interprozess Kommunikation (IPC)
Die Interprozess Kommunikation wird benötigt, wenn ein Problem in mehrere
Teilprobleme zerlegt wird _(performance)_ und von mehreren Prozessen
gleichzeitig bearbeitet wird. Hier ist es nicht immer möglich die einzelnen
Aufgaben vollständig auf die einzelnen Prozesse aufzuteilen und es ist nötig Daten
zu bestimmten Zeitpunkten zwischen den arbeitenden Prozessen zu teilen um
schlussendlich das Gesamtproblem zu lösen.

Da Prozesse keinen Speicher(memory und file handles) Teilen ist meist eine
Kommunikation zwischen Prozessen notwendig, die durch das Betriebssystem
bereitgestellt wird.

Zu dem bereits angesprochenen Vorteil der schnelleren Berechnung kommt durch
das Aufteilen der Probleme auf unterschiedliche Programme/Prozesses eine
verbesserte Modularität und somit auch eine bessere Fehlertoleranz bzw.
Fehlerlokalität.

Ein _Nachteil_ der Aufteilung ist die vermehrt benötigte Synchronisation, auf
die in späteren Kapiteln eingegangen wird.

Beispiele für die Interprozesskommunikation sind:
- Dateien
- Pipes
- Shared Memory
- Signals
- Message Queues
- Sockets
- ...

== Fundamentales Model
#grid(
  columns: (50%, 50%),
  figure(image("./images/ipc-shared_mem.png", width: 90%)), figure(image("./images/ipc-message_queue.png", width: 90%)),
)

== Messagepassing
- `send()`
- `receive()`

Erstellen einer IPC und Austausch von Daten über send() und
receive(). Schlussendliches Löschen der IPC. Da die IPC mit mehreren
Prozessen geteilt werden soll muss diese entweder im Gemeinsamen Speicher
gespeichert werden, oder vor der Erstellung der Kindprozesse angelegt werden.
Das Messagepassing kann bi- bzw unidirektional sein.

*Synchronisation:*
- Synchroner Austausch: blocking sender wartet bis Nachricht empfangen wurde,
  blocking receiver wartet bis eine Nachricht verfügbar ist.
- Asynchroner Austausch: non blocking sender sendet Nachricht und setzt fort,
  non blocking receiver empfängt eine Nachricht oder auch keine Nachricht.
- Rendezvous Kommunikation: blocking sender und receiver
- Hybrid: Synchron und Asynchron

Eine einfache IPC kann mit einer Datei implementiert werden. Dies ist
jedoch extrem langsam und ineffizient. Die Synchronisation ist zudem nicht
trivial und definitiv benötigt.

== Unnamed Pipe
Unnamed Pipes werden von allen UNIX Systemen unterstützt. Sie sind
unidirektional, haben also ein Read- und ein Write-end. Die Benutzung ist
ähnlich zu den read/write Systemcalls. Daten können nur einmal gelesen werden
und können jegliche Form haben. Der Kernel ist zuständig für die nötige
Synchronisation.

Um eine Pipe zu erstellen muss der pipe Systemcall vor dem erstellen des
Kind/Arbeitsprozesses aufgerufen werden. Passiert das nicht verbindet die Pipe
zu dem gerade laufenden Prozess. Nach dem fork Aufruf sind Eltern- und
Kindprozess mit der pipe verbunden.
#figure(image("./images/ipc-unnamed_pipe.png", width: 80%))
```c
void parent(const int pipefd[2]) {
  close(pipefd[0]);                   // Close read-end

  const char* msg = "Hello World!";
  write(pipefd[1], msg, strlen(msg));
  close(pipefd[1]);                   // Close write-end
                                      // -> reader will see EOF

  wait(NULL);                         // Wait for child
}

void child(const int pipefd[2]) {
  close(pipefd[1]);                   // Close write-end
  char buf;
  while(read(pipefd[0], &buf, 1) > 0) {
    write(STDOUT_FILENO, &buf, 1);
  }
  write(STDOUT_FILENO, "\n", 1);
  close(pipefd[0]);                   // Close read-end too
}

int main(void) {
  int pipefd[2];                      // pipefd[0]: read-end
                                      // pipefd[1]: write-end
  if(pipe(pipefd) != 0) return EXIT_FAILURE;

  const pid_t cpid = fork();
  if(cpid == -1) return EXIT_FAILURE;

  if(cpid == 0) child(pipefd);
  else          parent(pipefd);
}
```

== Named Pipe (FIFO)
Named Pipes oder auch FIFO genannt werden von POSIX unterstützt und
funktionieren ähnlich zu normalen Dateien. Sie können geöffnet, geschlossen,
gelesen und beschrieben werden. Anders zu wirklichen Dateien werden die Daten
jedoch nicht auf dem Sekundärspeicher gespeichert. Sie werden vom Kernel
verwaltet. Die Daten der FIFO können nur 1 mal gelesen werden.

Im Gegensatz zu Unnamed Pipes können Named Pipes von mehreren Prozessen
geöffnet werden. Eine Kommunikation ist jedoch erst möglich wenn beide Enden
(Read/Write) geöffnet wurden. Wenn nur 1 Prozess schreibt und 1 Prozess liest
ist die Synchronisation durch den Kernel sichergestellt.

```c
void create_named_pipe_reader(void) {
  const char* name = "named_pipe";

  const mode_t permission = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH; // 644
  if(mkfifo(name, permission) != 0) return EXIT_FAILURE;

  const int fd = open(name, O_RDONLY);
  if(fd < 0) return EXIT_FAILURE;

  char buf;
  while(read(fd, &buf, 1) > 0) {
    write(STDOUT_FILENO, &buf, 1);
  }
  write(STDOUT_FILENO, "\n", 1);

  close(fd);
  unlink(name);
}

void create_named_pipe_writer(void) {
  const char* name ="named_pipe";
  const int fd = open(name, O_WRONLY);
  if(fd < 0) return EXIT_FAILURE;

  const char* msg = "Hello World";
  write(fd, msg, strlen(msg));

  close(fd);
}
```

== Messagequeue
Messageueues ermöglichen im Vergleich zu Pipes das Senden und Empfangen von
Daten mit einer festgelegten Größe. Diese Größe wird gesendet UND empfangen und
wird meist gehardcoded. Diese Pakete werden in der selben Reihenfolge empfangen
wie sie gesendet wurden.

POSIX Messagequeues erlauben zu dem senden und empfangen die mitgabe der
Priorität eines Pakets. Eine Höhere Priorität bedeutet das frühere Zustellen
beim Empfänger, wohingegen die Reihenfolge von Paketen mit der selben Priorität
erhalten bleibt.

- `mqd_t mq_open(const char *name, int oflag, mode_t mode, struct mq_attr *attr);`
Erstellt oder Öffnet eine Messagequeue. Der Name (Konvention: Start mit "/")
identifiziert die Queue aber ist nicht im Dateisystem sichtbar. Die oflag ist
zuständig für den Zugriffstypen und ob die Queue erstellt werden darf.

mode sind die Berechtigungen der Queue.

attr legt die Eigenschaften der Messagequeue fest.

```c
struct mq_attr {
  long mq_flags;      // queue flags, ignored on open
  long mq_maxmsg;     // max number of messages in the queue at any point
  long mq_msgsize;    // max size of each individual message
  long mq_curmsgs;    // number of messages in the queue
};
```

- `int mq_send(mqd_t mqdes, const char* msg_ptr, size_t msg_len, unsigned int msg_prio);`
Sendet eine Nachricht in die Messagequeue, mit den Daten msg_ptr und der Länge
von msq_size. msg_prio legt dir Priorität der Message fest.

- `ssize_t mq_receive(mqd_t mqdes, char* msg_ptr, size_t msg_len, unsigned int* msg_prio);`
Empfängt eine Nachricht aus der Messagequeue. Die Daten werden in msq_ptr mit
der Länge msq_size gespeichert. msg_prio ist die Priorität der empfangenen
Message.

```c
struct message {
  char data[32];
  bool quit;
};
typedef struct message message;

bool create_message_queue(const char* name) {
  const int oflag = O_CREAT | O_EXCL;
  const mode_t permissions = S_IRUSR | S_IWUSR; // 600
  const struct mq_attr attr = { .mq_maxmsg = 2, .mq_msgsize = sizeof(message) };
  const mqd_t mq = mq_open(name, oflag, permissions, &attr);
  if(mq == -1) return false;
  mq_close(mq);
  return true;
}

void logging_server(char **msg_queue_name) {
  const mqd_t mq = mq_open(msg_queue_name, O_RDONLY, 0, NULL);
  for(int quit_requests = 0; quit_requests < 2;) {
    usleep(100 * 1000); // Simulate logging being very slow
    message msg = { 0 };
    unsigned int priority = 0;
    if(mq_receive(mq, (char*)&msg, sizeof(msg), &priority) == -1) return;

    if(msg.quit) ++quit_requests;
    else         printf("%02u: %s\n", priority, msg.data);
  }
  mq_close(mq);
  mq_unlink(msg_queue_name);
}

void client(char **msg_queue_name, long priority) {
  const mqd_t mq = mq_open(msg_queue_name, O_WRONLY, 0, NULL);
  for(int i = 0; i < 10; ++i) {
    message msg = { .quit = false };
    sprintf(msg.data, "Hello World %d", i);
    if(mq_send(mq, (const char*)&msg, sizeof(msg), priority) != 0) return;
  }
  const message msg = { .quit = true };
  if(mq_send(mq, (const char*)&msg, sizeof(msg), priority) != 0) return;
  mq_close(mq);
}

int main(void) {
  pid_t cpid = fork();
  if(cpid == 0) {
    cpid = fork();
    if(cpid == 0) client(msg_queue_name, 0);
    else          client(msg_queue_name, 1);
  } else {
    logging_server(msg_queue_name);
  }
}
```

== Shared Memory
- `int shm_open(const char *name, int oflag, mode_t mode);`
Erstellt oder öffnet ein Shared memory Objekt spezifiziert durch den Namen
(Konvention: Start mit "/"). Dieses ist wie bei der Messagequeue nicht im
Dateisystem zu finden. Wichtig ist hier das kein Speicher wirklich alloziert
wird!

- `int ftruncate(int fd, off_t length);`
Begrenzt (oder erweitert) eine Datei auf die spezifizierte Größe. Hier ist
wichtig das ftruncate nur auf allozierte Speicherbereiche angewendet werden
darf.

- `void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);`
Dieser Befehl mapped Dateien oder Geräte in den Prozessspeicher. mmap wird
benötigt um das shared_mem Objekt in den wirklichen Speicher zu legen. addr =
NULL lässt den Kernel entscheiden wo genau das Memory Objekt alloziert/gemapped
werden soll. length beschreibt die Größe des shared_mem Objekts. prot legt die
Berechtigungen für den Speicherbereich fest. flags sollte bei shared_mem =
MAP_SHARED. fd ist der Filedescriptor für das shared_mem Objekt. offset
spezifiziert ob das Speicherobjekt mit einem gewissen offset gemapped werden
soll. Bei einem fehlgeschlagenen Mapping wird MAP_FAILED zurückgegeben, sonst
ein allozierter Speicherbereich.

#figure(image("./images/shm-timeline.png", width: 80%))

```c
void writer(void) {
  const char* name = "/shared_memory";
  const int oflag = O_CREAT | O_EXCL | O_RDWR; // create, fail if exists, read+write
  const mode_t permission = S_IRUSR | S_IWUSR; // 600
  const int fd = shm_open(name, oflag, permission);
  if(fd < 0) return EXIT_FAILURE;

  const size_t shared_mem_size = 100;
  if(ftruncate(fd, shared_mem_size) != 0) return EXIT_FAILURE;

  char* shared_mem = mmap(NULL, shared_mem_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if(shared_mem == MAP_FAILED) return EXIT_FAILURE;

  const char message[] = "Hello World";
  memcpy(shared_mem, message, sizeof(message));

  usleep(10 * 1000 * 1000);

  munmap(shared_mem, shared_mem_size);
  close(fd);
  shm_unlink(name);
}

void reader(void) {
  const char* name = "/shared_memory";
  const int oflag = O_RDWR; // open read+write
  const int fd = shm_open(name, oflag, 0);
  if(fd < 0) return EXIT_FAILURE;

  const size_t shared_mem_size = 100;
  char* shared_mem = mmap(NULL, shared_mem_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

  if(shared_mem == MAP_FAILED) return EXIT_FAILURE;

  char buffer[shared_mem_size];
  memcpy(buffer, shared_mem, shared_mem_size);

  munmap(shared_mem, shared_mem_size);
  close(fd);

  printf("%.*s\n", (int)shared_mem_size, buffer);
}
```

Beim Shared Memory stellt sich nun jedoch ein Problem. Wann weiß das Lesende
Ende wann Daten verfügbar sind? Was passiert wenn gleichzeitig gelesen *und*
geschrieben wird? Was ist wenn das Lesende Ende Daten zurücksenden will?

Hier wird eine Art von Synchronisation benötigt. Der usleep call ist nicht
ausreichend.

= Synchronisation
Wir benötigen Synchronisation, da Prozesse und Threads gleichzeitig Daten
verarbeiten. Wenn nun mehrere Prozesse wieder gleichzeitig auf die selben Daten
zugreifen kann es zu Fehlern kommen. Diese Fehler werden *race conditions*
genannt.

#figure(image("./images/sync-race_condition.png", width: 80%))

Oder in Code:
```c
#define ITERATIONS 100000000
#define THREADS 2
int x = 0;
void* thread(void* param) {
  for(int i = 0; i < ITERATIONS; ++i) {
    ++x;
  }
  return NULL;
}
int main(void) {
  /* spawn THREADS number of threads and wait until they finish */
  printf("x: %d", x);
}
```

== Data Hazards
- *Read-after-Write* (RAW): true dependency
```c
1) x = 4;
2) y = x + 7;
3) x = 2;
```
y hängt vom Wert der Variable x ab. 1 und 2 haben eine true dependency. Wird
Zeile 1 und 2 getauscht ist der Output ein anderer.

- *Write-after-Read* (WAR): anti dependency
```c
1) x = 4;
2) y = x + 7;
3) x = 2;
```
y hängt vom Wert der Variable von x ab. x wird später verändert. Wenn nun Zeile
2 und 3 getauscht werden ist der Output ein anderer.

- *Write-after-Write* (WAW): output dependency
```c
1) x = 4;
2) y = x + 7;
3) x = 2;
```
y hängt vom Wert der Variable von x ab. x wird in Zeile 1 und 3 verändert. Wenn
nun Zeile 1 und 3 getauscht werden ist der Output ein anderer.

== Critical Sections
In dem oben gezeigten Code Abschnitt ist `++x` die Critical section. Jede
Critical Section benötigt eine Synchronisation bei einer parallelen Ausführung.

== Atomics
Atomics sind der Grundstein für die Synchronisation. Sie benötigten Hardware
support und können dementsprechend entweder komplett funktionieren oder gar
nicht. Mit Atomics können wir die oben angesprochenen Probleme vollständig
lösen.

`<stdatomic.h>` stellt primitive Datentypen wie atomic_bool oder atomic_int zur
Verfügung. Benutzerdefinierte Typen können mit \_Atomic deklariert werden und
sind demnach Atomic. Wird \_Atomic verwendet müssen die Atomic API Funktionen
verwendet werden.

Das oben gegebene Beispiel kann durch die Benutzung eines `atomic_int` als
Datentyp für x Synchronisiert werden, da der parallele Zugriff auf Atomics
sicher ist.

== Atomic Operationen
#figure(image("./images/atomic-operations.png", width: 80%))

== Shared Memory mit Synchronisation
```c
struct shared_data {
  atomic_bool available;
  atomic_bool processed;
  size_t cnt;
  char buf[1024];
};
typedef struct shared_data shared_data;
```

Dieses Konstrukt stehen dem Schreibenden *und* dem Lesenden Ende zur Verfügung.
Der Server:
```c
/* shared memory creation and mapping, same as before */
data->processed = true; // Indicate initialization is done
while(!data->available); // Busy wait for data to become available
// Process data
for(size_t i = 0; i < data->cnt; ++i) {
data->buf[i] = toupper((unsigned char)data->buf[i]);
}
// Signal data has been processed
data->processed = true;
munmap(data, sizeof(shared_data));
close(fd);
shm_unlink(shared_mem_name);
```

Der Client:
```c
/* shared memory creation and mapping, same as before */
while(!data->processed); // Busy wait until shared memory has been initialized
data->processed = false; // Reset flag
// Write data
data->cnt = strlen(message);
memcpy(&data->buf, message, data->cnt);
// Signal data has been written
data->available = true;
while(!data->processed); // Busy wait until data has been processed
printf("%.*s\n", (int)data->cnt, data->buf);
munmap(data, sizeof(shared_data));
close(fd);
```

== Mutex
Mutex (von #text("Mu", weight: 800)tual #text("Ex", weight: 800)clusion), auch
genannt Locks können 2 States halten:
- Locked/held/owned/acquired
- Unlocked/free/released.

Ein Mutex kann immer nur von *einem* Thread gehalten/gelocked sein. Jeder
weitere Thread der versucht den Mutex zu halten wartet bis dieser erneut
freigegeben wird. Die Nutzung eines Mutex bringt jedoch einen großen
Performance Verlust mit sich, weshalb die Critical Section klein gehalten
werden sollte.

Mutexes werden meist durch eine Binäre Semaphore dargestellt (siehe
@semaphores[Semaphores]).

Das obige Problem, zuerst gelöst durch die Verwendung von Atomics kann auch mit
der Verwendung eines Mutex gelöst werden:
```c
pthread_mutex_t mutex;
int x = 0;
void* thread(void* param) {
  for(int i = 0; i < ITERATIONS; ++i) {
    pthread_mutex_lock(&mutex);
    ++x;
    pthread_mutex_unlock(&mutex);
  }
  return NULL;
}
```

- `int pthread_mutex_init(pthread_mutex_t* mutex, const pthread_mutexattr_t* mutexattr);`
oder
- `pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;`
erstellt den Mutex mit den spezfizierten mutexattr bzw. einen default Mutex
wenn mutexattr = NULL.

- `int pthread_mutex_lock(pthread_mutex_t* mutex);`
versucht den Mutex zu locken. Ist dieser nicht gelocked, locked der aufrufende
Thread den Mutex sofort. Sonst blockt der Thread so lange bis der Mutex
unlocked ist.

- `int pthread_mutex_trylock(pthread_mutex_t* mutex);`
versucht den Mutex zu locken. Ist dieser nich gelocked, locked der aufrufende
Thread den Mutex sofort. Sonst wird der error code EBUSY zurückgegeben.

Das Locken des Mutex darf im Thread nur einmal passieren.

- `int pthread_mutex_unlock(pthread_mutex_t* mutex);`
unlocked den Mutex. Der Mutex muss zuvor von den Thread gelocked worden sein.

- `int pthread_mutex_destroy(pthread_mutex_t* mutex);`
zerstört den Mutex nach der Benutzung. Der Mutex darf zu diesem Zeitpunkt nicht
mehr gehalten werden.

== Dekker's Algorithmus
_(1960er)_

Hardware support für Mutexes hat es noch nicht immer gegeben und der Dekker
Algrotihmus war die erste korrekte Lösung für das Mutex Problem. Der Dekker
Algorithmus ist in Software implementiert, ohne jeglichen Hardware support.
Dieser arbeitet auf dem Gemeinsamen Speicher. Auf neuen Systemen nicht
funktionsfähig und nicht möglich rein in C zu lösen, da der Compiler und die
CPU heutzutage in der Lage sind Instruktionen umzustellen wenn der Code nicht
synchronisiert ist. Dies verhindert das Benutzen des Dekker Algorithmus.

*Dekker Algorithmus in Pesudocode:*
```
variables:
  wants_to_enter: array of 2 booleans
  turn: integer
  wants_to_enter[0] ← false
  wants_to_enter[1] ← false
  turn ← 0 // or 1

p0:
  wants_to_enter[0] ← true
  while wants_to_enter[1] {
    wants_to_enter[0] ← false
    while turn != 0 // busy wait
    wants_to_enter[0] ← true
  }
  // critical section
  turn ← 1
  wants_to_enter[0] ← false
  // remainder section

p1:
  wants_to_enter[1] ← true
  while wants_to_enter[0] {
    wants_to_enter[1] ← false
    while turn != 1 // busy wait
    wants_to_enter[1] ← true
  }
  // critical section
  turn ← 0
  wants_to_enter[1] ← false
  // remainder section
```

== Peterson's Algorithmus
_(1981)_

Der Peterson's Algorithmus ist wie der Dekker Algorithmus eine Software Lösung
für das Mutex Problem. Der Peterson's Algorithmus wird als besser angesehen, da
er einfacher zu implementieren ist, weniger Anweisungen und eine klarere Logik
besitzt und besser für formale Beweise geeignet ist.

*Peterson's Algorithmus in Pseudocode:*
```
variables:
  flag: array of 2 booleans
  turn: integer
  flag[0] ← false
  flag[1] ← false

p0:
  flag[0] ← true
  turn ← 1
  while (flag[1] && turn == 1)
  // critical section
  flag[0] ← false
  // remainder section

p1:
  flag[1] ← true
  turn ← 0
  while (flag[0] && turn == 0)
  // critical section
  flag[1] ← false
  // remainder section
```

Wie auch bereits beim Dekker Algorithmus angesprochen ist das benutzen dieses
Algorithmus heutzutage nicht mehr möglich, wegen Compiler und CPU Instruction
reordering.

== Memorybarrier
Heutige CPUs optimieren die Ausführung stark. Um schneller zu arbeiten werden
häufig Befehl umgeordnet und verzögern Speicheroperationen. In
Multi-Core-Systemen können dadurch Speicheränderungen nicht sofort für andere
Threads sichtbar sein. Selbst bei korrektem Code, wie die beiden oben
angesprochenen Algorithmus, kann es zu race conditions kommen.

Wir Unterscheiden zwischen:
- stark geordnetem Speicher (Änderungen sind sofort für alle Prozessoren
  sichtbar)
und
- schwach geordnetem Speicher (Änderungen sind nicht sofort sichtbar. Probleme
  bei der Parallelität).
\
#align(center)[
  ```
  Thread 1                 | Thread 2
  -------------------------|--------------------------
  while(!flag)             | turn = 1;
  memory_barrier()         | memory_barrier();
  print turn;              | flag = true;
  ```
] \

Hier benutzen wir eine Speicherbarriere auf schwach geordneten Speicher
Systemen um sicherzustellen, dass das Speichern in der richtigen Reihenfolge
stattfindet. Ohne Barriere könnte die CPU die Instruktionen umordnen und es
kommt zu einer race condition.


== Deadlocks
2 Thread halten bzw. geben 2 Mutexes frei. Dies geschieht in entgegengesetzter
Reihenfolge. Dies kann nicht funktionieren da nun beide Threads auf die
Freigabe des jeweilig anderen Mutex wartet, diese aber erst freigegeben
werden, wenn einer der beiden Mutexes freigegeben wird. Dies ist in sich ein
Widerspruch und somit unmöglich.

*Beispiel in C:*
#grid(
  columns: (50%, 50%),
  gutter: 1em,
  [
    p0:
    ```c
    for(int i = 0; i < ITERATIONS; ++i) {
      pthread_mutex_lock(&mutexes[0]);
      // hält hier
      // nächstes locking unmöglich
      pthread_mutex_lock(&mutexes[1]);

      pthread_mutex_unlock(&mutexes[1]);
      pthread_mutex_unlock(&mutexes[0]);
    }
    ```
  ],
  [
    p1:
    ```c
    for(int i = 0; i < ITERATIONS; ++i) {
      pthread_mutex_lock(&mutexes[1]);
      // und hier (gleichzeitig)
      // nächstes locking unmöglich
      pthread_mutex_lock(&mutexes[0]);

      pthread_mutex_unlock(&mutexes[0]);
      pthread_mutex_unlock(&mutexes[1]);
    }
    ```
  ],
)

Eine weitere Art von Deadlock ist das Zirkuläre Warten. Dies geschieht wenn
eine begrenzte Anzahl an Threads auf das Lock des jeweilig nächsten wartet und
sich dadurch ein Zyklus bildet. Es ist unmöglich für einen der Threads fort zu
fahren. Dieses Problem gleicht dem Dining Philosophers Problem.

*Deadlock Prävention:*
- Hold and Wait: Alle Ressourcen am Anfang anfordern und erst am Schluss wieder
  freigeben. Insgesamt jedoch eine geringe Ressourcennutzung.
- No preemption: Freigeben aller Ressourcen wenn benötigte Ressourcen nicht
  angefordert werden können. Ausführung fortfahren wenn alle benötigten
  Ressourcen angefordert werden können.
- Circular Waiting: Ressourcen in aufsteigender Reihenfolge anfordern.

Hier verweise ich erneut auf die Folien von Herr Radush _(Foliensatz 5, Folien
51 bis 56)_, da ich keine Ahnung habe was wirklich passiert!

== Bankieralgorithmus
Wir haben $n$ Threads und $m$ Ressourcentypen:
- einen Ressource-Availibility Vector: $"avail"_m$
- eine Max-Acquire Matrix: $"max"_(n m)$
- eine Ressource-Map Matrix: $"alloc"_(n m)$
- eine Ressources-Needed Matrix: $"need"_(n m)$

*Safety Algorithm:* \
```
Input:  n, m, avail[n][m], alloc[n][m], need[n][m]
Output: True/False (safe or unsafe)

finish[1..n] = false

i = 1
while i <= n && finish[i] == false && need[i] <= avail:
  finish[i] = true
  avail = avail + alloc[i]

return finish[1] && ... && finish[n]
```
$=> cal(O)(n^2 dot m)$

*Ressourcesneeded Algorithm:*
```
Input:  n, m, avail[n][m], alloc[n][m], need[n][m], req[i] // resources need by Thread T[i]
Output: True/False (safe or unsafe)

if req[i] <= need[i]
  error: needs too many Ressources

if req[i] > avail:
  wait(T[i])
else:
  avail = avail - req[i]
  alloc[i] = alloc[i] + req[i]
  need[i] = need[i] - req[i]
  if !safe(n, m, avail, alloc, need):
    avail = avail + req[i]
    alloc[i] = alloc[i] - req[i]
    need[i] = need[i] + req[i]
```

*Beispiel:*
#grid(columns: (50%, 50%), 
  [
    - Sichere Threadreihenfolge:
    $
    {T_1, T_3, T_4, T_2, T_0}
    $
    - $"Req"_1$ = (1, 0, 2) < (3, 3, 2) = Avail
      - Avail = (3, 3, 2) - (1, 0, 2) = (2, 3, 0)
      - $"Alloc"_1$ = (3, 0, 2), $"Need"_1$ = (0, 2, 0)
    - Sichere Threadreihenfolge:
    $
    {T_1, T_3, T_4, T_0, T_2}
    $
    - $"Req"_4$ = (3, 3, 0) > (2, 3, 0) = Avail
      - Anforderung größer als Available
    - $"Req"_0$ = (0, 3, 0) < (2, 3, 0) = Avail
      - $"Need"_0$ = (7, 1, 3), $"Alloc"_0$ = (0, 4, 0)
      - Unmöglich da unsicherer Zustand
  ],
  figure(image("./images/sync-bankier_algorithm.png", width: 70%))
)

== Deadlock Detection
Immer nur eine Instanz pro Ressourcentyp. Darstellung durch einen
Resourcenzuteilungsgraph, einem Wartegraph und einem
Zykluserkennungsalgorithmus.

*Cycledetection Algorithm:*
```
Input:  n, m, avail[n][m], alloc[n][m], req[n][m]
Output: True/False (safe or unsafe)

finish[i] = alloc[i] != 0 ? False : True; i = {1..n}

i = 0
while i <= n && finish[i] = False && req[i] <= avail
  finish[i] = True
  avail = avail + alloc[i]

return finish[1] && ... && finish[n]
```
$=> cal(O)(n^2 dot m)$

*Beispiel:*
#grid(columns: (50%, 50%), 
  [
    #v(0.5cm)
    - Sicherer Zustand: #h(4cm) $=>$
      - Kein Deadlock
    $
    {T_0, T_2, T_3, T_1, T_4}
    $
    #v(4cm)
    - Unsicherer Zustand: #h(3.5cm) $=>$
      - Deadlock
    $
    {T_0, ...}
    $
    
    
  ],
  figure(image("./images/sync-deadlock_detection.png", width: 70%))
)

== Deadlock Behebung
Um einen Deadlock zu beheben können entweder alle Threads die in dem Deadlock
gefangen sind gleichzeitig oder nacheinander terminiert werden. Beim
sequenziellen Terminieren wird nach jeder Terminierung überprüft ob das System
nun Deadlock frei ist. Die Reihenfolge der Terminierung kann von
Threadpriorität, Berechnungszeit und weiteren Faktoren abhängen. 

Eine weitere Möglichkeit ist die Präemption von Ressourcen. Hierbei werden
Ressourcen die in einem Deadlock gefangen sind Ressourcen entzogen, bzw.
einzelne Threads gezielt terminiert. 

Außerdem können Threads auf einen früheren Zustand zurückgesetzt bzw. neu
gestartet werden.

== Livelocks
```c
void* thread(void* param) {
  ThreadData* data = param;
  for(int i = 0; i < ITERATIONS; ++i) {
    if(!trylock_all_mutexes(data)) continue;
    ++data->work_done;
    unlock_all_mutexes(data);
  }
  return NULL;
}
```

N Threads versuchen N mutexes zu locken um eine bestimmte Aufgabe zu lösen.
Dies ist ähnlich zu einen Deadlock. Die Ausführung des Programms stoppt nicht.
Die CPU verbraucht jedoch Ressourcen ohne wirkliche Arbeit zu leisten.

*Effizienz:*
#figure(image("./images/sync-livelocks_efficiency.png", width: 80%))

Effizienz wird als Arbeit definiert die wirklich geschafft wird. Nicht als
Versuche Arbeit zu leisten. Wenn hier nun die Anzahl der Threads und somit die
Anzahl der Mutexes steigt, nimmt die Effizienz drastisch ab. Durch das
zurückziehen finden keinen wirklichen Deadlocks statt.

== Condition Variables
Condition Variables werden genutzt um zu warten/blockieren bis eine bestimme
Kondition wahr wird. Sie können ein Signal erhalten durch das signalisiert wird
das eine Bestimmte Kondition erfüllt ist. Die meisten praktischen Anwendung
haben aber sogannente _spurious wakeups_. Das bedeutet das die Condition
Variable ein Signal bekommt ohne das die Kondition wirklich erfüllt ist. Diese
müssen explizit behandelt werden.

- `int pthread_cond_init(pthread_cond_t* cond, pthread_condattr_t* cond_attr);`
initialisiert die Condition Variable, die durch den pointer gegebn wird.
cond_attr spezifiziert die Attribute der Condition Variable.

- `int pthread_cond_destroy(pthread_cond_t* cond);`
zerstört die Condition Variable.

- `int pthread_cond_wait(pthread_cond_t* cond, pthread_mutex_t* mutex);`
jede Condition Variable muss mit einem Mutex genutzt werden. Der oben genannte
Befehl muss auf einen bereits gehaltenen Mutex folgen. Der Aufruf überprüft ob
die Condition Variable ein Signal erhält. Ist dies nicht der Fall bzw. ein
_spurious wakeup_-call findet statt, wird der Mutex freigegeben und der Aufruf
blockiert die Ausführung. Bekommt die Condition Variable ein Signal werden die
folgenden Anweisungen ganz normal ausgeführt. Beim zurückkehren des Aufrufs ist
der Mutex entweder immer noch gelocked(Signal erhalten) oder wird
ge-relocked(Blockieren und dann erst Signal).

Um _spurious wakeups_ zu behandeln wird die Kondition nach dem zurückkehren der
Funktion erneut überprüft. Dafür wird meistens eine while-Schleife verwendet.
Dies bringt den Vorteil, dass bei einer erfüllten Kondition der Aufruf gar
nicht erst stattfindet. Ein einfaches Beispiel ist:
```c
pthread_mutex_lock(&mutex);
  while(!condition) {
  pthread_cond_wait(&cond, &mutex);
}
// Critical section
pthread_mutex_unlock(&mutex);
```

- `int pthread_cond_signal(pthread_cond_t* cond);`
signalisiert genau einem Thread das die Kondition erfüllt ist. Dieser verlässt
nun den pthread_cond_wait Aufruf. Warten keine Threads passiert nichts. Warten
mehrere Threads verlässt ein unspezifizierter Thread den pthread_cond_wait Aufruf.

- `int pthread_cond_broadcast(pthread_cond_t *cond);`
signalisiert allen wartenden Threads, und veranlasst diese den
pthread_cond_wait Aufruf zu verlassen. Da die Threads durch einen Mutex blocken
folgt dies keiner spezifizierten Reihenfolge und die Threads verlassen
nacheinander den Aufruf.

*Beispiel:* \
*client:*
```c
pthread_mutex_lock(&data->mtx);               // Aquire mutex
data->cnt = strlen(message);                  // Write
memcpy(&data->buf, message, data->cnt);       // message
data->available = true;                       // Set condition
pthread_mutex_unlock(&data->mtx);             // Release mutex
pthread_cond_signal(&data->cond);             // Signal condition variable

pthread_mutex_lock(&data->mtx);               // Aquire mutex
while(!data->processed) {                     // Wait until condition
pthread_cond_wait(&data->cond, &data->mtx);   // Release mutex and wait
}                                             // Mutex will be re-aquired
printf("%.*s\n", (int)data->cnt, data->buf);  // Print
pthread_mutex_unlock(&data->mtx);             // Release mutex
```

*server:*
```c
pthread_mutex_lock(&data->mtx);                       // Aquire mutex
while(!data->available) {                             // Wait until condition
pthread_cond_wait(&data->cond, &data->mtx);           // Release mutex and wait
}                                                     // Mutex will be re-aquired
for(size_t i = 0; i < data->cnt; ++i) {               // Process
data->buf[i] = toupper((unsigned char)data->buf[i]);  // the
}                                                     // data
data->processed = true;                               // Set condition
pthread_mutex_unlock(&data->mtx);                     // Release mutex
pthread_cond_signal(&data->cond);                     // Signal condition variable
```

== Semaphores <semaphores>
Semaphores sind ähnlich zu Mutexes. Semaphoren sind im gröbsten Sinne ein
Zähler. Dieser Zähler startet meistens bei 0 und zeigt meistens an, ob
Ressourcen verfügbar sind. Sie ermöglichen 2 Operationen.
- post/release: welches den Zähler um 1 erhöht und die Semaphore semantisch
  unlocked,
und
- wait/acquire: welches den Zählen um 1 verringert und die Semaphore sematisch
  locked.

Das Verringern ist nur möglich wenn der Zähler $> 0$ ist. Eine Semaphore die zu
jedem Zeitpunkt den Wert 0 bzw. 1 hält wird auch Binäre Semaphore genannt bzw.
Mutex genannt.

- `int sem_init(sem_t* sem, int pshared, unsigned int value);`
initialisiert die Semaphore. Wenn pshared $=$ 0 wird die Semaphore zwischen
Threads geteilt. Ist pshared $!=$ 0 dann wird die Semaphore zwischen Prozessen
geteilt. Die Semaphore muss beim teilen mit Prozessen im Shared memory liegen.
Das initialisieren muss nur einmal und nicht pro Thread/Prozess erfolgen. Value
gibt den Startwert der Semaphore an.

- `int sem_destroy(sem_t* sem);`
zerstört die Semaphore. Muss nur einmal und nicht pro Thread/Prozess erfolgen.

- `int sem_wait(sem_t* sem);`
verringert den Wert der Semaphore. Ist der Wert der Semaphore 0, blockiert der
Aufruf bis ein anderer Thread die Semaphore erhöht.

- `int sem_post(sem_t* sem);`
erhöht den Wert der Semaphore. War der Wert der Semaphore 0, wird ein
blockender sem_wait call entblocked.

== Ring Buffer
Ein Ring Buffer wird verwedet um eine Queue zu implementieren. Er hat ein
read-end(tail) und ein write-end(head). Wenn head $=$ tail ist der Ring Buffer
leer. Wenn $("head" + 1) mod N = "tail"$ ist der Ring Buffer voll. Die
Kapazität des Ring Buffers ist $N - 1$, da sonst "leer" und "voll" nicht klar
definiert wäre.

#figure(image("./images/sync-ring_buffer.png", width: 50%))

```c
struct RingBuffer {
  int head;
  int tail;
  Data data[BUFFER_SIZE];
};
typedef struct RingBuffer RingBuffer;

void ring_buffer_init(RingBuffer* buf) {
  buf->head = 0;
  buf->tail = 0;
}

bool ring_buffer_is_full(RingBuffer* buf) {
  return ((buf->head + 1) % BUFFER_SIZE) == buf->tail;
}

bool ring_buffer_is_empty(RingBuffer* buf) {
  return buf->head == buf->tail;
}

bool ring_buffer_push(RingBuffer* buf, const Data* data) {
  if(ring_buffer_is_full(buf)) return false;
  buf->data[buf->head] = *data;
  buf->head = (buf->head + 1) % BUFFER_SIZE;
  return true;
}

bool ring_buffer_pop(RingBuffer* buf, Data* data) {
  if(ring_buffer_is_empty(buf)) return false;
    *data = buf->data[buf->tail];
    buf->tail = (buf->tail + 1) % BUFFER_SIZE;
    return true;
  }
}
```

== Producer - Consumer Problem
#figure(image("./images/sync-producer_consumer.png", width: 80%))

Das Producer-Consumer Problem ist ein klassisches Problem in der Informatik.
Der Producer und die Consumer sibd Threads bzw. Prozesse, die parallel
arbeiten. Der Producer erzeugt ununterbrochen Daten und speichert diese in dem
Ringbuffer. Die Consumer nehmen sich daten aus dem Ring Buffer und verarbeiten
diese. Auf die Frage "Wird hier Synchronisation benötigt" stellen wir uns ein
Beispiel eines Buffets vor.

Auf diesem Buffet wird ständig neues Essen gekocht und gegessen. Der Koch fügt
neues Essen hinzu wenn Platz auf dem Buffet ist bzw. die Gesamtanzahl der
benötigten Essen noch nicht erschöpft ist. Jedoch ist diese Gesamtanzahl viel
größer als Platz auf dem Buffet ist. Die Consumer bzw. Gäste essen, solange
Essen auf dem Buffet ist bzw. die Gesamtanzahl der Essen konsumiert wurde. Wenn
das Buffet leer ist wartet der Consumer auf das nächste Gericht.

Ohne Synchronisation greifen mehrere Gäste gleichzeitig auf das Buffet zu.
Dabei können sie sich in die Quere kommen. Am Beispiel: Es befindet sich ein
Essen auf dem Buffet. 2 oder mehr Gäste sehen dieses essen und konsumieren dies
(virtuell) gleichzeitig. Entweder die Gäste konsumieren essen das eigentlich
gar nicht da ist, oder sie _greifen_ sich ein Essen das schon nicht mehr
vorhanden ist. In beiden Fällen findet eine *race condition* statt bzw.
potentiell ein Error statt.

Das Code Beispiel zu diesem Problem kann im _Foliensatz 4, Folien 37-40_
nachvollzogen werden.

Um das Problem zu beheben verwenden wir 2 Semaphoren, die Anzeigen wie viel
freier Platz auf dem Buffet ist, und wie viele Essen sich auf dem Buffet
befinden. Zudem benötigen wir einen Mutex der den Zugriff auf das Buffet
schützt und einen Atomic Boolean der den Consumern anzeigt ob diese Stoppen
sollen.

== Dining Philosophers Problem
#figure(image("./images/sync-dining_philosophers.png", width: 50%))

An einem Tisch befinden sich $N$ Philosophen. Jeder Philosoph hat eine Portion
Spaghetti vor sich. Auf dem Tisch befinden sich zudem $N-1$ Essstäbchen. Ein
Philosoph wechselt immer von Denken zu Essen. Um zu essen muss jeder Philosoph
die 2 Essstäbchen neben seinen Spaghetti aufheben. Das Aufheben kann durch
einen Mutex für jedes Essstäbchen synchronisiert werden.


#grid(
  columns: (50%, 50%),
  gutter: 1em,
  [
    Dies kann jedoch einfach zu einem Deadlock führen, wenn alle Philosophen
    gleichzeitig zum Beispiel das Stäbchen rechts seines Essens aufhebt. Nun
    ist für keinen der Philosophen mehr möglich ein weiteres Stäbchen
    aufzuheben und seine Spaghetti zu essen. Wir befinden uns in einem
    Deadlock!
  ],
  figure(image("./images/sync-dining_philosophers_deadlock.png", width: 70%)),
)

*Lösungsansätze:*
- *Centralized Locking:*
Es wird eine zentraler Mutex verwendet um die Kontrolle der Esstäbchen zu
schützen. Jeder Philosoph kann den Mutex halten und versuchen die beiden
Stäbchen links und rechts aufzuheben. Gelingt dies werden die Stäbchen
aufgehoben und der Mutex wird freigegeben. Gelingt dies nicht werden die
Stäbchen zurückgelegt und es wird zu einem späteren Zeitpunkt erneut versucht.
Durch das warten kann es jedoch zu einem Livelock kommen und manche Philosophen
essen nie und Verhungern.

- *Ordering:*
#grid(
  columns: (50%, 50%),
  gutter: 1em,
  [
    Die Stäbchen bekommen eine Reihenfolge. Jeder Philosoph hebt erst das
    Stäbchen mit der niedrigeren ID auf. Hier kommt es jedoch dazu, dass manche
    Philosophen häufiger essen als ander. In dem Beispiel isst Philosoph
    häufiger als andere.
  ],
  figure(image("./images/sync-dining_philosophers_ordering.png", width: 70%)),
)

== Barriers
Barriers synchronisieren alle partizipierenden Threads, indem sie die
Ausführungen solange blockieren bis alle Threads an der Barriere angelangt
sind.

#figure(image("./images/sync-barriers.png", width: 50%))

- `int pthread_barrier_init(pthread_barrier_t* barrier,
                            const pthread_barrierattr_t* attr,
                            unsigned count);`
initialisiert die Barrier mit den spezifizierten Attributen und dem count als
Anzahl der partizipierenden Threads.

- `int pthread_barrier_destroy(pthread_barrier_t* barrier);`
zerstört die Barrier.

- `int pthread_barrier_wait(pthread_barrier_t* barrier);`
das Ankommen an der Barrier wird auch warten gennant. Der Aufruf blockt solange
bis alle Threads an der Barriere angekommen sind. Ein unspezifizierte Thread
gibt den Wert `PTHREAD_BARRIER_SERIAL_THREAD` zurück. Dies kann benutzt werden
um bestimmte Logik pro Barrier auszuführen bzw. pro Loop/Step.

*Beispiel:*
```c
void* thread(void* arg) {
  ThreadData* thread_data = arg;
  SharedData* data = thread_data->data;
  for(int t = 0; t < NUM_TIMESTEPS; ++t) {
    compute(thread_data);
    if(pthread_barrier_wait(&data->barrier) == PTHREAD_BARRIER_SERIAL_THREAD) {
      swap_buffers(data);
    }
    pthread_barrier_wait(&data->barrier);
  }
  return NULL;
}
```

== Interrupt-based Synchronisation
Generelles Vorgehen:
+ Eintritt in Critical Section: Deaktivieren der Interrupts
+ Ausführen der Critical Section
+ Austritt aus Critical Section: Reaktivieren der Interrupts

Auf Single-Core-Systemen äußerst effizient und einfach zu Implementieren. Sie
garantiert den exklusiven Zugriff in einer Critical-Section. Auf
Multi-Core-Systemen ungeeignet, da das De-/Aktivieren der Interrupts *aller*
CPU's und das sperren des Systembus extrem teuer ist.

= Synchronisation (Hardware)
Bei Single-Core-Systemen verwenden wir den Interrupt-based Synchronisation
Ansatz.

Auf Multi-Core-Systemen verwenden wir Hardwareanweisungen, wie:
- `test_and_set`
- `compare_and_swap`
und atomare Variablen und Funktionen. Somit haben wir eine Synchronisation
durch die Hardware.

- *test_and_set*
```c
atomic_bool test_and_set(atomic_bool *lock) {
  atomic_bool old = *lock;
  *lock = true;
  return old
}
```
Beispielnutzung:
```c
atomic_bool lock = false;

do {
  // spinlock / busy waiting
  while (test_and_set(&lock));

  // critical section

  lock = false;
  // remainder section

} while (true)
```

- *compare_and_swap*
```c
atomic_int compare_and_swap(atomic_int *val,
                            int expected, int new_val) {
  temp = *val;
  if(*val == expected)
  *val = new_val;
  return temp;
}
```
Beispielnutzung:
```c
atomic_int lock = 0;

do {
  // spinlock / busy waiting
  while (compare_and_swap(&lock), 0, 1) == 1;

  // critical section

  lock = 0;
  // remainder section

} while (true)
```

- *begrenztes warten mit compare_and_swap*
```c
atomic_bool wait[N] = { false };
atomic_int lock = 0;

// Prozess i
do {
  wait[i] = true; // wait[i] = true; Prozess i wartet auf
                  // kritischen Bereich

  // spinlock / busy waiting
  while (wait[i] && compare_and_swap(&lock), 0, 1) == 1;
  wait[i] = false;

  // critical section

  j = (i + 1) % N;
  while((j != i) && !wait[j])
    j = (j + 1) % N;

  if(j == i) lock = 0;  // release
  else wait[j] = false; // transfer lock
  // remainder section

} while (true)
```

== Spinlock / Busy waiting
Bei einem Spinlock oder auch busy waiting wartet ein Prozess darauf, dass eine
bestimmte Kondition erfüllt wird. Dabei führt er bei jeder Überprüfung einen
Rücksprung aus, und prüft erneut. Die Verschwendet CPU und ist schlecht in
Timesharing-Systemen. Vorteil ist das kein Contextswitch stattfinden muss. Sie
sind außerdem gut für kurzes Warten in Multi-Core-Systemen.

Wie bereits oben gesehen kann durch die Verwendung von Spinlocks eine
Synchronisation, auf Kosten von CPU Ressourcen stattfinden.

== Semaphoren
Beschreibung siehe @semaphores[Semaphores].

=== Implementierung mittels Spinlock:
```c
void wait(sem) {
  while (sem <= 0);
  sem--;
}
```

```c
void signal(sem) {
  sem++;
}
```

Beispielnutzung:
```c
semaphore sem = 1

wait(sem)
// critical section
signal(sem)
```

=== Implementierung ohne Spinlock:
mittels Semaphore Warteschlange:
```c
typedef struct _process {
  // true == busy
  bool locked;
  _process *next;
} Process;

typedef struct {
  int value;
  struct Process *list;
} Semaphore;

// last process in the queue
Process *last = NULL;
```

- *lock*
```c
lock(Process *l, Process *p) {            // last process
  p−>next = NULL;                         // p
  Prozess pred = fetch_and_store(l, p);   // p: new tail: pred = l; l = p;
  if(pred != NULL) {                      // Locked; List not empty
    p−>locked = true;                     // Locked by pred
    pred−>next = p;                       // insert p
    sleep();                              // wait on pred
  }
}
```

- *unlock*
```c
unlock(Process *l, Process *p) {
  if(p−>next == NULL) {               // no successor in the list
    if(compare_and_swap(l, p, NULL))  // if (l == p) l = NULL
      return;
    while(p−>next == NULL);           // wait in succ
  }
  p−>next−>locked = false;            // unlock succ
  wakeup(p->next);
}
```

- *process p*
```c
void wait(Semaphore *sem) {
  sem->value--;
  if(sem->value < 0)
    lock(last, p);
}
void signal(Semaphore *sem) {
  sem->value++;
  if(sem->value <= 0)
    unlock(last, p);
}
```

Falls jemand das hier nicht versteht, würde ich gerne auf die Folien von Herr
Radush verweisen, mit denen ich genau so viel wie hier steht verstanden habe.
(Nicht besonders viel!)

== Monitor und Condition Konstrukt (Java)
Ein Monitor ist ein ADT der Daten und vordefinierte Funktionen bereitstellt.
Diese Funktionen sind mutual exclusive. Die Daten auf die Zugegriffen werden
kann sind nur lokal vorhanden und somit parallel zugreifbar. Der Monitor stellt
sicher das zu jedem Zeitpunkt maximal ein Prozess aktiv die Daten des Monitors
manipuliert. 

Um dies zu ermöglichen wird ein weiteres Konstruct, die Condition benötigt. Die
einzigen 2 Operation auf den Conditions sind signal() und wait(), wobei wait
mit einem Paramter von Typ Condition aufgerufen werden kann. Dies ermöglicht
Bedingtes Warten.

Die Conditions werden beim schlafen bzw. warten auf Ausführung in einer Queue
gespeichert.

#grid(columns: (50%, 50%), 
  figure(image("./images/sync-monitor.png", width: 75%)),
  figure(image("./images/sync-monitor_queue.png", width: 100%))
)

*Beispiel (Serial):*
#grid(columns: (50%, 50%), 
```Java
monitor Serial {
  condition x = 0;
  bool done = false;
  void f1() {
    Anweisung s1;
    done = true;
    x.signal();
  }

  void f2() {
    if(done == false)
    x.wait();
    Anweisung s2;
  }
}
```,
[
  Prozess $P_1$:
  ```Java
  Serial s1;
  s1.f1();
  ```
  Prozess $P_2$:
  ```Java
  Serial s2;
  s2.f2();
  ```
]
)

*Implementierung mit Semaphoren:*
#grid(columns: (50%, 50%), 
```Java
monitor ParallelSem {
  semaphore mutex = 1; // Monitor lock
  semaphore next = 0;  // Lock of Conditions
  int next_count = 0;  // Count Conditions

  Function f() {
    // calculation
    if (next_count > 0)
      signal(next);
    else
      signal(mutex);
  }
}
```,
```Java
condition X {
  smaphore x_sem = 0;
  int x_count = 0;

  x.wait() {
    x_count++;
    if(next_count > 0)
      signal(next);
    else 
      signal(mutex);

    wait(x_sem);
    x_count--;
  }

  x.signal() {
    if(x_count > 0) {
      next_count++;
      signal(x_sem);
      wait(next);
      next_count--;
    }
  }
}
```
)

*Ressourcenzuteilung:*

#grid(columns: (50%, 50%), 
```Java
monitor ResourceAllocator {
  boolean busy = false;
  condition x;

  void acquire(int time) {
    if(busy)
    x.wait(time);
    busy = true;
  }

  void release() {
    busy = false;
    x.signal();
  }
}
```,
```Java
ResourceAllocator R;
Time t;

R.acquire(t);

// acquire Ressources


R.release();
```
)

*Dining Philosophers Monitor basiert:*
#grid(columns: (50%, 50%), 
```Java
monitor DiningPhilosophers {
  enum { THINKING, HUNGRY, EATING } state[N];
  condition self[N];

  int left(int i) {
    return (i + N – 1) % N;
  }

  int right(int i) {
    return (i + 1) % N;
  }

  void test_and_eat(int i) {
    if(state[i] == HUNGRY && 
      state[left(i) != EATING && 
      state[right(i)] != EATING) {

      state[i] = EATING;
      self[i].signal();
    }
  }
```,
```Java
  initialization() {
    for(int i = 0; i < N; i++)
      state[i] = THINKING;
  }

  void pickup(int i) {
    state[i] = HUNGRY;
    test_and_eat(i);
    if(state[i] != EATING)
    self[i].wait();
  }

  void putdown(int i) {
    state[i] = THINKING;
    test_and_eat(left(i));
    test_and_eat(right(i));
  }
}
```
)
Auch hier habe ich die Folien nicht richtig verstanden und eigentlich nur
kopiert!

= Alternative Ansätze der Synchronisation
Auf neuen Systemen ist wie bereits mehrfach angesprochen ein paralleles
Berechnen von Problemen zum Standard geworden. Um dies zu ermöglichen werden
meist Mutexes bzw. Semaphoren und andere Konzepte verwendet. Diese sind jedoch
nicht sonderlich schnell und schützen nicht vor deadlocks, race conditions und
livenes hazards wie zum Beispiel Livelocks. Außerdem verliert man bei
zunehmender Thread Anzahl performance durch erschwerte jedoch nötige
Synchronisation.

Um diese Probleme zu lösen wurden neue Wege gesucht um das Programmieren zu
vereinfachen und trotzdem die Performance der Programme zu erhalten.

Wir gehen nur auf das Konzept des Transactional Memorys ein. Weitere Ansätze
sind OpenMP und Funktionale Programmiersprachen (nachzulesen in der
zugrundeliegenden Quelle Chapter 7)

== Transactional Memory
Ein Ansatz ist der Transaktionelle Speicher. Ein Traditioneller Ansatz (mit
Mutexes) um Daten im Shared memory zu verändern wäre wie folgt:
```
void update() {
  acquire();

  // update shared memory

  release();
}
```
Da dies jedoch potentielle Deadlocks und andere Fehler mit sich bringt kann auf
einen anderen Ansatz gesetzt werden.

Wir erstellen ein neues Konstrukt `atomic{S}`, welches sicherstellt, dass
Operationen auf S transaktionell stattfinden. 
```
void update {
  atomic {
    // update shared memory
  }
}
```
Dadurch ist nichtmehr der Programmierer sonder der Mechanismus an sich
zuständig für die Synchronisation der Operation.

Dieses Konstrukt wird meist vom Compiler generiert und durch Hardware
Transaktionsspeicher im Cache unterstützt.

= Input/Output (I/O)
== Architektur
#figure(image("./images/pc-architecture.png", width: 90%))

Unter externen Geräten(Devices) verstehen wir alles, was nicht CPU bzw. RAM ist
(z.b. GPU, Networkcard, SSDs, ...). Diese Geräte sind meistens bestimmten
Speicher Adressen zugeordnet.

== Speicher
- SRAM (Static Random Access Memory)
Wird meist als Cachespeicher benutzt. Komplex und teuer!
- DRAM (Dynamic Random Access Memory)
Relativ günstig. Dichte Speicher Anordnung. Kapazitoren verlieren Ladung und
müssen periodisch neu "beschrieben" werden.

== I/O Bus
#figure(image("./images/io-bus.png", width: 70%))

Interconnect welches für die Kommunikation mit vielen verschiedenen Geräten
gebraucht wird.

== Device Communication
Wir Unterscheide zuerst zwischen Speicher gemapptem I/O _(Memory mapped I/O)_,
gemappten Geräte Speicher _(Mapped device memory)_, Port gemapptem I/O _(Port
mapped I/O)_ und DMA _(Direct memory access)_ unterschieden.

Bei _Memory mapped I/O_ wird einem Gerät eine spezifizierte Speicheradresse
zugeordnet und read/write kann genau wie auf den restlichen RAM genutzt werden.
Die einzelne Semantic ist je nach Gerät spezifisch. Es handelt sich hier jedoch
_nicht wirklich um RAM_.

Bei _Mapped device memory_ wird eine spezifische Speicheradresse, dem RAM des
externen Geräts zugeordnet.

Bei _Port mapped I/O_ wird von manchen Architekturen ermöglicht. x86 stellt zu
Beispiel die in/out Befehle zur Verfügung mit denen I/O ports/pins gesteuert
werden können. Der RAM und die I/O haben einen getrennten Addressraum.

Bei _DMA_ schreibt/liest das Gerät automatisch in/aus den/dem RAM. Die CPU ist
hier nur der Initiator und kann während dem Transfer andere Aufgaben erledigen.

=== Beispiel _Memory Mapped I/O_ an einem Arduino Uno ATmega328P:
#grid(columns: (50%, 50%), 
  [
    CPU Register, die den Status der I/O pins beinhalten.
    8 GPIO (General purpose I/O) pins sind verbunden um einen *GPIO Port* zu
    bilden.
    #figure(image("./images/io-arduino_mem.png", width: 50%))
  ],
  figure(image("./images/io-arduino.png", width: 90%))
)

Der Zugriff erfolgt wie auf normalen Speicher:
```c
volatile uint8_t* portb_direction_addr = (volatile uint8_t*)0x24;
volatile uint8_t* portb_addr = (volatile uint8_t*)0x25;

*portb_direction_addr = 0b11111111;   // Configure all pins on port B as output

*portb_addr = 0b11111111;             // Set all pins on port B high
*portb_addr = 0b00000000;             // Set all pins on port B low
```

Der ATmega328P hat 3 verschiedene Addressräume.
- Regulären RAM: Inklusive dem _Memory mapped I/O_.
- Flash memory: welches das Programm und den Bootloader enthält.
- Non-volatile EEPROM: Dieser kann genutzt werden um permanent Daten zu
  speichern.

Alle Addressen starten bei `0x0000`. Der gewählte Addressraum wird durch eine
Assembly Instruktion angegeben.

=== Beispiel _DMA-Buffer_:
#grid(columns: (50%, 50%), 
  [
    Die CPU wird nur genutzt um den Transfer zu Initialisieren und beim Abschluss
    zu überprüfen. Der Transfer an sich ist unabhängig.
    
    Damit dies möglich ist braucht es gewisse Buffer, damit die Initialisierten und
    in einer Queue wartenden Transfers direkt stattfinden können.
  ],
  figure(image("./images/io-dma_buffer.png", width: 80%))
)

Wir betrachten nun das Beispiel an einem NIC (Network Card Interface). 

#figure(image("./images/io-nic.png", width: 80%))

Das Link-Interface kommuniziert mit der Network hardware. Das Bus-Interface
nutzt DMA um Pakete direkt in den RAM zu lesen/schreiben. Für die Operations
Queue wird eine FIFO für das Lesen und das Schreiben verwendet. Der
Gerätetreiber stellt dem Kernel die benötigte Funktionalität zur Verfügung
(reset, ioctl, output, interrupt, read, write, ...). Um das Gerät zu
synchronisieren (lesen, schreiben, usw.) kann die einfache Methode des
*Polling* oder ein Interrupt-based Ansatz verwendet werden.

*Polling:*
Überprüft ununterbrochen ob die Operation beendet wurde. Das benötigt viel CPU
Resourcen bzw. lässt die CPU busy waiting. Außerdem können keine 2 oder mehr
Operation gleichzeitig ausgeführt werden.

*Interrupt-based Device Synchronisation:*
Das Gerät triggert einen CPU Interrupt um etwas zu signalisieren. Der
Interrupthandler wird aufgerufen und der Gerätetreiber kann den Grund des
Interrupts sofort prüfen. Dadurch können CPU und Gerät unabhängig voneinander
Arbeiten. Kommt es zu häufigen Interrupts kann die CPU Geschwindigkeit stark
beeinflusst werden, da jedes mal ein Contextswitch getriggert wird. Dieser
Ansatz wird von den meisten Betriebssystemen genutzt.

= Speicher Hardware und Software
== HDD
HDDs (Hard disk drive) sind magnetische Datenträger. Sie nutzen mehrere
gestapelte platters, die in konzentrische tracks aufgeteilt werden. Mehrere
sectors erzeugen einen track. Die gleichen tracks von allen platters werden
cylinder genannt. Die Schreib und Leseköpfe lsens/schreiben auf den cylinder.
In einer HDD wird ein großer Teil der Daten für die Error Korrektur reserviert.

#figure(image("./images/io-hdd.png", width: 80%))

Die Geschwindigkeit einer HDD hängt stark von der Ordnung und dem Ort des
aufgerufenen Speicher Segments ab. Der sequenzielle Abruf ist wesentlich
schneller als der willkürliche Zugriff.

== SSD
SSDs (Solid state drives) sind Flash Datenträger, ohne jegliche Bewegten Teile.
Sie haben die HDDs in so gut wie allen Bereichen und Anwendungen ersetzt. Die
Daten werden durch elektrische Ladung gespeichert und halten über 10+ Jahre.
Speicherzellen können beinahe unendlich oft gelesen werden. Das schreiben ist
jedoch auf 10.000 bis 100.000 beschränkt. Eine erhöhte Redundanz und
Abnutzungsausgleich kompensiert diesen Nachteil. SSDs sind schnell, zuverlässig
und Erschütterungsresistent.

*Abnutzungsausgleich:* _(Wear leveling)_ \
Teilt die Schreibvorgänge auf den gesamten Speicher gleichmäßig auf, um die
Lebensdauer des Geräts zu verlängern. Dies benötigt eine komplexe Addresslogik,
die vom Flash controller erledigt wird. Ist die SSD fast voll kann dies zu
Performance Verlust führen.

*Architektur:*
#figure(image("./images/io-ssd_architecture.png", width: 80%))

Der Flash controller ist zuständig den Speicher als Zusammenhängenden Bereich
an das System zu übergeben.

== NAND und NOR Flash
NAND Flash ist dicht bedeckt mit einer hohen Kapazität pro Speicherchip. NAND
ist anfälliger für Fehler und benötigt Error correction. Die
Schreibgeschwindigkeit ist hoch.

NOR Flash hat eine schnelle Lesegeschwindigkeit und kann genutzt werden um
Programmcode direkt in-place auszuführen. Es ist zuverlässig und benötigt
virtuell keine Error correction. NOR Flash wird häufig für Embedded Systems
verwendet.

*Typen:*
- SLC: (Single) 1 Bit
- MLC: (Multi) 2 Bits
- TLC: (Triple) 3 Bits
- QLC: (Quad) 4 Bits

Das Erhöhen der Bits pro Zelle verringert die Schreibgeschwindigkeit des
NAND-Flash. Die Kosten pro Bit sind jedoch geringer.

== RAID
RAID oder auch Redundant Array of Independent Disks ist das kombinieren von
mehreren Datenträger zu einem virtuellen Datenträger. Es gibt Unterschiedliche
RAID Level, die unterschiedliche Aspekte optimieren. Die Hardware Implmentation
ist teuer, aber schnell, hat keinen CPU-Overhead, aber ist nicht portable, da
RAID Kontroller von verschiedenen Herstellern verschieden funktionieren. Die
Software Implementation ist kostenlos, auf modernen CPUs genau so schnell wie
eine Hardware Implementation und portable. 

*Die Benutzung von RAID ist nicht gleich einem BACKUP!*

== RAID Standard Levels
$
N = \#"disks" \
D = "disk size"
$

=== RAID 0
_(Striping of blocks across disks)_
#figure(image("./images/raid-raid_0.png", width: 30%))
Keine Redundanz. Alle Speicherblöcke werden zu einem großen Block
zusammengefasst. Die Lese-/Schreibgeschwindigkeit verbessert sich.

Nutzbarer Speicher:
$
N dot D
$

=== RAID 1
_(Mirroring of blocks across disks)_
#figure(image("./images/raid-raid_1.png", width: 30%))
Redundanz bis zum Versagen eines kompletten Datenträgers. Die
Lesegeschwindigkeit verbessert sich.

Nutzbarer Speicher:
$
D
$

=== RAID 2
_(Striping of bits with hamming code error correction)_
#figure(image("./images/raid-raid_2.png", width: 40%))
Es werden mindestens 3 Datenträger benötigt. Durch die Error correction ist es
möglich, die Daten eines Datenträgers nach dem Versagen wieder herzustellen.
Die Lese und Schreib Geschwindigkeit verändert sich nicht. Dieser Ansatz wird
in der Praxis so gut wie nie genutzt.

Nutzbarer Speicher:
$
(N - 1) dot D
$

=== RAID 3
_(Striping of bytes with parity disk)_
#figure(image("./images/raid-raid_3.png", width: 40%))
Die selben Eigenschaften wir RAID 2, jedoch wesentlich einfachere Berechnung.

=== RAID 4
_(Striping of blocks with parity disk)_
#figure(image("./images/raid-raid_4.png", width: 40%))
Mindestens 3 Datenträger, komplette wiederherstellung eines fehlerhaften
Datenträgers. Die Schreib Geschwindigkeit ist nicht erhöht, jedoch die
Lesegeschwindigkeit. Wird in der Praxis selten genutzt.

Nutzbarer Speicher:
$
(N - 1) dot D
$

=== RAID 5
_(Striping of blocks with distributed parity)_
#figure(image("./images/raid-raid_5.png", width: 40%))
Die selben Eigenschaften wie RAID 4. Durch die Verteilung sind Lese- und
Schreibgeschwindigkeit verbessert. Wird häufig genutzt und ersetzt (eigentlich)
RAID 2-4.

=== RAID 6
_(Extension of RAID 5, adding another parity block)_
#figure(image("./images/raid-raid_6.png", width: 50%))
Es werden mindestens 4 Datenträger benötigt. Durch die zweifache Verteilung
können 2 fehlerhafte Datenträger komplett wieder hergestellt werden. Wird
häufig genutzt um weitere Sicherheit zu gewährleisten. Z.b. nach dem ersetzen
eines fehlerhaften Datenträgers.

== RAID Hybrid Levels

=== RAID 01 / RAID 10
_(Combination of RAID 0 and 1)_
#figure(image("./images/raid-raid_01.png", width: 50%))
Es werden mindestens 4 Datenträger benötigt. Es handelt sich um eine
Kombination von RAID 0 und RAID 1. _(Mirror of stripes)_ bzw. _(Stripe of
mirrors)_.

Nutzbarer Speicher:
$
(N/2) dot D
$

=== RAID 50
_(Combination of RAID 5 and 0)_
#figure(image("./images/raid-raid_50.png", width: 60%))
Es werden mindestens 6 Datenträger benötigt. In jedem RAID 5 Block kann ein
Datenträger versagen und komplett wieder hergestellt werden. Die
Schreibgeschwindigkeit wird erhöht.

Nutzbarer Speicher:
$
M = \#"RAID groups" \ \
M dot (N / M - 1) dot D
$

= Filesystems und Partitioning
Die Datenträger eines Geräts werden dem Betriebssystem als lineares Array an
bytes übergeben. Um die einzelnen Daten des Systems zu speichern, wieder zu
finden, und viele weitere Operationen auf ihnen auszuführen, wird ein
Dateisystem genutzt. 

== Partitiontable
Die Partitionstabelle befindet sich am Anfang des Datenträgers bzw. des
Speicherarrays. Sie enthält die Position, den Typ, den Name, usw. von jeder
Partition. 

=== MBR
*MBR* (Master Boot Record) ist eine simple Partitionstabelle. Sie startet im
boot sector (ersten 512bytes) und kann die Partitionsdaten von Datenträgern bis
zu 2TB speichern. Bei einer MBR Partitionstabelle ist die Anzahl der
Partitionen zudem auf 4 Partitionen beschränkt. MBR wird heutzutage nicht mehr
genutzt. Der heutige Standard ist *GPT*.

=== GPT
*GPT* (GUID Partition Table) ist eine weitere Art der Partitionstabelle. Sie
wird heutzutage hauptsächlich genutzt. 

#grid(columns: (60%, 40%), 
  [
    Im Bootsector wird zuerst ein Bereich von 512bytes freigehalten. Dies ist
    dazu da um Programme daran zu hindern die GPT Tabelle durch schreiben von
    MBR Daten zu zerstören. Der GPT-Header beinhaltet Informationen zu den
    einzelnen Partitionen. Mit einer GPT Tabelle sind virtuell unendlich viele
    Partitionen möglich. Jeder Partition wird durch eine GUID gekennzeichnet.
    Am Ende des Datenträger findet sich zudem eine Backup Header, der bei
    Datenkorruption am Anfang des Datenträgers potenziell die Partitionen
    wieder herstellen kann.
  ],
  figure(image("./images/fs-gpt.png", width: 60%))
)

== FAT Filesystem
*FAT* (File Allocation Table) ist ein simples aber dementrspechend naives
Dateisystem. Der Datenträger ist in gleich große Cluster unterteilt (meist
16KiB). Eine  Datei wird durch eine linked-List von einem oder mehr dieser
Cluster dargestellt. Eine Indexierungstabelle zu Beginn der Partition zeigt auf
das Startcluster einer Datei. Folders sind spezielle Dateien die auf die
Dateien/cluster in dem Folder zeigen. Das FAT Dateisystem schützt nicht gegen
Datenkorruption und hat keinerlei error detection bzw. data recovery. 

FAT wird heutzutage noch in manchen Embedded Systems verwendet.

== Journaling Filesystem
Journaling Dateisysteme wie NTFS oder ext4 werden heutzutage häufig verwendet.
Sie schützen vor datacorruption. Das schreiben auf das Dateisystem ist jedoch
nicht besonders schnell und benötigt mehrere Schritte. Fehler während des
Schreibens sind somit gefährlich und können Daten bzw. im schlechtesten Fall
Dateisystem Metadaten zerstören. 

Wie das Wort Journaling schon vermuten lässt werden Änderungen an Dateien in
einem _Journal_ gespeichert. Dies passiert als erstes bei einer
Schreiboperation. Wenn nun ein Fehler aufgetreten ist können die Daten durch
das Journal wieder ersetzt werden. 

Fehler im Journal werden durch das inkludieren der checksum in den Journal
Einträgen verhindert.

== Multi-Disk Filesystem
Multi-Disk-Filesystems kombinieren Ideen von RAID und dem Journaling Dateisystem. Beispiel für diese Dateisysteme sind ZFS oder btrfs. Das Dateisystem kann hier über mehrere Datenträger verteilt sein. Dies passiert ohne ein RAID Array. Diese Dateisysteme schützen vor bit-rot durch das Speichern der checksum von jeder Datei. Duplikate werden nur einmal auf dem Dateisystem gespeichert und durch Referenzen zugänglich gemacht.

= Scheduling
