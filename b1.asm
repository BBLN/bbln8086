cpu 8086
;        -Stosw+Push happends in the head.
;        -Push pushes Int3+Movsw.
;        -the movsw falls exactly on the head, which makes the player copy the code 
;        -from the group's stack, which is the code from "stjmp" to "enjmp".
;        -the idea is that we don't need to use any counters.
;        -The "length loop", the "Jumping length", the static or "random" position - all have great influence on the behaviour and points.
%define JumpingLength 256*35 ; Jump far - 3028
%define LoopsLength 1011 ;word 0x0f3; Length loop - 1011

@start:
; Copy stjmp till enjmp to SHARED SEGMENT - ES
mov si, ax
add si, @relocate
mov cx, (@end-@relocate)/2+1
rep movsw

mov di, ax
lea bp, [di-JumpingLength] ; Bit of randomness

mov ax, 0CCCCh
mov dx, ax

push cs
push es
push ds
pop es
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

mov ax, 0xab53 ; stosw + push bx
mov bx, 0xcca5 ; int 3 + movsw

xor si, si
mov dx, di
movsw
jmp dx

@relocate:
movsw
movsw
movsw
movsw
movsw
add di, bp
mov dx,	di
movsw
jmp dx
times (@end-@finishedAllocate)-2 movsw

@finishedAllocate:
add bp, 256

lea sp, [di+LoopsLength]

@attack:
; Xoring si for next run
xor si, si

stosw ; Store AX to ES:DI, Or DS\CS:AX, write STOSW+PUSH BX
	  ; Spam stosw followed by push bx

@end: