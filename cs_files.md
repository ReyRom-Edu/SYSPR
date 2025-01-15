# Работа с файлами и файловыми потоками в C#

Работа с файлами и файловыми потоками является важным аспектом системного программирования и разработки приложений. В C# для этого предоставляются удобные классы и методы, входящие в пространство имен `System.IO`. В данной лекции мы рассмотрим основные концепции работы с файлами и потоками, их применение и примеры использования.

---

## Основные понятия

Файл — это именованная область на диске, используемая для хранения данных. Он может быть текстовым, бинарным или другого формата.

Поток (Stream) — это абстракция для работы с последовательностью данных. Потоки позволяют читать и записывать данные в файл, сеть или память.

---

## Пространство имен `System.IO`
Для работы с файлами и потоками используется пространство имен `System.IO`, которое включает:

- Классы для работы с файлами и каталогами (`File`, `Directory`, `FileInfo`, `DirectoryInfo`, `DriveInfo`).
- Потоковые классы (`FileStream`, `StreamReader`, `StreamWriter`, `BinaryReader`, `BinaryWriter`).
- Поддержку работы с путями (`Path`).

---

## Основные классы для работы с файлами

### 1. `File` и `FileInfo`
Класс `File` предоставляет статические методы для работы с файлами.
Класс `FileInfo` предоставляет аналогичные методы, но работает через экземпляры объектов.

| Подготовка | `string filename = @"c:\Temp\1.txt";` | `var file = new fileInfo(@"c:\Temp\1.txt");` |
|------------|---------------------------------------|----------------------------------------------|
| Создание   |`File.CreateDirectory(filename)`       |`file.Create();`                              |
| Удаление   |`File.Delete(filename)`                |`file.Delete();`                              |
| Копированние|`File.Copy(filename, dest)`           |`file.CopyTo(dest);`                          |
| Перемещение|`File.Move(filename, dest)`            |`file.MoveTo(dest);`                          |
| Существование |`File.Exists(filename)`             |`file.Exists;`                                |

Свойства FileInfo:
- Name - имя без пути
- Extension - расширение (".txt")
- FullName - полное имя (содержит путь)
- DirectoryName - путь к файлу (без имени файла)
- Length - размер файла в байтах

#### Пример:
```csharp
string path = "example.txt";
if (!File.Exists(path))
{
    File.WriteAllText(path, "Привет, мир!");
}
string content = File.ReadAllText(path);
Console.WriteLine(content);
```

### 2. `Directory` и `DirectoryInfo`
Класс `Directory` используется для работы с каталогами.
Класс `DirectoryInfo` предоставляет методы для работы с каталогами через экземпляры.

| Подготовка | `string path = @"c:\Temp";` | `var di = new DirectoryInfo(@"c:\Temp");` |
|------------|-----------------------------|-------------------------------------------|
| Создание   |`Directory.CreateDirectory(path)`|`di.Create();`                         |
| Удаление   |`Directory.Delete(path)`     |`di.Delete();`                             |
| Перемещение|`Directory.Move(path, dest)` |`di.MoveTo(dest);`                         |
| Существование |`Directory.Exists(path)`  |`di.Exists;`                               |
| Родительский каталог|`Directory.GetParent(path)`|`di.Parent;`                        |
| Список каталогов|`Directory.GetDirectories(path)`|`di.GetDirectories();`             |
| Список файлов|`Directory.GetFiles(path)` |`di.GetFiles();`                           |

У методов `GetDirectories` и `GetFiles` есть дополнительные параметры
- `searchPattern` - шаблон для поиска, например `"*.txt"`
- `searchOption` - опция поиска (`SearchOption.AllDirectories` - все вложенные каталоги, `SearchOption.TopDirectoryOnly` - без вложенных каталогов)

---

## Работа с путями
Класс `Path` позволяет манипулировать путями файлов и каталогов.

#### Пример:
```csharp
string path = "C:\\Users\\Public\\Documents\\example.txt";

Console.WriteLine(Path.GetDirectoryName(path)); // Каталог
Console.WriteLine(Path.GetFileName(path)); // Имя файла
Console.WriteLine(Path.GetExtension(path)); // Расширение
```

## Работа с классом `DriveInfo`
Класс `DriveInfo` предоставляет информацию о дисках, подключенных к системе.

### Основные методы и свойства
- `DriveInfo.GetDrives()` — возвращает список всех дисков.
- `IsReady` — показывает, готов ли диск к использованию.
- `Name` — имя диска.
- `VoluemeLabel` — метка тома.
- `DriveFormat` — имя файловой системы.
- `DriveType` — тип диска (например, `Fixed`, `Removable`).
- `TotalSize` и `AvailableFreeSpace` — общий объем и доступное место на диске.

#### Пример:
```csharp
using System.IO;

foreach (DriveInfo drive in DriveInfo.GetDrives())
{
    if (drive.IsReady)
    {
        Console.WriteLine($"Диск: {drive.Name}");
        Console.WriteLine($"Тип: {drive.DriveType}");
        Console.WriteLine($"Общий объем: {drive.TotalSize / 1024 / 1024} МБ");
        Console.WriteLine($"Свободное место: {drive.AvailableFreeSpace / 1024 / 1024} МБ");
    }
}
```

---

## Работа с классом `ZipFile`
Класс `ZipFile` из пространства имен `System.IO.Compression` предоставляет возможности для работы с ZIP-архивами.

