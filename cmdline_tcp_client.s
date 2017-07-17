;# Copyright (c) 2016-2017 Angelo Moura
;#
;# This file is part of the repository: https://github.com/m4n3dw0lf/Assembly-Collection
;#
;#
;# this assembly code is free software; you can redistribute it and/or
;# modify it under the terms of the GNU General Public License as
;# published by the Free Software Foundation; either version 3 of the
;# License, or (at your option) any later version.
;#
;# This program is distributed in the hope that it will be useful, but
;# WITHOUT ANY WARRANTY; without even the implied warranty of
;# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;# General Public License for more details.
;# You should have received a copy of the GNU General Public License
;# along with this program; if not, write to the Free Software
;# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
;# USA

section .data
  msg_missArg db 0xa,"[!] usage: ./socket <SERVER-IP> <PORT>",0xa,"[*] example: ./socket 192.168.1.5 4444",0xa,0xa
  len_missArg equ $-msg_missArg
  msg_success db 0xa,"[+] Success, a connection has been established",0xa,0xa
  len_success equ $-msg_success
  msg_error db 0xa,"[-] Error, a connection can't be established",0xa,0xa
  len_error equ $-msg_error

section .bss
  s resb 8
  buf resb 32
  port resb 16
  server resb 16
  OCTET_1 resb 1
  OCTET_2 resb 1
  OCTET_3 resb 1
  OCTET_4 resb 1
  SERVER_IP resb 4
  PORT resb 2


section .text
  global _start
    _start:
	pop rcx
	cmp rcx, 3 ; check if have 6 arguments
	jne missArg ; exit if doesn't
	pop rbx ; discarding file path
	xor rbx, rbx ; clean register

	;split the IP into 4 Octets
	pop rdx
	call atoi ; ascii2string
	xor rdx, rdx
	mov [OCTET_1], rax
	pop rdx
	call atoi ; ascii2string
	xor rdx, rdx
	mov [OCTET_2], rax
	pop rdx
	call atoi ; ascii2string
	xor rdx, rdx
	mov [OCTET_3], rax
	pop rdx
	call atoi ; ascii2string
	xor rdx, rdx
	mov [OCTET_4], rax

	;build the IP Address offset
	xor rbx, rbx
	mov rbx, [OCTET_4]
	mov [SERVER_IP], rbx ;
	mov rbx, [OCTET_3]
	mov [SERVER_IP], rbx ;
	mov rbx, [OCTET_2]
	mov [SERVER_IP], rbx ;
	mov rbx, [OCTET_1]
	mov [SERVER_IP], rbx ;
	xor rbx, rbx

	;swap port to little endianess and assign to PORT variable
	pop rdx; port Address
	bswap rax
	call atoi ; ascii2string
	xchg ah, al
	mov [PORT], rax

	;call main to create the socket and connect to target
        call main
	;exit from 
	call exit

    ; transform ASCII to STRING
    atoi:
	xor rax, rax
      .top:
	movzx rcx, byte [rdx]
	inc rdx
	cmp rcx, 0x2e
	je .dot
	cmp rcx, 0x0
	je .finish
	cmp rcx, '0'
	jb .done
	cmp rcx, '9'
	ja .done
	jmp .do
      .dot:
	mov [rsp+8], rdx
	jmp .done
      .finish:
	mov [rsp+8], rdx
	jmp .done
      .do:
	sub rcx, '0'
	imul rax, 10
	add rax, rcx
	jmp .top
      .done:
	ret

    missArg:
	mov rax, 1
	xor rdi, rdi
	mov rsi, msg_missArg
	mov rdx, len_missArg
	syscall
	call exit
    ;build a TCP socket with syscalls socket&connect to connect to a remote server
    main:
        push rbp
        mov rbp,rsp
        mov rdx, 0
        mov rsi, 1
        mov rdi, 2
        mov rax, 41 ; sys_socket
        syscall
        mov [s], rax
        mov word [server], 0x2 ;
	mov rbx, [SERVER_IP]
        mov [server+4], rbx ; IP Address
	xor rbx, rbx
	mov rbx, [PORT]
        mov [port], rbx; Port
        movzx rax, word [port]
        mov word [server+2], ax
        mov rax, [s]
        mov rdx, 0x10
        lea rsi, [server]; 0x|IPADDR|PORT_w/0extended|2 / e.g 0x|501a8c0|5c11000|2 / 0x501a8c05c110002
        mov rdi, rax
        mov rax, 42 ; sys_connect
        syscall
	cmp rax, 0
	jne error
	je success
    error:
	mov rax, 1
	xor rdi, rdi
	mov rsi, msg_error
	mov rdx, len_error
	syscall
	call exit
    success:
	mov rax, 1
	xor rdi, rdi
	mov rsi, msg_success
	mov rdx, len_success
	syscall
	call exit
    exit:
	mov    rax, 60
	mov    rdi, 0
	syscall

