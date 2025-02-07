
#### 2. Определение и вызов процедур  
Процедуры в MASM определяются с использованием директивы `PROC`, а завершаются директивой `ENDP`. Общий синтаксис:  
```assembly
имя_процедуры PROC [список параметров]
    ; тело процедуры
    RET
имя_процедуры ENDP
```
Процедура вызывается с помощью инструкции `CALL`.  

Пример простой процедуры без параметров:
```assembly
PrintMessage PROC
    mov  dx, OFFSET message   ; Загружаем адрес строки
    mov  ah, 09h              ; Функция DOS: вывод строки
    int  21h
    RET
PrintMessage ENDP

message DB 'Hello, MASM!', '$'
```

#### 3. Передача параметров  
Параметры можно передавать в процедуры различными способами:  
1. Через регистры  
2. Через стек  

##### 3.1. Передача параметров через регистры  
Этот метод удобен для небольшого количества параметров.  
Пример:
```assembly
Sum PROC
    add  ax, bx
    RET
Sum ENDP
```
Вызов процедуры:
```assembly
mov ax, 5
mov bx, 10
call Sum  ; AX = 5 + 10 = 15
```

##### 3.2. Передача параметров через стек  
Используется, если параметров много или требуется сохранить их значения после вызова.  
Пример:
```assembly
Sum PROC
    push bp
    mov bp, sp  ; Устанавливаем указатель стека
    mov ax, [bp+4]  ; Загружаем первый аргумент
    add ax, [bp+6]  ; Прибавляем второй аргумент
    pop bp
    RET
Sum ENDP
```
Вызов процедуры:
```assembly
push 5
push 10
call Sum
add sp, 4  ; Освобождаем стек
```

#### 4. Локальные переменные  
Локальные переменные создаются в стеке с помощью `SUB` и `ADD` или директив `LOCAL`.  
Пример:
```assembly
Sum PROC
    push bp
    mov bp, sp
    sub sp, 2  ; Выделяем 2 байта для локальной переменной
    mov [bp-2], ax  ; Используем её
    add sp, 2  ; Освобождаем стек
    pop bp
    RET
Sum ENDP
```

#### 5. Процедуры с возвратом значений  
Обычно возвращаемое значение помещается в регистр `AX`.  
Пример:
```assembly
Multiply PROC
    mov ax, [bp+4]
    imul ax, [bp+6]
    RET
Multiply ENDP
```

#### 6. Рекурсивные процедуры  
MASM поддерживает рекурсивные вызовы, но важно следить за стеком.  
Пример факториала:
```assembly
Factorial PROC
    push bp
    mov bp, sp
    mov ax, [bp+4]
    cmp ax, 1
    jle end_factorial
    dec ax
    push ax
    call Factorial
    add sp, 2
    mul word ptr [bp+4]
end_factorial:
    pop bp
    RET
Factorial ENDP
```
