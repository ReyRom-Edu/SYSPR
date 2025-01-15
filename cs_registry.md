# Работа с реестром в C#

Реестр Windows (Registry) — это централизованная база данных, которая хранит конфигурационные параметры и настройки операционной системы, а также приложений. В C# доступ к реестру предоставляется через пространство имен `Microsoft.Win32`.

## Реестр: структура
Реестр представляет собой иерархическую структуру, которая состоит из:
- **Ключей (Keys)**: аналогичны папкам в файловой системе.
- **Подключей (Subkeys)**: вложенные ключи.
- **Значений (Values)**: содержат данные.

### Основные корневые ключи:
1. `HKEY_CLASSES_ROOT` (HKCR): хранит информацию об используемых в ОС файлх, какие программы открывают те или иные типы файлов, а также информацию о компонентах COM.
2. `HKEY_CURRENT_USER` (HKCU): конфигурация текущего пользователя.
3. `HKEY_LOCAL_MACHINE` (HKLM): параметры всей системы, информация о всех установленных программах.
4. `HKEY_USERS` (HKU): информация и настройки для всех пользователей.
5. `HKEY_CURRENT_CONFIG` (HKCC): текущая конфигурация оборудования.
6. `HKEY_DYN_DATA` (HKDD): хранит различные текущие данные.
7. `HKEY_PERFORMANCE_DATA` (HKPD): хранит информацию о производительности приложений.

---

## Основные классы для работы с реестром

### Registry
Статический класс, содержащий еще ряд статических свойств, каждое из которых представляет соответствующий ключ верхнего уровня:
- `Registry.ClassesRoot`
- `Registry.CurrentConfig`
- `Registry.CurrentUser`
- `Registry.DynData`
- `Registry.Users`
- `Registry.PerformanceData`

### RegistryKey
Класс для работы с ключами реестра. Позволяет создавать, читать, изменять и удалять ключи и значения.

### Методы класса `RegistryKey`:
- `OpenSubKey(string name, bool writable = false)`: открытие подключа.
- `Close()`: закрытие ключа
- `CreateSubKey(string name)`: создание подключа.
- `DeleteSubKey(string name)`: удаление подключа.
- `GetValue(string name)`: получение значения.
- `SetValue(string name, object value)`: установка значения.
- `DeleteValue(string name)`: удаление значения.

---

### Примеры кода

Рассмотрим пример, в котором сохраняются пользовательские настройки приложения, такие как цветовая тема и уровень громкости, в реестре. При последующем запуске приложения эти настройки будут загружены.

```csharp
using Microsoft.Win32;

class Program
{
    private const string RegistryPath = "Software\\MyApplication";

    static void Main()
    {
        // Сохранение настроек в реестр
        SaveSettings("Dark", 75);

        // Загрузка настроек из реестра
        LoadSettings();
    }

    static void SaveSettings(string theme, int volume)
    {
        using (RegistryKey key = Registry.CurrentUser.CreateSubKey(RegistryPath))
        {
            key.SetValue("Theme", theme);
            key.SetValue("Volume", volume);
            Console.WriteLine("Настройки сохранены: Тема - {0}, Громкость - {1}", theme, volume);
        }
    }

    static void LoadSettings()
    {
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath))
        {
            if (key != null)
            {
                string theme = key.GetValue("Theme", "Default").ToString();
                int volume = (int)key.GetValue("Volume", 50);

                Console.WriteLine("Настройки загружены: Тема - {0}, Громкость - {1}", theme, volume);
            }
            else
            {
                Console.WriteLine("Настройки не найдены, используем значения по умолчанию.");
            }
        }
    }
}
```

#### Удаление настроек приложения
Для удаления настроек из реестра можно использовать следующий код:

```csharp
static void DeleteSettings()
{
    Registry.CurrentUser.DeleteSubKey("Software\\MyApplication", throwOnMissingSubKey: false);
    Console.WriteLine("Настройки приложения удалены.");
}
```

---

### Важные замечания
1. **Права доступа:** Некоторые операции требуют прав администратора. Например, запись в `HKEY_LOCAL_MACHINE` может быть ограничена.
2. **Обработка ошибок:** Используйте блоки `try-catch` для обработки исключений, таких как `UnauthorizedAccessException` или `SecurityException`.
3. **Чистота кода:** Всегда используйте `using` для работы с объектами `RegistryKey`, чтобы гарантировать освобождение ресурсов.

---

### Заключение
Реестр — мощный инструмент для хранения конфигурационных данных. Однако работать с ним нужно осторожно, чтобы избежать случайного удаления или изменения критически важных параметров системы. Использование классов `Registry` и `RegistryKey` в C# упрощает взаимодействие с реестром, делая его интуитивно понятным и удобным для разработчиков.

