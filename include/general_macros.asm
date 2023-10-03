%macro set_up_stack_frame 1
    push    rbp
    mov     rbp, rsp
    sub     rsp, %1
%endmacro

%macro tear_down_stack_frame 1
    add     rsp, %1
    pop     rbp
%endmacro

NULL equ 0
STRING_TERMINATING_ZERO equ `\0`