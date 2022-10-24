.intel_syntax noprefix
.section .data
.set struct_string_len, 0
.set struct_string_data, 8
.set struct_string_size, 16

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
  // rdi.struct_string_len = string size
  mov  rcx, [rbp - 8]
  mov  [rdi + struct_string_len], rcx
  mov  rax, rdi
  leave
  ret