### Основные методы
- `ZipFile.CreateFromDirectory(sourceDirectory, zipPath)` — создает архив из указанной директории.
- `ZipFile.ExtractToDirectory(zipPath, destinationDirectory)` — извлекает содержимое архива в указанную директорию.

### Пример:
```csharp
using System.IO.Compression;

string sourceDirectory = "C:\\example";
string zipPath = "C:\\example.zip";
string extractPath = "C:\\extracted";

// Создание архива
ZipFile.CreateFromDirectory(sourceDirectory, zipPath);
Console.WriteLine("Архив создан.");

// Извлечение архива
ZipFile.ExtractToDirectory(zipPath, extractPath);
Console.WriteLine("Архив извлечен.");
```

Для работы с файлами в архиве используется класс `ZipArchive`

```csharp
string zipPath = @"c:\users\exampleuser\start.zip";
string extractPath = @"c:\users\exampleuser\extract";
string newFile = @"c:\users\exampleuser\NewFile.txt";

using (ZipArchive archive = ZipFile.Open(zipPath, ZipArchiveMode.Update))
{
    archive.CreateEntryFromFile(newFile, "NewEntry.txt");
    archive.ExtractToDirectory(extractPath);
}
```

## Потоковые классы

### 1. `FileStream`
Класс `FileStream` предоставляет низкоуровневый доступ к файлам. Он используется для чтения и записи данных в бинарном формате.

#### Пример записи и чтения:
```csharp
string path = "binary.dat";

// Запись данных
using (FileStream fs = new FileStream(path, FileMode.Create))
{
    byte[] data = { 1, 2, 3, 4, 5 };
    fs.Write(data, 0, data.Length);
}

// Чтение данных
using (FileStream fs = new FileStream(path, FileMode.Open))
{
    byte[] buffer = new byte[fs.Length];
    fs.Read(buffer, 0, buffer.Length);
    Console.WriteLine(string.Join(", ", buffer));
}
```

### Режимы доступа файла

При работе с файлами в C# можно задавать режимы доступа с помощью перечислений `FileMode`, `FileAccess` и `FileShare`.

### 1. `FileMode`
Перечисление `FileMode` определяет, как файл открывается или создается:
- `FileMode.Create` — создает новый файл или перезаписывает существующий.
- `FileMode.CreateNew` — создает новый файл. Если файл существует, выбрасывается исключение.
- `FileMode.Open` — открывает существующий файл.
- `FileMode.OpenOrCreate` — открывает файл, если он существует, иначе создает новый.
- `FileMode.Append` — открывает файл для добавления данных. Если файл не существует, создает новый.
- `FileMode.Truncate` — открывает существующий файл и очищает его содержимое.

### 2. `FileAccess`
Перечисление `FileAccess` определяет уровень доступа к файлу:
- `FileAccess.Read` — только чтение.
- `FileAccess.Write` — только запись.
- `FileAccess.ReadWrite` — чтение и запись.

### 3. `FileShare`
Перечисление `FileShare` определяет, как файл может быть разделен между несколькими процессами:
- `FileShare.None` — запрещает другим процессам доступ к файлу.
- `FileShare.Read` — разрешает другим процессам читать файл.
- `FileShare.Write` — разрешает другим процессам записывать в файл.
- `FileShare.ReadWrite` — разрешает другим процессам читать и записывать файл.

#### Пример:
```csharp
string path = "example.dat";
using (FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None))
{
    byte[] data = { 10, 20, 30 };
    fs.Write(data, 0, data.Length);
}
```

### 2. `StreamReader` и `StreamWriter`
Эти классы используются для работы с текстовыми файлами.

#### Пример:
```csharp
string path = "text.txt";

// Запись текста
using (StreamWriter writer = new StreamWriter(path))
{
    writer.WriteLine("Первая строка текста");
    writer.WriteLine("Вторая строка текста");
}

// Чтение текста
using (StreamReader reader = new StreamReader(path))
{
    string line;
    while ((line = reader.ReadLine()) != null)
    {
        Console.WriteLine(line);
    }
}
```

### 3. `BinaryReader` и `BinaryWriter`
Эти классы предназначены для работы с бинарными данными.

#### Пример:
```csharp
string path = "data.bin";

// Запись данных
using (BinaryWriter writer = new BinaryWriter(File.Open(path, FileMode.Create)))
{
    writer.Write(123); // Записываем целое число
    writer.Write(3.14); // Записываем число с плавающей запятой
}

// Чтение данных
using (BinaryReader reader = new BinaryReader(File.Open(path, FileMode.Open)))
{
    int intValue = reader.ReadInt32();
    double doubleValue = reader.ReadDouble();

    Console.WriteLine($"Число: {intValue}, Дробное: {doubleValue}");
}
```


---

## Обработка ошибок
Работа с файлами часто связана с возможностью возникновения ошибок (например, отсутствие доступа к файлу). Для обработки таких ситуаций используется конструкция `try-catch`.

#### Пример:
```csharp
string path = "nonexistent.txt";
try
{
    string content = File.ReadAllText(path);
    Console.WriteLine(content);
}
catch (FileNotFoundException ex)
{
    Console.WriteLine($"Файл не найден: {ex.Message}");
}
catch (Exception ex)
{
    Console.WriteLine($"Ошибка: {ex.Message}");
}
```

---

## Заключение
Работа с файлами и потоками в C# предоставляет гибкие возможности для разработки приложений, требующих взаимодействия с файловой системой. Классы `System.IO` позволяют легко создавать, читать, записывать и управлять файлами, а также обрабатывать ошибки. Практическое освоение этих инструментов — важный шаг в обучении программированию.

