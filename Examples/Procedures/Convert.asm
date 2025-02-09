.686
.model flat, stdcall
.stack 4096
.data

public Convert
.code
Convert proc		;Преобразование 32-битного десятичного числа в символьную строку
	enter 0,0		;пролог

	mov edi, [ebp + 8]	;загружаем из стека адрес строки назначения
	mov eax, [ebp + 12]	;загружаем из стека число для преобразования в строку
	
	mov edx, eax		
	shr edx, 16			;преобразуем значение из EAX в значение DX:AX для последующего деления
	
	mov bx, 10			;записываем в BX делитель 10
	mov ecx, 0			;устанавливаем счетчик в 0
convert_loop:
	cmp eax, 0
	je convert_loop_end	;Пока результат деления не равен 0

	div bx				;делим EAX на 10
	
	add dl, 30h			;прибавляем к полученному числу 30h - сдвиг по таблице ASCII для чисел
	push dx				;записываем символ в стек
	inc ecx				;увеличиваем счетчик символов
	CWD					;расширяем операнд до DX:AX	
	jmp convert_loop
convert_loop_end:

load_loop:
	pop ax				;получаем символ из стека
	stosb				;записываем символ в стрку
	loop load_loop

	leave	;эпилог
	ret 8		;очищаем стек, удаляя 8 байт - параметры, а также адрес возврата
Convert endp
end