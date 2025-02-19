### **Обмен данными между потоками в C#**  

## **1. Введение**  

В многопоточных приложениях важно безопасно передавать данные между потоками. Неправильнвая работа с данными может грозить блокировками потоков и другими ошибками в ПО. Для избежания блокировок можно применять синхронизацию потоков или специальные потокобезопасные объекты для передачи данных.
В C# для этого есть несколько инструментов:  

- **ConcurrentQueue<T>** – потокобезопасная неблокирующая очередь  
- **BlockingCollection<T>** – потокобезопасная очередь с блокировкой  
- **Channel<T>** – асинхронные каналы для передачи данных  

Эти механизмы используются в задачах обработки очередей, логирования, обработки сообщений и построения многопоточных систем.  

---

## **2. ConcurrentQueue<T>**  

### **2.1. Что такое ConcurrentQueue?**  
`ConcurrentQueue<T>` – это потокобезопасная реализация очереди (FIFO – **First In, First Out**), входящая в пространство имён `System.Collections.Concurrent`.  

**Особенности:**  
✅ Не блокирует потоки при работе с очередью  
✅ Высокая производительность  
✅ Поддержка **многопоточной** записи и чтения  
❌ Нет встроенного ожидания при отсутствии данных  

### **2.2. Пример использования**  

```csharp
using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        ConcurrentQueue<int> queue = new ConcurrentQueue<int>();

        // Поток записи
        var producer = Task.Run(() =>
        {
            for (int i = 0; i < 5; i++)
            {
                queue.Enqueue(i);
                Console.WriteLine($"Добавлено: {i}");
                Thread.Sleep(500);
            }
        });

        // Поток чтения
        var consumer = Task.Run(() =>
        {
            while (true)
            {
                if (queue.TryDequeue(out int value))
                {
                    Console.WriteLine($"Извлечено: {value}");
                }
                else
                {
                    Console.WriteLine("Очередь пуста, ожидаем...");
                }
                Thread.Sleep(300);
            }
        });

        await Task.WhenAll(producer, consumer);
    }
}
```

🔹 `Enqueue(value)` – добавляет элемент в очередь  
🔹 `TryDequeue(out value)` – извлекает элемент, если он есть  

---

## **3. BlockingCollection<T>**  

### **3.1. Что такое BlockingCollection?**  
`BlockingCollection<T>` – это потокобезопасная коллекция, основанная на `ConcurrentQueue<T>`, но с поддержкой **блокировки** и **ограниченного размера** очереди.  

**Особенности:**  
✅ Позволяет **ожидать** появления данных в очереди  
✅ Поддерживает ограниченный размер буфера  
✅ Может использовать `ConcurrentQueue<T>` или `ConcurrentStack<T>`  
❌ Синхронный механизм, не поддерживает `async/await`  

### **3.2. Пример использования**  

```csharp
using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        BlockingCollection<int> collection = new BlockingCollection<int>(3); // Ограниченная очередь

        // Поток записи
        var producer = Task.Run(() =>
        {
            for (int i = 0; i < 5; i++)
            {
                collection.Add(i);
                Console.WriteLine($"Добавлено: {i}");
                Thread.Sleep(500);
            }
            collection.CompleteAdding(); // Завершаем запись
        });

        // Поток чтения
        var consumer = Task.Run(() =>
        {
            foreach (var item in collection.GetConsumingEnumerable()) 
            {
                Console.WriteLine($"Извлечено: {item}");
            }
        });

        await Task.WhenAll(producer, consumer);
    }
}
```

🔹 `Add(value)` – добавляет элемент, блокируя поток при заполненной очереди  
🔹 `GetConsumingEnumerable()` – читает элементы и ожидает новых  
🔹 `CompleteAdding()` – закрывает очередь для записи  

---

## **4. Каналы (Channel<T>)**  

### **4.1. Что такое каналы?**  
Каналы (`System.Threading.Channels`) – это **современный асинхронный механизм передачи данных** между потоками, позволяющий избежать блокировок.  

**Особенности:**  
✅ Полностью **асинхронный** механизм (в отличие от `BlockingCollection<T>`)  
✅ Поддержка ограниченного и неограниченного буфера  
✅ Оптимизирован для многопоточного взаимодействия  

### **4.2. Пример использования канала**  

```csharp
using System;
using System.Threading.Channels;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        var channel = Channel.CreateUnbounded<int>();

        var writerTask = WriteToChannel(channel.Writer);
        var readerTask = ReadFromChannel(channel.Reader);

        await Task.WhenAll(writerTask, readerTask);
    }

    static async Task WriteToChannel(ChannelWriter<int> writer)
    {
        for (int i = 0; i < 5; i++)
        {
            await writer.WriteAsync(i);
            Console.WriteLine($"Записано: {i}");
            await Task.Delay(500);
        }
        writer.Complete();
    }

    static async Task ReadFromChannel(ChannelReader<int> reader)
    {
        await foreach (var item in reader.ReadAllAsync())
        {
            Console.WriteLine($"Прочитано: {item}");
        }
    }
}
```

🔹 `WriteAsync(value)` – асинхронно записывает элемент  
🔹 `ReadAllAsync()` – читает элементы **без блокировки**  

---

**Когда использовать?**  
- **`ConcurrentQueue<T>`** – если нужна **простая многопоточная очередь** без блокировки  
- **`BlockingCollection<T>`** – если нужно **ожидание** элементов и **ограниченный буфер**  
- **`Channel<T>`** – если нужно **асинхронное взаимодействие** между потоками  

---

## **6. Заключение**  

1. **ConcurrentQueue<T>** – простая потокобезопасная очередь без блокировки  
2. **BlockingCollection<T>** – очередь с блокировкой и ограниченным буфером  
3. **Channel<T>** – **асинхронный** механизм передачи данных  

### **Задание для самостоятельной работы:**  
1. Разработать простую  **асинхронную** систему логирования на основе **Channel<T>**. Несколько асинхроныых методов записывают различные сообщения в канал, отдельный поток занимается записью содержимого канала в файл.
