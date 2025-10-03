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

polar_complx:
    polar_complx_name db 'c'
    polar_complx_pad db 7 dup(0)
    polar_complx_mag dq 10.0
    polar_complx_ang dq 0.0001

fmt db "%s => %f %f", 10, 0     ;
label_polar2rect db "Testing polars to rectangular",0
label_exp db "Testing exp",0
label_sin db "Testing sin",0
label_cos db "Testing cos",0

;;;;;;;;;;;;;
six dq 6.0
two dq 2.0
one dq 1.0
fivef dq 120.0
ffour dq 24.0
fseven dq 5040.0
fsix dq 720.0

temp dq 0.0
;;;; Fill other constants needed 
;;;;;;;;;;;;;

temp_cmplx:
    temp_name db 'r'
    temp_pad  db 7 dup(0)
    temp_real dq 0.0
    temp_img  dq 0.0

section .text
    default rel
    extern print_cmplx,print_float
    global main

main:
    push rbp
    
    ; --- Test: Polar to Rectangular ---
    lea rdi, [polar_complx]         ; pointer to input polar struct
    lea rsi, [temp_cmplx]     ; pointer to output rect struct
    
    call polars_to_rect

    lea rdi, [label_polar2rect]
    lea rsi, [temp_cmplx]
    call print_cmplx          ; should show converted rectangular form

    ; --- Test: exp ---
    movups xmm0, [two]
    mov rdi, 0x6

    call exp

    movups [temp],xmm0 
    lea rdi, [label_exp]
    lea rsi , [temp]
    call print_float

    ; --- Test: sin ---
    movups xmm0, [two]

    call sin

    movups [temp],xmm0 
    lea rdi, [label_sin]
    lea rsi , [temp]
    call print_float

    ; --- Test: cos ---
    movups xmm0, [two]
    call cos

    movups [temp],xmm0 
    lea rdi, [label_cos]
    lea rsi , [temp]
    call print_float

    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FILL FUNCTIONS BELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
polars_to_rect:
   
    push rbp
    mov rbp, rsp
    

    movsd xmm1, [rdi+8] ;r
    movsd xmm2, [rdi+16] ;theta

    movsd xmm0,xmm2

    sub rsp,32
    movaps [rsp], xmm1
    movaps [rsp+16], xmm2
    call cos
    movaps xmm2, [rsp+16] 
    movaps xmm1, [rsp] 
    add rsp , 32
    movsd xmm3,xmm0
    
    movsd xmm0, xmm2
    sub rsp,48
    movaps [rsp], xmm1
    movaps [rsp+16], xmm2
    movaps [rsp+32], xmm3
    call sin
    movaps xmm3,[rsp+32]
    movaps xmm2, [rsp+16] 
    movaps xmm1, [rsp] 
    add rsp,48

    mulsd xmm3, xmm1
    mulsd xmm0,xmm1

    movsd  [rsi+8], xmm3
    movsd [rsi+16], xmm0

    pop rbp
    ret
;-------------------------------------------------
exp:
    push rbp
    mov rbp, rsp

    movsd xmm1, [one]
    mov rdx, 0

.exp_loop:
    cmp rdx,rdi
    jge .end_loop
    add rdx,1
    mulsd xmm1,xmm0
    jmp .exp_loop

.end_loop:
    movsd xmm0,xmm1 

    pop rbp
    ret 
;-------------------------------------------------
sin:
    push rbp
    mov rbp, rsp

    movsd xmm2,xmm0
    movsd xmm3,xmm0

    mov rdi, 3
    call exp
    movsd xmm4,[six]
    divsd xmm0,xmm4
    subsd xmm2,xmm0

   

    mov rdi, 7
    movsd xmm0, xmm3
    call exp
    movsd xmm4,[fseven]
    divsd xmm0,xmm4
    subsd xmm2,xmm0

    mov rdi, 5
    movsd xmm0, xmm3
    call exp
    movsd xmm4,[fivef]
    divsd xmm0,xmm4
    addsd xmm2,xmm0
    

    movsd xmm0,xmm2

    pop rbp
    ret

cos:
    push rbp
    mov rbp, rsp

    movsd xmm2,[one]
    movsd xmm3,xmm0

    mov rdi, 2
    call exp
    divsd xmm0,[two]
    subsd xmm2,xmm0
    
    mov rdi, 4
    movsd xmm0,xmm3
    call exp
    divsd xmm0,[ffour]
    addsd xmm2,xmm0

    mov rdi, 6
    movsd xmm0,xmm3
    call exp
    divsd xmm0,[fsix]
    subsd xmm2,xmm0

    movsd xmm0,xmm2

    pop rbp
    ret
;-------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CODE ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
