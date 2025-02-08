.686
.model flat, stdcall
.stack 4096
.data
public Convert
.code
Convert proc		;Преобразование трехзначного числа в символьную строку
	push ebp
	mov ebp, esp		;пролог

	mov edi, [ebp + 8]	;загружаем из стека адрес строки назначения
	mov eax, [ebp + 12]	;загружаем из стека число для преобразования в строку
	mov edx, eax		
	shr edx, 16			;преобразуем значение из EAX в значение DX:AX для последующего деления

	mov bx, 100		
	div bx				;120/100 = AX=1 DX=20
	add al, 30h			;прибавляем к полученному числу 30h - сдвиг по таблице ASCII для чисел
	stosb				;записываем символ из AL в цепочку

	mov AX, DX			;записываем значение остатка в AX
	CWD					;расширяем операнд до DX:AX

	mov bx, 10		
	div bx				;20/10 AX=2 DX=0
	add al, 30h
	stosb

	mov AX, DX			;записываем значение остатка в AX
	add al, 30h			
	stosb

	pop ebp		;эпилог
	ret 8		;очищаем стек, удаляя 8 байт - параметры, а также адрес возврата
Convert endp
end