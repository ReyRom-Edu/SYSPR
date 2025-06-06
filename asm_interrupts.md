**Лекция: Прерывания в MASM**

## 1. Введение в прерывания
Прерывание — это механизм, позволяющий процессору временно приостановить выполнение текущей программы и передать управление специальной обработке события. После завершения обработки выполнение программы возобновляется с того места, где было прервано.

Прерывания бывают:
- Внутренние (системные)
- Внешние (аппаратные)
- Программные

## 2. Виды прерываний
### 2.1. Внутренние прерывания
Эти прерывания возникают при выполнении процессором определённых команд или при возникновении исключительных ситуаций (например, деление на ноль).

Примеры:
- Деление на ноль (INT 0)
- Ошибка защиты памяти

### 2.2. Аппаратные прерывания
Инициируются внешними устройствами (клавиатура, таймер, жесткий диск). Обработкой таких прерываний занимается контроллер прерываний (PIC — Programmable Interrupt Controller).

Пример:
- Прерывание от клавиатуры (IRQ 1)

### 2.3. Программные прерывания
Вызываются программно с помощью команды `INT n`, где `n` — номер прерывания.

Пример:
```assembly
mov ah, 09h
mov dx, offset msg
int 21h  ; Вызов DOS-прерывания для вывода строки
```

## 3. Таблица векторов прерываний
При запуске системы создаётся таблица векторов прерываний (IVT — Interrupt Vector Table), содержащая адреса обработчиков. Таблица занимает первые 1024 байта памяти (256 записей по 4 байта).

## 4. Программные прерывания в DOS
В среде DOS часто используются прерывания `INT 21h` для работы с файлами, вводом-выводом и памятью.

Примеры:
- `INT 21h, AH=09h` — вывод строки
- `INT 21h, AH=4Ch` — завершение программы

Пример программы с использованием `INT 21h`:
```assembly
.model small
.stack 100h
.data
msg db 'Hello, world!$'
.code
main proc
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg
    int 21h  ; Вызов DOS-прерывания
    mov ah, 4Ch
    int 21h  ; Завершение программы
main endp
end main
```

## 5. Обработчики прерываний
Обработчик прерывания — это специальная подпрограмма, выполняющаяся при возникновении прерывания. Обычно он сохраняет регистры, выполняет нужные действия и восстанавливает состояние системы.

Пример собственного обработчика:
```assembly
org 100h
jmp start

my_handler proc far
    push ax
    mov ah, 09h
    mov dx, offset msg
    int 21h
    pop ax
    iret
my_handler endp

start:
    cli
    mov ax, 0
    mov es, ax
    mov word ptr es:[4 * 9], offset my_handler
    mov word ptr es:[4 * 9 + 2], cs
    sti
    hlt  ; Ожидание прерывания

msg db 'Клавиша нажата!$'
end start
```

## 6. Заключение
Прерывания являются важным механизмом в архитектуре x86, обеспечивающим обработку событий и взаимодействие с аппаратными средствами. В MASM их можно использовать как для системных вызовов, так и для создания собственных обработчиков.

