%ifndef _LINUX_AMD64_MACROS
%define _LINUX_AMD64_MACROS

%include "include/linux_amd64_constants.asm"

extern _print_ascii_char

; was a procedure first, however, since
; it only has two instructions, I decided to
; make it a macro, too
; takes the exit code from rdi register
%macro dynamic_exit 0
	mov rax, SYSCALL_EXIT
	syscall
%endmacro

%macro static_exit 1
	mov rdi, %1
	dynamic_exit
%endmacro

; adds 48 ('0') to rdi and prints it
; takes digit from rdi
; takes fd from rsi
%macro print_digit 0
	add rdi, 48
	call _print_ascii_char
%endmacro

; takes character as argument
; takes fd from rsi
%macro static_print_ascii_char 1
	mov rdi, %1
	call _print_ascii_char
%endmacro

; takes fd from rsi
%macro print_newline 0
	mov rdi, 10
	call _print_ascii_char
%endmacro


%endif ; _LINUX_AMD64_MACROS