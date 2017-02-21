;数据段
Data SEGMENT
     count dw 0				;存放素数的个数 
     sum dw 0				;存放素数的和 
     sushu db 100 dup(?)		;存放素数 
     
     ;0dh,0ah是回车、换行符
     msgsushu db 'The Primes Within 100 Are :','$'			;显示素数的提示信息 
     msgcount db 0dh,0ah,'The Count Of These Primes :',0dh,0ah,'$';显示素数个数的提示信息 
     msgsum db 0dh,0ah,'The Sum Of These Primes Are :',0dh,0ah,'$';显示素数和的提示信息 
Data ENDS



;代码段
code SEGMENT
     assume cs:code, ds:Data

;主程序入口
main:
     call Calculate		;将100以内素数的个数存入COUNT单元中，素数的和存入SUM单元中，并将素数存入内存自SUSHU开始的单元中 

     lea dx,msgsushu		;显示素数的提示信息 
     mov ah,9
     int 21h
     call dispsushu		;显示素数 

     lea dx,msgsum		;显示素数和的提示信息 
     mov ah,9 
     int 21h 
     call dispsum		;显示素数和
     
     lea dx,msgcount		;显示素数个数的提示信息 
     mov ah,9
     int 21h
     call dispcount		;显示素数个数
     
     call exit



;核心子程序 Calculate
Calculate proc near
     mov ax, Data
     mov ds, ax
     lea di,sushu
     mov bh,0 
     mov bl,2		;求从2到100的素数、素数个数、素数的和，BL从2到100变化 
next11:
     cmp bl,100
     ja tj
     mov dl,2		;如果BL不能被DL从2到BL-1整除的话，则BL为素数 
next12:
     cmp dl,bl
     jae next13
     mov ax,bx
     div dl
     cmp ah,0
     jz next14		;整除则不是素数 
     inc dl
     jmp next12
next13:
     inc count		;是素数，则将个数加1 
     add sum,bx		;是素数,则加到和中 
     mov [di],bl	;是素数，则存入相应单元中 
     inc di
next14:
     inc bl
     jmp next11
     tj:ret
Calculate endp



;显示素数
dispsushu proc near
     lea si,sushu
     mov cx,count
next21:
     mov ax,count	;每行10个素数 
     sub ax,cx
     mov bl,10
     div bl
     cmp ah,0
     jnz next22
     mov dl,0dh		;每行10个素数，行末加回车换行 
     mov ah,2
     int 21h
     mov dl,0ah
     mov ah,2
     int 21h
next22:
     mov bl,[si]	;取出一个素数 
     mov bh,0
     call disp10	;以十进制形式输出 
     mov dl,20h		;每个素数之间加一个空格，便于区分 
     mov ah,2
     int 21h
     call delay		;每输出一个素数都有数秒的停顿，延时子程序 
     inc si
     loop next21
     ret
dispsushu endp



;显示count
dispcount proc near
     mov bx,count	;取出素数个数 
     call disp10	;以十进制形式输出 
     ret
dispcount endp




dispsum proc near
     mov bx,sum		;取出素数的和 
     call disp10	;以十进制形式输出 
     ret
dispsum endp


;将BX中的数以十进制形式输出
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


;延时子程序
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



;退出系统的子程序
exit proc near
      mov ah,4ch
      int 21h
exit endp

code ENDS
     END MAIN
  