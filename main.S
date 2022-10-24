/**
function ABI:
PARAM:
1: di
2: si
3: dx
4: cx
5: 8
6: 9
7...: stack
RETURN:
ax

Assume everything is clobbered :D
**/

.intel_syntax noprefix

.section .data
    msg:
        .ascii "hello world\n"
.section .text
.globl main
main:
    enter 0, 0
    mov rax, 1
    mov rdi, 1
    mov rsi, offset msg
    mov rdx, 12
    syscall

    mov rdi, 10
    call string_alloc_size

    mov rax, 60
    mov rdi, 0
    syscall
    leave