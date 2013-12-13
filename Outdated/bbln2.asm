cpu 8086

%define InitalizeSize (@FInitalize-@start)
%define HalfCodeSize (@end-@FInitalize)/2+1
%define CodeSize HalfCodeSize*2
%define Attack 16
;
; 1. initialization
;
@start:
; Copies bot to ES
mov si, ax
add si, InitalizeSize
xor di, di
mov cx, CodeSize
rep movsw


push es
push cs
pop es
; ES IS CS
; DS IS ES

mov si, ax
mov di, ax
add di, 16*(CodeSize+InitalizeSize)
mov ax, 0CCCCh
mov dx, ax
int 86h
int 86h
;sub di, 2*512+CodeSize+InitalizeSize

; Bye EndOfTheWorld
mov si,0x1dfd
mov word [si],0xcccc
pop ds

@FInitalize:
sub di, 512

;
; 2. replicate
;
@replicate:
; Replicating code to "random" locations
sub di, CodeSize+16
xor si, si
mov bx, di ; BX = REPLICATION START
		   ; Copying code from ES to CS
mov cx, HalfCodeSize ; Copy only CODE
rep movsw ; Move DS:SI to ES:DI
		  ; OR= Move DS:SI to CS:DI
		  ; OR= Move DS:SI to DS:DI

;
; Code to replicate
;
@attack:
sub di, CodeSize+16
std
mov cx, Attack
rep stosw
cld

@startAgain:
jmp bx ; Jump to replication

@end:
