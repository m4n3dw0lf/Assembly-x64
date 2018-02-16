section .bss
  s resb 8
  buf resb 32
  port resb 16
  server resb 16
section .text
  global _start
    _start:
        call main
        call exit
    main:
        push rbp
        mov rbp,rsp
        mov rdx, 0
        mov rsi, 1
        mov rdi, 2
        mov rax, 41
        syscall ; socket
        mov [s], rax
        mov word [server], 0x2
        mov ebx, 0xfeffff80
        not ebx ; "noted" 127.0.0.1
        mov dword [server+4], ebx
        mov word [port], 0x5c11 ; 4444
        movzx rax, word[port]
        mov word [server+2], ax
        mov rax, [s]
        mov rdx, 0x10
        lea rsi, [server]
        mov rdi, rax
        mov rax, 49
        syscall ; bind
        pop rsi
        push 50
        pop rax
        syscall ; listen
        push 43
        pop rax
        syscall ; accept
        ret
    exit:
        mov    rax, 60
        mov    rdi, 0
        syscall
