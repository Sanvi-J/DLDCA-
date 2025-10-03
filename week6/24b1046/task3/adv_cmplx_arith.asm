section .data

complex1:
    complex1_name db 'a'
    complex1_pad  db 7 dup(0)  
    complex1_real dq 1.0
    complex1_img  dq 2.5

complex2:
    complex2_name db 'b'
    complex2_pad  db 7 dup(0)  
    complex2_real dq 3.5
    complex2_img  dq 4.0

label_recip db "Testing Reciprocal", 0

temp_cmplx:
    temp_name db 'r'
    temp_pad  db 7 dup(0)
    temp_real dq 0.0
    temp_img  dq 0.0

section .text
    default rel
    extern print_cmplx
    global main,recip_cmplx

main:
    push rbp

    ; --- Test: Reciprocal ---
    lea rdi, [complex1]
    lea rsi, [temp_cmplx]
    call recip_cmplx
    lea rdi, [label_recip]
    lea rsi, [temp_cmplx]
    call print_cmplx  ; Reciprocal of (1 + 2.5i) = (0.137931 -0.344828i)


    pop rbp
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall

recip_cmplx:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to input two addresses of complex numbers find reciprocal of the complex at the first address and 
; write the result into the second address (source1,destination) => write (1/source1) into destination


    movsd xmm1, [rdi+8]
    movsd xmm2, [rdi+16]


    mulsd xmm1,xmm1
    mulsd xmm2,xmm2

    movsd xmm0, xmm1
    addsd xmm0, xmm2


    movsd xmm1, [rdi+8]
    movsd xmm3, [rdi+16]
    movsd xmm2,xmm3
    subsd xmm2,xmm3
    subsd xmm2,xmm3

    divsd xmm1,xmm0
    divsd xmm2,xmm0

    movq  [rsi+8], xmm1
    movq  [rsi+16], xmm2
    

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
