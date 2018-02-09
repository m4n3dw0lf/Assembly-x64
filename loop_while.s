section .data
  indexMsg db 'Input "s3cret" to stop the loop: '
  lenIndexMsg equ $-indexMsg
  newline dd 0
  key db 's3cret\n'
  input db ''

section .text
  global _start

; main
_start:
  call while

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

while:
  call print_index
  call read_input
  call print_input
  xor rdi,rdi
  xor rsi,rsi
  movzx rsi, byte [key]
  movzx rdi, byte [input]
  cmp rsi, rdi
  je _exit
  jne while

