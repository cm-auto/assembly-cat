BUFFER_SIZE equ 1024

%include "include/linux_amd64_constants.asm"
%include "include/linux_amd64_macros.asm"
%include "include/general_macros.asm"

section .rodata
    file_general_error_message db "Could not read file: "
    .length equ $ - file_general_error_message

section .data
    ; starting with 1 to skip first argument
    current_argument_index_ptr dq 1

section .bss
    buffer resb BUFFER_SIZE
    fd resq 1
    current_filename_ptr resq 1

section .text
    global _start

_start:
    ; check if any filenames were provided as arguments
    cmp qword [rsp], 1
    ; if there are more than 1 arguments,
    ; there are filenames and thus we jump to next_file
    ; (this program assumes that all provided arguments are filenames/paths)
    jg next_file

    ; otherwise we set fd to 0 (stdin)
    ; and jump to read_and_print
    xor rax, rax                         ; "mov rax, STDIN" is more readable,
                                         ; however using xor is more performant.
                                         ; In higher level languages I would
                                         ; choose the more readable approach.
                                         ; (Also modern compilers are pretty good
                                         ; in optimizing)
    mov [fd], rax
    jmp read_and_print

next_file:
    mov rcx, [current_argument_index_ptr]
    mov rax, qword [rsp + (rcx + 1) * 8]
    cmp rax, NULL
    je exit
    mov [current_filename_ptr], rax

    ; opening file
    mov rax, SYSCALL_OPEN                ; open system call
    mov rdi, [current_filename_ptr]      ; file name pointer
    mov rsi, O_RDONLY                    ; flags
    mov rdx, 0                           ; mode
    syscall

    ; check if the file opened successfully
    cmp rax, -1
    jl exit_error

    ; save the fd
    mov [fd], rax

read_and_print:
    ; read the file contents
    mov rax, SYSCALL_READ                ; read system call
    mov rdi, [fd]                        ; dereference the fd pointer
    mov rsi, buffer
    mov rdx, BUFFER_SIZE
    syscall

    ; check if 0 bytes were read
    cmp rax, 0
    je close_file

    ; print the contents of the buffer
    mov rdx, rax                         ; buffer size (length of string)
    mov rax, SYSCALL_WRITE               ; write system call
    mov rdi, STDOUT                      ; file handle (stdout)
    mov rsi, buffer                      ; buffer
    syscall

    jmp read_and_print

close_file:
    ; if fd is STDIN jmp to exit
    mov rax, [fd]
    cmp rax, STDIN
    je exit

    ; close the file
    mov rax, SYSCALL_CLOSE               ; close system call
    mov rdi, qword [fd]
    syscall

    mov rax, [current_argument_index_ptr]
    inc rax
    mov [current_argument_index_ptr], rax

    jmp next_file

exit:

    ; exit the program
    ; with code 0
    static_exit 0

exit_error:

    mov rax, SYSCALL_WRITE
    mov rdi, STDERR
    mov rsi, file_general_error_message
    mov rdx, file_general_error_message.length
    syscall

    mov rdi, [current_filename_ptr]
    call _get_length_of_c_string

    mov rdx, rax ; length
    mov rax, SYSCALL_WRITE
    mov rdi, STDERR
    mov rsi, [current_filename_ptr]
    syscall

    mov rsi, STDERR
    print_newline

    ; exit the program
    ; with code != 0, indicating an error
    static_exit 1


; takes pointer to string from rdi
; this does not check if rdi is NULL
_get_length_of_c_string:
    ; since local variables are not required
    ; in this function it will not make use
    ; of a stack frame
    xor rax, rax ; set current index to 0
    .loop_start:
        mov rsi, [rdi + rax]
        cmp sil, STRING_TERMINATING_ZERO
        jz .loop_end
        inc rax
        jmp .loop_start
    .loop_end:
ret