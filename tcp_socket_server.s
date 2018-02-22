section .data
  response db 'Hello Client!',0xa
  len_response equ $-response
  buf db ''
section .bss
  socket resb 8
  port resb 16
  server resb 16
  client resb 16
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
        syscall ; sys_socket
        mov [socket], rax
        mov word [server], 0x2
        mov ebx, 0xfeffff80 ; noted 127.0.0.1
        not ebx
        mov dword [server+4], ebx
        mov word [port], 0x5c11 ; 4444
        movzx rax, word[port]
        mov word [server+2], ax
        mov rax, [socket]
        mov rdx, 0x10
        lea rsi, [server] ; load server structure
        mov rdi, rax
        mov [client], rdi
        push 49
        pop rax
        syscall ; sys_bind
        pop rsi
        push 50
        pop rax
        syscall ; sys_listen
        mov rax, 43
        syscall ; sys_accept
        mov rdi, rax
        mov r8d, eax
        mov rax, 0
        mov rdx, 14
        mov rsi, buf
        syscall ; sys_read
        mov rax, 1
        mov rdi, 1
        mov rsi, buf
        mov rdx, 14
        syscall ; sys_write (local)
        mov rsi, 0
        mov rax, 1
        mov rdi, r8
        mov rsi, response
        mov rdx, len_response
        syscall ; sys_write (remote)
    exit:
        mov    rax, 60
        mov    rdi, 0
        syscall

