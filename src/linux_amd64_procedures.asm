%include "include/linux_amd64_constants.asm"

section .text
	global _print_ascii_char
	global _dynamic_exit

; takes byte from rdi
; takes fd from rsi
; rax contains either 1 on success or -1 otherwise
_print_ascii_char:
	; the macros for setting up and tearing down
	; a stack frame could have been used here,
	; however, since only one byte was used and
	; the function is not that complex
	; they are not used

	; allocating one byte on the stack
	; sub rsp, 1
	dec rsp
	mov byte [rsp], dil

	mov rax, SYSCALL_WRITE
	mov rdx, 1    ; length
	mov rdi, rsi  ; fd
	mov rsi, rsp  ; pointer to byte
	syscall

	; deallocating one byte from the stack
	; add rsp, 1
	inc rsp
ret