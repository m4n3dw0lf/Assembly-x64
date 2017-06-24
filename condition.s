section .data ; constants

	intro 		db "Testing two numbers", 0xa
	len_intro	equ $- intro

	input1		db "number 1: "
	len_input1	equ $- input1

	input2		db "number 2: "
	len_input2	equ $- input2

	equalstr        db "the numbers are equal", 0xa
	len_equalstr    equ $- equalstr

	nequalstr       db "the numbers are not equal", 0xa
	len_nequalstr   equ $- nequalstr

	result 		db "result: "
	len_result	equ $- result

segment .bss ; variables
	number1 resb 10
	number2 resb 10

section .text ; declare the first function to execute
	global _start

newline:
	mov rax, 1
	mov rdi, 1
	mov rsi, 0xa
	mov rdx, 2
	syscall
	ret

equal:
	mov rax, 1
	mov rdi, 1
	mov rsi, equalstr
	mov rdx, len_equalstr
	syscall
	call newline
	call _exit

notequal:
	mov rax, 1
	mov rdi, 1
	mov rsi, nequalstr
	mov rdx, len_nequalstr
	syscall
	call newline
	call _exit

_exit:
	; exit
	mov rax,60
	mov rdi, 0
	syscall

_start:
	; print intro constat
	mov rax, 1
	mov rdi, 1
	mov rsi, intro
	mov rdx, len_intro
	syscall

	; print input1 constant
	mov rax, 1
	mov rdi, 1
	mov rsi, input1
	mov rdx, len_input1
	syscall

	; read user input and assign into number1 variable
	mov rax, 0
	mov rdi, 1
	mov rsi, number1
	mov rdx, 10
	syscall

	call newline

	; print input2 constant
	mov rax, 1
	mov rdi, 1
	mov rsi, input2
	mov rdx, len_input2
	syscall

	; read user input and assign into number2 variable
	mov rax, 0
	mov rdi, 1
	mov rsi, number2
	mov rdx, 10
	syscall

	call newline

	; print result constant
	mov rax, 1
	mov rdi, 1
	mov rsi, result
	mov rdx, len_result
	syscall

	; compare number1 and number2 variables and tell if they are equal or not
	movzx rsi, byte [number1]
	movzx rdi, byte [number2]
	cmp rsi, rdi
	je equal
	jmp notequal



