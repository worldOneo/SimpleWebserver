.intel_syntax noprefix
.section .data
.set struct_string_cap, 0
.set struct_string_data, 8
.set struct_string_written, 16
.set struct_string_size, 24

.section .text
.global string_alloc
string_alloc:
  enter 0, 0
  mov  rdi, struct_string_size
  call alloc_malloc
  leave
  ret

.global string_alloc_size
string_alloc_size:
  enter 16, 0
  /*
  0 = string
  8 = string size
  */
  
  // string size = rdi
  mov  [rbp - 8], rdi
  // rax = string()
  call string_alloc
  // string = rax
  mov  [rbp - 0], rax
  // rax = malloc(string size)
  mov  rdi, [rbp - 8]
  call alloc_malloc
  // rdi = string
  mov  rdi, [rbp - 0]
  // rdi.struct_string_data = rax
  mov  [rdi + struct_string_data], rax
  // rdi.struct_string_cap = string size
  mov  rcx, [rbp - 8]
  mov  [rdi + struct_string_cap], rcx
  mov  rax, rdi
  leave
  ret

.global string_append_byte
string_append_byte:
  enter 0, 0
  mov  r10, [rdi + struct_string_data]
  add  r10, [rdi + struct_string_written]

  mov  r11, [rdi + struct_string_written]
  mov  r12, [rdi + struct_string_cap]
  
  // if written >= string.cap
  // return -1
  cmp  r11, r12
  jl   .string_append_byte_fits
  mov  rax, -1
  leave
  ret

  .string_append_byte_fits:
  mov  rax, rsi
  movb [r10], al
  addq [rdi + struct_string_written], 1
  mov  rax, 0
  leave
  ret


.global string_write_to
string_write_to:
  enter 0, 0
  mov rax, 1
  // r10 = string
  mov r10, rdi
  // rdi = fd
  mov rdi, rsi
  // rsi = string.data
  mov rsi, [r10 + struct_string_data]
  // rdx = string.written
  mov rdx, [r10 + struct_string_written]
  syscall
  leave
  ret

.global string_append_num
string_append_num:
  enter 24, 0
  /*
  0 = string
  8 = num
  */
  mov  [rbp - 0], rdi
  mov  [rbp - 8], rsi

  mov r10, 0 // char counter

  cmp  rsi, 0
  jne  .string_append_num_loop

  mov rsi, '0'
  call string_append_byte
  
  xor eax, eax
  jmp .string_append_num_ret


  .string_append_num_loop:
  mov  rdx, [rbp - 8] 
  cmp  rdx, 0
  mov  rax, 0
  je   .string_append_num_loop_end

  mov  rax, rdx
  cqo
  mov  r11, 10
  idivq r11 // rdx = num%10; rax = num / 10
  mov  [rbp - 8], rax
  
  mov  rdi, [rbp - 0]
  mov  rsi, rdx
  add  rsi, '0' // rsi += '0'
  push rsi
  inc  r10
  jmp .string_append_num_loop
  .string_append_num_loop_end:
  
  .string_append_num_bytes:
  
  cmp r10, 0
  je .string_append_num_ret

  mov  rdi, [rbp - 0]
  pop  rsi
  push r10
  call string_append_byte
  pop  r10

  cmp  rax, -1
  je   .string_append_num_ret
  
  dec  r10
  jmp  .string_append_num_bytes

  .string_append_num_ret:
  leave
  ret
