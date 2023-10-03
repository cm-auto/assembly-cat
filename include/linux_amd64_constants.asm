%ifndef _LINUX_AMD64_CONSTANTS
%define _LINUX_AMD64_CONSTANTS

STDIN equ 0
STDOUT equ 1
STDERR equ 2

; syscalls
SYSCALL_READ equ 0
SYSCALL_WRITE equ 1
SYSCALL_OPEN equ 2
SYSCALL_CLOSE equ 3
SYSCALL_EXIT equ 60
; syscalls

; file flags
O_RDONLY equ 0
; file flags

%endif ; _LINUX_AMD64_CONSTANTS