static void Main(string[] args)
{
   string filePath = "access.log"; // Путь к файлу логов
   int chunkSize = 10_000; // Количество строк на блок
   int maxDegreeOfParallelism = 12; // Количество потоков

   if (!File.Exists(filePath))
   {
       Console.WriteLine("Файл логов не найден.");
       return;
   }

   // Коллекции для хранения результатов
   var requestTypes = new ConcurrentDictionary<string, int>();
   var ipAddresses = new ConcurrentDictionary<string, int>();
   int total4xxErrors = 0;

   // Регулярное выражение для разбора строки лога
   var logRegex = new Regex(@"^(?<ip>\S+) .* ""(?<method>GET|POST|PUT|DELETE) .*"" (?<status>\d{3})", RegexOptions.Compiled);

   try
   {
       Stopwatch sw = new Stopwatch();
       sw.Start();
       using (var fileReader = new StreamReader(filePath))
       {
           var linesBuffer = new string[chunkSize];
           int linesRead;

           // Чтение файла по частям
           while ((linesRead = ReadLines(fileReader, linesBuffer)) > 0)
           {
               // Создание задачи для обработки блока строк
               Parallel.ForEach(
                   Partition(linesBuffer.Take(linesRead), maxDegreeOfParallelism),
                   new ParallelOptions { MaxDegreeOfParallelism = maxDegreeOfParallelism },
                   block =>
                   {
                       var localRequestTypes = new ConcurrentDictionary<string, int>();
                       var localIpAddresses = new ConcurrentDictionary<string, int>();
                       int local4xxErrors = 0;

                       foreach (var line in block)
                       {
                           var match = logRegex.Match(line);
                           if (match.Success)
                           {
                               // Извлечение данных из строки лога
                               var ip = match.Groups["ip"].Value;
                               var method = match.Groups["method"].Value;
                               var status = int.Parse(match.Groups["status"].Value);

                               // Обновление локальных результатов
                               localRequestTypes.AddOrUpdate(method, 1, (key, value) => value + 1);
                               localIpAddresses.AddOrUpdate(ip, 1, (key, value) => value + 1);
                               if (status >= 400 && status < 500)
                                   local4xxErrors++;
                           }
                       }

                       // Слияние локальных результатов в общие
                       foreach (var kvp in localRequestTypes)
                           requestTypes.AddOrUpdate(kvp.Key, kvp.Value, (key, oldValue) => oldValue + kvp.Value);

                       foreach (var kvp in localIpAddresses)
                           ipAddresses.AddOrUpdate(kvp.Key, kvp.Value, (key, oldValue) => oldValue + kvp.Value);

                       // Потокобезопасное обновление общего счётчика 4xx
                       lock (ipAddresses)
                       {
                           total4xxErrors += local4xxErrors;
                       }
                   });
           }
       }

       // Наиболее частый IP-адрес
       var mostFrequentIp = ipAddresses.OrderByDescending(x => x.Value).FirstOrDefault();

       // Вывод результатов
       Console.WriteLine("Анализ завершён:");
       Console.WriteLine("1. Количество запросов по типу:");
       foreach (var kvp in requestTypes)
           Console.WriteLine($"   {kvp.Key}: {kvp.Value}");
       Console.WriteLine($"2. Наиболее частый IP-адрес: {mostFrequentIp.Key} (встречался {mostFrequentIp.Value} раз).");
       Console.WriteLine($"3. Количество запросов с кодом ответа 4xx: {total4xxErrors}");
       sw.Stop();
       Console.WriteLine($"Времени затрачено: {sw.Elapsed}");
   }
   catch (Exception ex)
   {
       Console.WriteLine($"Ошибка обработки: {ex.Message}");
   }
}

// Чтение указанного количества строк из файла
static int ReadLines(StreamReader reader, string[] buffer)
{
   int count = 0;
   while (count < buffer.Length && !reader.EndOfStream)
   {
       buffer[count++] = reader.ReadLine();
   }
   return count;
}

// Разбиение данных на блоки
static IEnumerable<IEnumerable<T>> Partition<T>(IEnumerable<T> source, int blockSize)
{
   var block = new List<T>(blockSize);
   foreach (var item in source)
   {
       block.Add(item);
       if (block.Count == blockSize)
       {
           yield return block;
           block = new List<T>(blockSize);
       }
   }
   if (block.Count > 0)
       yield return block;
}