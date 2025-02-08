.686
.model flat, stdcall
.stack 4096
.data
	;данные для MessageBox
	MB_OK equ 0
	header db "Factorial",0
	HW dd ?
	;цепочка заполненная нулями для хранения строки
	buffer db 10 dup(0)
	;подключение процедур из внешних модулей
	EXTERN MessageBoxA@16: NEAR
	EXTERN Factorial@0: NEAR
	EXTERN Convert@0: NEAR
.code

start:

	push 5
	call Factorial@0	;вызываем процедуру для вычисления факториала числа 5


	push eax			;записываем в стек вычисленное значение факториала из eax
	push offset buffer	;записываем ссылку на строку-буфер в стек
	call Convert@0		;вызываем процедуру для преобразования числа в строку


	push MB_OK			
	push offset header
	push offset buffer
	push HW
	call MessageBoxA@16 ;вызываем системную процедуру для отображения окна сообщения
	ret
end start