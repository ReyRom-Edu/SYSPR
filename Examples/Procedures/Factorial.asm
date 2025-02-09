.686
.model flat, stdcall
.stack 4096
.data
public Factorial	;определ€ем процедуру публичной дл€ доступа из других модулей
.code
Factorial proc		;¬ычисление !n
	enter 0,0		;пролог

	mov eax, [ebp + 8]  ;загружаем значение парамтра n из стека
	cmp eax, 1          
	jle end_factorial	;если n <= 1 переходим к выходу из процедуры

	dec eax				;уменьшаем значение n на 1
	push eax			;записываем в стек n-1
	call Factorial		;рекурсивно вызываем процедуру с параметром n-1
						;результат процедуры в EAX

	mul dword ptr [ebp + 8] ;производим вычисление Factorial(n-1) * n 
							;через ссылку на n с €вным указанием размера операнда
end_factorial:

	leave		;эпилог
	ret 4		;очищаем стек - удал€ем 4 байта, коорые занимали параметры, а также адрес возврата
Factorial endp
end