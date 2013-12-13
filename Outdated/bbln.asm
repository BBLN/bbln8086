;
; 1. initialization
;
@start:
; Copies bot to ES
mov si, ax
add si, (@replicate-@start)
mov cx, 10 ; @replicate is 10 bytes
rep movsw

mov bx, es
mov ds, bx
; DS IS ES
push es
mov bx, cs
; CS IS ES
;pop cs
mov es, bx
; ES IS CS

mov di, ax
add di, 256
mov ax, 0CCCCh
int 86h
int 86h

@FInitalize:
;push cx
add di, 1024

;
; 2. replicate
;
@replicate:
; Replicating code to random locations, letting bbln2 to jump around

;add di, 512
xor si, si
mov bx, di ; BX = REPLICATION START

; Copying code from ES to CS
mov cx, 10
rep movsw ; Move DS:SI to ES:DI
		  ; OR= Move DS:SI to CS:DI
		  ; OR= Move DS:SI to DS:DI

; Remember ES?
;mov es, dx
;mov bx, di
;; Save AX to ES:0
;xor di,di
; Store AX
;stosw
;mov di, bx
;add di, 256

;
; Code to replicate
;

;@attack:
;mov ax, 0CCCCh
;stosw
;jmp @attack


@attack:
mov cx, 32 ; 3
rep stosw ; 2


;@randomDI:
;pop cx
;inc cx
; n^2-n
;mov al, cl
;mul cl
;sub ax, cx

;shl ax, 1
;shl ax, 1

;add di, ax

@startAgain:
jmp bx ; Jump to replication
; 2
@end:
