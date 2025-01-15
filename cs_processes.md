## Работа с процессами в C#

Работа с процессами в C# является одной из важных задач при создании приложений, взаимодействующих с операционной системой. В C# для управления процессами используется пространство имен `System.Diagnostics`. 

---

**Процесс** — это экземпляр выполняемой программы, содержащий как сам код программы, так и её текущее состояние (данные, ресурсы и т.д.). Процессы управляются операционной системой, которая предоставляет им ресурсы, такие как процессорное время, память и доступ к устройствам ввода/вывода.

#### Основные характеристики процесса:
- **Идентификатор процесса (PID)** — уникальный номер, присваиваемый процессу операционной системой.
- **Состояние процесса** — текущее состояние выполнения процесса.
- **Потоки** — процесс может содержать один или несколько потоков выполнения.
- **Контекст выполнения** — включает регистры процессора, указатель на текущую инструкцию, указатель стека и другие данные.

#### Основные состояния процессов:
1. **Создание (New)** — процесс создаётся, но ещё не готов к выполнению.
2. **Готовность (Ready)** — процесс готов к выполнению и ожидает выделения процессорного времени.
3. **Выполнение (Running)** — процесс выполняется на процессоре.
4. **Ожидание (Waiting)** — процесс ожидает завершения операции ввода/вывода или события.
5. **Завершение (Terminated)** — процесс завершён, и его ресурсы освобождены.

#### Управление процессами в ОС:
- **Планировщик процессов** — определяет, какой процесс будет выполняться в данный момент времени.
- **Контекст переключения (Context Switch)** — процесс сохранения текущего состояния одного процесса и восстановления состояния другого.
- **Межпроцессное взаимодействие (IPC)** — механизмы для обмена данными между процессами, такие как очереди сообщений, каналы и разделяемая память.


---

### Основные классы и их назначения

- **`Process`** — основной класс для работы с процессами. Позволяет запускать новые процессы, управлять ими и получать информацию о них.
- **`ProcessStartInfo`** — предоставляет свойства для настройки параметров запуска процесса (например, аргументы командной строки, рабочая директория, поток ввода/вывода и т. д.).

---

### Запуск процесса

Для запуска внешнего процесса используется метод `Process.Start()`. Пример простого запуска:

```csharp
using System.Diagnostics;

class Program
{
    static void Main(string[] args)
    {
        Process.Start("notepad.exe");
    }
}
```

#### Запуск с использованием `ProcessStartInfo`

Для более гибкой настройки используется объект `ProcessStartInfo`:

```csharp
using System.Diagnostics;

class Program
{
    static void Main(string[] args)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = "cmd.exe",
            Arguments = "/C echo Hello, World!",
            UseShellExecute = false,
            RedirectStandardOutput = true,
            CreateNoWindow = true
        };

        using (var process = Process.Start(startInfo))
        {
            string output = process.StandardOutput.ReadToEnd();
            process.WaitForExit();

            System.Console.WriteLine(output);
        }
    }
}
```

**Ключевые свойства `ProcessStartInfo`**:
- `FileName` — имя исполняемого файла или команды для выполнения.
- `Arguments` — аргументы для запуска.
- `UseShellExecute` — определяет, использовать ли оболочку Windows для запуска процесса.
- `RedirectStandardOutput` — перенаправление стандартного потока вывода.
- `RedirectStandardInput` — перенаправление стандартного потока ввода.
- `CreateNoWindow` — указывает, создавать ли окно для нового процесса.

---

### Чтение вывода процесса

Для взаимодействия с выводом процесса используются свойства `StandardOutput` и `StandardError`:

```csharp
var startInfo = new ProcessStartInfo
{
    FileName = "ping",
    Arguments = "google.com",
    RedirectStandardOutput = true,
    RedirectStandardError = true,
    UseShellExecute = false
};

using (var process = Process.Start(startInfo))
{
    string output = process.StandardOutput.ReadToEnd();
    string error = process.StandardError.ReadToEnd();
    process.WaitForExit();

    System.Console.WriteLine("Output:");
    System.Console.WriteLine(output);

    if (!string.IsNullOrEmpty(error))
    {
        System.Console.WriteLine("Error:");
        System.Console.WriteLine(error);
    }
}
```

---

### Ввод в процесс

Если необходимо передать данные в процесс, можно использовать поток `StandardInput`:

```csharp
var startInfo = new ProcessStartInfo
{
    FileName = "cmd.exe",
    RedirectStandardInput = true,
    RedirectStandardOutput = true,
    UseShellExecute = false
};

using (var process = Process.Start(startInfo))
{
    using (var writer = process.StandardInput)
    {
        writer.WriteLine("echo Custom Input");
        writer.WriteLine("exit");
    }

    string output = process.StandardOutput.ReadToEnd();
    System.Console.WriteLine(output);
}
```

---

### Получение информации о процессах

Класс `Process` позволяет получить информацию о запущенных процессах.

Свойства класса `Process`
- Handle - возвращает дескриптор процесса
- Id - идентификатор процесса в текущем сеансе ОС
- MachineName - имя компьютера, на котором запущен процесс
- Modules - коллекция ProcessModuleCollection, которая хранит набор модулей (файлов dll и exe), загруженных в рамках данного процесса
- Threads - коллекция ProcessThreadCollection, которая хранит набор потоков процесса
- ProcessName - имя процесса
- StartTime - время запуска процесса
- VirtualMemorySize64 - объем памяти, выделенный процессу

#### Получение списка процессов

```csharp
var processes = Process.GetProcesses();

foreach (var process in processes)
{
    System.Console.WriteLine($"ID: {process.Id}, Name: {process.ProcessName}");
}
```

#### Поиск процесса по имени

```csharp
var processesByName = Process.GetProcessesByName("notepad");

foreach (var process in processesByName)
{
    System.Console.WriteLine($"ID: {process.Id}, Name: {process.ProcessName}");
}
```

#### Получение текущего процесса

```csharp
var currentProcess = Process.GetCurrentProcess();
System.Console.WriteLine($"Current Process: {currentProcess.ProcessName}, ID: {currentProcess.Id}");
```

---

### Управление процессами

- **Остановка процесса**:

```csharp
var processes = Process.GetProcessesByName("notepad");

foreach (var process in processes)
{
    process.Kill();
    System.Console.WriteLine($"Process {process.ProcessName} (ID: {process.Id}) terminated.");
}
```

- **Ожидание завершения**:

```csharp
var process = Process.Start("notepad.exe");
process.WaitForExit();
System.Console.WriteLine("Notepad has exited.");
```

---

### Обработка событий процесса

Класс `Process` позволяет обрабатывать события, такие как завершение процесса. Пример:

```csharp
var process = new Process
{
    StartInfo = new ProcessStartInfo("notepad.exe")
};

process.Exited += (sender, e) =>
{
    System.Console.WriteLine("Process exited.");
};

process.EnableRaisingEvents = true;
process.Start();

process.WaitForExit();
```

---

### Заключение

Работа с процессами в C# предоставляет широкий функционал для взаимодействия с операционной системой. Умение запускать, управлять и взаимодействовать с процессами является полезным навыком при разработке приложений, требующих интеграции с внешними программами или выполнения системных команд.

