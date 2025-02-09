.686
.model flat, stdcall
.stack 4096
.data
public Convert3
.code
Convert3 proc		;�������������� ������������ ����� � ���������� ������
	push ebp
	mov ebp, esp		;������

	mov edi, [ebp + 8]	;��������� �� ����� ����� ������ ����������
	mov eax, [ebp + 12]	;��������� �� ����� ����� ��� �������������� � ������
	mov edx, eax		
	shr edx, 16			;����������� �������� �� EAX � �������� DX:AX ��� ������������ �������

	mov bx, 100		
	div bx				;120/100 = AX=1 DX=20
	add al, 30h			;���������� � ����������� ����� 30h - ����� �� ������� ASCII ��� �����
	stosb				;���������� ������ �� AL � �������

	mov AX, DX			;���������� �������� ������� � AX
	CWD					;��������� ������� �� DX:AX

	mov bx, 10		
	div bx				;20/10 AX=2 DX=0
	add al, 30h
	stosb

	mov AX, DX			;���������� �������� ������� � AX
	add al, 30h			
	stosb

	pop ebp		;������
	ret 8		;������� ����, ������ 8 ���� - ���������, � ����� ����� ��������
Convert3 endp
end