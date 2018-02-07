;initialized data
section .data
							;newline\n
  msg_missArg db "[-] Number of arguments not equal 3.",0xa
		       ;$ = current address - start of msg_missArg = msg_missArg length
  len_msg_missArg equ $-msg_missArg
  							;newline\n
  msg_Success db "[+] Number of arguments are equal 3.",0xa
		       ;$ = current address - start of msg_Success = msg_Success length
  len_msg_Success equ $-msg_Success

;code section
section .text
  ;necessary for elf
  global _start
    	;when function _start is called, the stack look like this:
    	;[rsp] - top of stack: arguments count.
    	;[rsp + 8]  - file path
    	;[rsp + 16] - argv[0]
    	;[rsp + 24] - argv[1]
	_start:
    		;pop the top of stack (number of arguments) into the rcx register
    		pop rcx
    		;compare register rcx with 3 to check if the number of parameters are correct
    		cmp rcx, 3
    		;jump for missArg function if comparsion of rcx with 3 fails
    		jne _missArg
    		;jump for _success function if comparsion of rcx with 3 succeed
    		call _success

	;function that print msg_Success with syscall 1 and call exit function
	_success:
		;rax = syscall number (1 = sys_write)
		mov rax,1
		;rdi = unsigned int (xor avoid nullbytes)
		xor rdi, rdi
		;rsi = data (msg_Success constant)
		mov rsi, msg_Success
		;rdx = length of string
		mov rdx, len_msg_Success
		;call the kernel
		syscall
		;call _exit function
		call _exit

	;function that prints msg_missArg with syscall 1 and call exit function
	_missArg:
		;rax = syscall number (1 = sys_write)
		mov rax, 1
		;rdi = unsigned int (xor avoid nullbytes)
		xor rdi, rdi
		;rsi = data (msg_missArg constant)
		mov rsi, msg_missArg
		;rdx = length of string
		mov rdx, len_msg_missArg
		;call the kernel
		syscall
		;call _exit function
		call _exit

	;call syscall 60 for exiting without segmentation fault
	_exit:
		;rax = syscall number (60 = exit)
		mov rax, 60
		;rdi = error code
		mov rdi, 0
		;call the kernel
		syscall
