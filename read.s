section .data                           ;Data segment
   userMsg db 'Please enter a number: ' ;Ask the user to enter a number
   lenUserMsg equ $-userMsg             ;The length of the message
   dispMsg db 'You have entered: '
   lenDispMsg equ $-dispMsg
   newline db 0xa

section .bss           ;Uninitialized data
   num resb 100

section .text          ;Code Segment
   global _start

_start:                ;User prompt

   mov     rax, 1
   mov     rdi, 1
   mov     rsi, userMsg
   mov     rdx, lenUserMsg
   syscall

   ;Read and store the user input
   mov rax, 3
   mov rbx, 2
   mov rcx, num
   mov rdx, 100          ;10 bytes (numeric, 1 for sign) of that information
   int 80h

   ;Output the message 'The entered number is: '
   mov     rax, 1
   mov     rdi, 1
   mov     rsi, dispMsg
   mov     rdx, lenDispMsg
   syscall

   ;Output the number entered
   mov     rax, 1
   mov     rdi, 1
   mov     rsi, num
   mov     rdx, 100
   syscall

   mov     rax, 1
   mov     rdi, 1
   mov     rsi, newline
   mov     rdx, 3
   syscall

   ; Exit code
   mov rax, 1
   mov rbx, 0
   int 80h
