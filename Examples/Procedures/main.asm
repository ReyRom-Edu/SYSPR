.686
.model flat, stdcall
.stack 4096
.data
	;������ ��� MessageBox
	MB_OK equ 0
	header db "Factorial",0
	HW dd ?
	;������� ����������� ������ ��� �������� ������
	buffer db 10 dup(0)
	;����������� �������� �� ������� �������
	EXTERN MessageBoxA@16: NEAR
	EXTERN Factorial@0: NEAR
	EXTERN Convert@0: NEAR
.code

start:

	push 5
	call Factorial@0	;�������� ��������� ��� ���������� ���������� ����� 5


	push eax			;���������� � ���� ����������� �������� ���������� �� eax
	push offset buffer	;���������� ������ �� ������-����� � ����
	call Convert@0		;�������� ��������� ��� �������������� ����� � ������


	push MB_OK			
	push offset header
	push offset buffer
	push HW
	call MessageBoxA@16 ;�������� ��������� ��������� ��� ����������� ���� ���������
	ret
end start