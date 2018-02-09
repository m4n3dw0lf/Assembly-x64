section .data
  indexMsg db 'Input your name: '
  lenIndexMsg equ $-indexMsg
  endMsg db 'Nice to meet you, '
  lenEndMsg equ $-endMsg
  newline dd 0
  input db ''

section .text
  global _start

; main
_start:
  call main

; exit from program
_exit:
  push 60
  pop rax
  xor rdi, rdi
  syscall

; print indexMsg variable
print_index:
  push 1
  pop rax
  push 1
  pop rdi
  push indexMsg
  pop rsi
  push lenIndexMsg
  pop rdx
  syscall
  ret

; print endMsg variable
print_end:
  push 1
  pop rax
  push 1
  pop rdi
  push endMsg
  pop rsi
  push lenEndMsg
  pop rdx
  syscall
  ret

; read user input
read_input:
  push 0
  pop rax
  push 1
  pop rdi
  mov rsi, input
  mov rdx, 30
  syscall
  ret

print_input:
  push 1
  pop rax
  push 1
  pop rdi
  mov rsi, input
  mov rdx, 30
  syscall
  ret

; print \n
print_newline:
  push 1
  pop rax
  mov word [newline], 10
  mov rsi, newline
  push 1
  pop rdi
  push 2
  pop rdx
  syscall
  ret

main:
  call print_newline
  call print_index
  call read_input
  call print_end
  call print_input
  call print_newline
  call _exit


