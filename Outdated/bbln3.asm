;
; 1. initialization
;
@start:
push es
push ax
mov bx, ax               ; on startup, AX holds our load-address
add bx, (@end - @start)  ; BX is now the first offset after our own code
; BBLN2 Finished writing bx, DON'T HURT HIM es:di
; Calculate bx

@calc:
mov ax, 0CCCCh             ; AL = our bomb data (0xCC, see above)
mov cx, 2
jmp @smartBomb

;
; 2. bombing loop
;
@attack:
mov [bx], ax             ; write the value in AL to the offset BX points to
add bx, 8                ; add our bombing jump size to BX (we use a jump size
                         ; of 20 bytes, since it's longer than our code size and
                         ; divides with the arena's size. think why ... :)
mov cx, 10
add di, 1024
mov ax, cs
mov es, ax
mov ax, 0CCCCh
@stringBomb:

stosw
dec cx
cmp cx, 0
jz @attack
jmp @stringBomb

;
; 3. Heavy bomb
;
@smartBomb:
mov ax, cs
mov es, ax

mov ax, 0CCCCh
mov dx, ax

int 86h

add di, 512; Push di a little
dec cx
cmp cx, 0
jnz @smartBomb
xor di, di
jmp @attack

@end:
