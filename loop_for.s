section .data
  number dd 0
  newline dd 0
  END equ 10

section .bss
  numbuf resb 10

section .text
  global _start

_start:
  call for

_exit:
  push 60
  pop rax
  xor rdi, rdi
  syscall

for:
  call print_counter           ;call function that prints the counter
  inc rbx                      ;increment counter
  cmp rbx, END                 ;compare counter with END variable declared at .data (i=0; i<END; i++) 
  je _exit                     ;exit when condition has been reached
  jne for                      ;repeat untill condition is not reached

print_counter:
  mov [number], rbx             ;save number as decimal
  mov rdi, [number]             ;rdi = number
  call itoa                     ;itoa()

  mov rsi, rax                  ;print counter
  mov rax, 1
  mov rdi, 1
  mov rdx, 10
  syscall

  mov rax, 1                    ;print \n
  mov word [newline], 10
  mov rsi, newline
  mov rdi, 1
  mov rdx, 10
  syscall

  ret                           ; return to for loop

itoa:                         ;rdi has the integer to transform to ascii
    push rbp
    mov rbp,rsp
    sub rsp,4
    mov rax,rdi
    lea rdi,[numbuf+10]
    mov rcx,10
    mov [rbp-4],dword 0
    call itoa_loop
    ret

itoa_loop:
    xor rdx,rdx
    idiv rcx                  ;split integer greater than 2bytes to prevent (0x39 + 0x1) == 0x40 == ascii ':'
    add rdx,0x30              ;ascii transformation e.g: (0x1 + 0x30) == 0x31 == ascii '1'
    dec rdi
    mov byte [rdi],dl
    inc dword [rbp-4]
    cmp rax,0
    jnz itoa_loop
    mov rax,rdi
    mov rcx,[rbp-4]
    leave
    ret

