.intel_syntax noprefix
.section .data
.set CALL_MMAP, 9

.set PROT_NONE, 0x0
.set PROT_READ, 0x1
.set PROT_WRITE, 0x2
.set PROT_EXEC, 0x4

.set MAP_SHARED, 0x01
.set MAP_PRIVATE, 0x02
.set MAP_ANON, 0x20

.section .text
.global alloc_malloc
alloc_malloc:
  enter 0,0
  /*
  mmap(
    rdi: 0,
    rsi: size (rdi),
    rdx: PROT_READ|PROT_WRITE,
    rcx: MAP_PRIVATE|MAP_ANON,
    r8d: -1,
    r9d: 0)
  */
  mov rsi, rdi
  mov rdi, 0

  mov edx, PROT_READ
  or  edx, PROT_WRITE

  mov r10, MAP_PRIVATE
  or  r10, MAP_ANON

  mov r8, -1
  mov r9, 0

  mov rax, CALL_MMAP
  syscall
  leave
  ret
