section .data
  request db "Hello Server!",0xa
  len_request equ $-request
  response db ''
section .bss
  socket resb 8
  buf resb 32
  port resb 16
  server resb 16
  saved resb 8
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
        mov ebx, 0xfeffff80 ; inverse of 127.0.0.1
        not ebx ; noted to become 127.0.0.1
        mov dword [server+4], ebx
        mov word [port], 0x5c11 ; 4444
        movzx rax, word[port]
        mov word [server+2], ax
        mov rax, [socket]
        mov rdx, 0x10
        lea rsi, [server]
        mov rdi, rax
        mov rax, 42
        syscall ; sys_connect
        mov rax, 1
        mov rdi, [socket] ; write destination = socket
        mov rdx, len_request
        mov rsi, request
	syscall ; sys_write
        mov rax, 0
        mov rdi, [socket] ; read destination = socket
        mov rdx, 14
        mov rsi, response
        syscall ; sys_read
        mov rax, 1
        mov rdi, 1 ; write destination != socket
        syscall ; sys_write
        mov rax, 0
        pop rbp
	ret
    exit:
	mov    rax, 60
	mov    rdi, 0
	syscall

