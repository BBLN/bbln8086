cpu 8086
;        -Stosw+Push happends in the head.
;        -Push pushes Int3+Movsw.
;        -the movsw falls exactly on the head, which makes the player copy the code 
;        -from the group's stack, which is the code from "stjmp" to "enjmp".
;        -the idea is that we don't need to use any counters.
;        -The "length loop", the "Jumping length", the static or "random" position - all have great influence on the behaviour and points.
%define JumpingLength 256*34 ; Jump far - 3028

%macro kill 1
	mov si, %1
	mov word [si], ax
%endmacro

@start:
mov di, ax
lea bp, [di-JumpingLength] ; Bit of randomness

mov ax, 0CCCCh
mov dx, ax

push cs
push es
push ds
pop es
kill 0x1dfd
kill 0x1f0
kill 0xece9
pop ds
pop ss
; ES = DS
; SS = CS

; Two heavy bombs after our code, start loops there
std
int 86h
int 86h
cld
add di, bp

; Kill RAIDEN
;mov bx, 0x90A5
;mov cx, 0xA5A5
;xchg bx, ax
;xchg cx, dx
;int 87h

NRG: times 4 DB 0x9B

mov ax, 0xab53 ; stosw + push bx
mov bx, 0xcca5 ; int 3 + movsw

; Bye Bye EndOfTheWorld
;mov si,0xece9
;mov word [si],0xcccc

xor si, si
mov dx, di
movsw
jmp dx

@end: