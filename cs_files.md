# Работа с файлами и файловыми потоками в C#

Работа с файлами и файловыми потоками является важным аспектом системного программирования и разработки приложений. В C# для этого предоставляются удобные классы и методы, входящие в пространство имен `System.IO`. В данной лекции мы рассмотрим основные концепции работы с файлами и потоками, их применение и примеры использования.

---

## Основные понятия

Файл — это именованная область на диске, используемая для хранения данных. Он может быть текстовым, бинарным или другого формата.

Поток (Stream) — это абстракция для работы с последовательностью данных. Потоки позволяют читать и записывать данные в файл, сеть или память.

---

## Пространство имен `System.IO`
Для работы с файлами и потоками используется пространство имен `System.IO`, которое включает:

- Классы для работы с файлами и каталогами (`File`, `Directory`, `FileInfo`, `DirectoryInfo`).
- Потоковые классы (`FileStream`, `StreamReader`, `StreamWriter`, `BinaryReader`, `BinaryWriter`).
- Поддержку работы с путями (`Path`).

---

## Основные классы для работы с файлами

### 1. `File` и `FileInfo`
Класс `File` предоставляет статические методы для работы с файлами:

- `File.Create(path)` — создание файла.
- `File.Delete(path)` — удаление файла.
- `File.Copy(src, dest)` — копирование файла.
- `File.Move(src, dest)` — перемещение файла.
- `File.Exists(path)` — проверка существования файла.
- `File.ReadAllText(path)` — чтение содержимого файла.
- `File.WriteAllText(path, content)` — запись текста в файл.

Класс `FileInfo` предоставляет аналогичные методы, но работает через экземпляры объектов.

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
Класс `Directory` используется для работы с каталогами:

- `Directory.CreateDirectory(path)` — создание каталога.
- `Directory.Delete(path, recursive)` — удаление каталога.
- `Directory.GetFiles(path)` — получение списка файлов.

Класс `DirectoryInfo` предоставляет методы для работы с каталогами через экземпляры.

---

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
## Режимы доступа файла

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

