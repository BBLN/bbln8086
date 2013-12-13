cpu 8086
;        -Stosw+Push happends in the head.
;        -Push pushes Int3+Movsw.
;        -the movsw falls exactly on the head, which makes the player copy the code 
;        -from the group's stack, which is the code from "stjmp" to "enjmp".
;        -the idea is that we don't need to use any counters.
;        -The "length loop", the "Jumping length", the static or "random" position - all have great influence on the behaviour and points.
%define JumpingLength 256*10 ; Jump far - 3028
%define LoopsLength 1011 ;word 0x0f3; Length loop - 1011

@start:
; Copy stjmp till enjmp to SHARED SEGMENT - ES
mov si, ax
add si, @relocate
mov cx, (@end-@relocate)/2+1
rep movsw

push cs
pop ss ; SS = CS

mov bp, JumpingLength
;mov cx, LoopsLength ; Length loop

mov di, ax ;Starts from the "Random" position.
add di, bp

push es
push ds
pop es
pop ds
; ES = DS
; DS = ES

; Two heavy bombs after our code, start loops there
mov ax, 0CCCCh
mov dx, ax
int 86h
int 86h

mov ax, 0xab53 ; stosw + push bx
mov bx, 0xcca5 ; int 3 + movsw

jmp @finishedAllocate

@relocate:
times (@end-@finishedAllocate)-2 movsw

@finishedAllocate:
add di, bp
add bp, 8

lea sp, [di-LoopsLength]
mov dx, di

@attack:
; Xoring si for next run
xor si, si

stosw ; Store AX to ES:DI, Or DS\CS:AX, write STOSW+PUSH BX
	  ; Spam stosw followed by push bx

jmp dx ; Go to head

@end: