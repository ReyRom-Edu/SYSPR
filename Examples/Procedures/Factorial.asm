.686
.model flat, stdcall
.stack 4096
.data
public Factorial	;���������� ��������� ��������� ��� ������� �� ������ �������
.code
Factorial proc		;���������� !n
	enter 0,0		;������

	mov eax, [ebp + 8]  ;��������� �������� �������� n �� �����
	cmp eax, 1          
	jle end_factorial	;���� n <= 1 ��������� � ������ �� ���������

	dec eax				;��������� �������� n �� 1
	push eax			;���������� � ���� n-1
	call Factorial		;���������� �������� ��������� � ���������� n-1
						;��������� ��������� � EAX

	mul dword ptr [ebp + 8] ;���������� ���������� Factorial(n-1) * n 
							;����� ������ �� n � ����� ��������� ������� ��������
end_factorial:

	leave		;������
	ret 4		;������� ���� - ������� 4 �����, ������ �������� ���������, � ����� ����� ��������
Factorial endp
end