;���ݶ�
Data SEGMENT
     count dw 0				;��������ĸ��� 
     sum dw 0				;��������ĺ� 
     sushu db 100 dup(?)		;������� 
     
     ;0dh,0ah�ǻس������з�
     msgsushu db 'The Primes Within 100 Are :','$'			;��ʾ��������ʾ��Ϣ 
     msgcount db 0dh,0ah,'The Count Of These Primes :',0dh,0ah,'$';��ʾ������������ʾ��Ϣ 
     msgsum db 0dh,0ah,'The Sum Of These Primes Are :',0dh,0ah,'$';��ʾ�����͵���ʾ��Ϣ 
Data ENDS



;�����
code SEGMENT
     assume cs:code, ds:Data

;���������
main:
     call Calculate		;��100���������ĸ�������COUNT��Ԫ�У������ĺʹ���SUM��Ԫ�У��������������ڴ���SUSHU��ʼ�ĵ�Ԫ�� 

     lea dx,msgsushu		;��ʾ��������ʾ��Ϣ 
     mov ah,9
     int 21h
     call dispsushu		;��ʾ���� 

     lea dx,msgsum		;��ʾ�����͵���ʾ��Ϣ 
     mov ah,9 
     int 21h 
     call dispsum		;��ʾ������
     
     lea dx,msgcount		;��ʾ������������ʾ��Ϣ 
     mov ah,9
     int 21h
     call dispcount		;��ʾ��������
     
     call exit



;�����ӳ��� Calculate
Calculate proc near
     mov ax, Data
     mov ds, ax
     lea di,sushu
     mov bh,0 
     mov bl,2		;���2��100�����������������������ĺͣ�BL��2��100�仯 
next11:
     cmp bl,100
     ja tj
     mov dl,2		;���BL���ܱ�DL��2��BL-1�����Ļ�����BLΪ���� 
next12:
     cmp dl,bl
     jae next13
     mov ax,bx
     div dl
     cmp ah,0
     jz next14		;������������ 
     inc dl
     jmp next12
next13:
     inc count		;���������򽫸�����1 
     add sum,bx		;������,��ӵ����� 
     mov [di],bl	;���������������Ӧ��Ԫ�� 
     inc di
next14:
     inc bl
     jmp next11
     tj:ret
Calculate endp



;��ʾ����
dispsushu proc near
     lea si,sushu
     mov cx,count
next21:
     mov ax,count	;ÿ��10������ 
     sub ax,cx
     mov bl,10
     div bl
     cmp ah,0
     jnz next22
     mov dl,0dh		;ÿ��10����������ĩ�ӻس����� 
     mov ah,2
     int 21h
     mov dl,0ah
     mov ah,2
     int 21h
next22:
     mov bl,[si]	;ȡ��һ������ 
     mov bh,0
     call disp10	;��ʮ������ʽ��� 
     mov dl,20h		;ÿ������֮���һ���ո񣬱������� 
     mov ah,2
     int 21h
     call delay		;ÿ���һ���������������ͣ�٣���ʱ�ӳ��� 
     inc si
     loop next21
     ret
dispsushu endp



;��ʾcount
dispcount proc near
     mov bx,count	;ȡ���������� 
     call disp10	;��ʮ������ʽ��� 
     ret
dispcount endp




dispsum proc near
     mov bx,sum		;ȡ�������ĺ� 
     call disp10	;��ʮ������ʽ��� 
     ret
dispsum endp


;��BX�е�����ʮ������ʽ���
disp10 proc near
     push cx
     mov cx,1000d
     call dec_div
     mov cx,100d
     call dec_div
     mov cx,10d
     call dec_div
     mov cx,1d
     call dec_div
     pop cx
     ret
dec_div proc near
     mov ax,bx
     mov dx,0
     div cx
     mov bx,dx
     mov dl,al
     add dl,30h
     mov ah,2
     int 21h
     ret
dec_div endp
disp10 endp


;��ʱ�ӳ���
delay proc near 
     push cx
     push ax
     mov ax,60000
next1:
     mov cx,6000
next2:
     loop next2
     dec ax
     jnz next1
     pop ax
     pop cx
     ret
delay endp



;�˳�ϵͳ���ӳ���
exit proc near
      mov ah,4ch
      int 21h
exit endp

code ENDS
     END MAIN
  