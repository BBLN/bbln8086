;
; 1. initialization
;
@start:
;mov bx, ax               ; on startup, AX holds our load-address
;add bx, (@end - @start)  ; BX is now the first offset after our own code

mov bx, cs
mov es, bx ; Set es to cs - BOMBS
mov bx, es
mov ds, bx ; Set ds to es - SHARED

mov ax, 0CCCCh             ; AL = our bomb data (0xCC, see above)
mov dx, ax
mov cx, 16

;
; 2. Heavy bomb
;
@smartBomb:
int 86h
;add di, 256; Push di 256 bytes
int 86h
;jmp @finishedBombs

@finishedBombs:
;lodsw ; Loads es:si (ds=es) to ax
;jmp ax
; Reload ES


;
; 3. bombing loop
;
@attack:
wait
dec cx
cmp cx,0 
jnz @attack
; WE DONT REALLY NEED DSs
xor si, si
lodsw ; Load (ds)es:si to ax
mov bx, ax
jmp bx ; Jump to replication
jmp @attack

@end:
