section .data
    shifted_disk db "Shifted disk "
    from_str db " from "
    to_str db " to "
    a_rod db 'A'
    b_rod db 'B'
    c_rod db 'C'
    newline db 10
    shifted_len equ 13
    from_len equ 6
    to_len equ 4
    buffer db 100 dup(0) ; Output buffer for result string

section .bss
    input_buf resb 20  ; Reserve 20 bytes for input
    buf resb 20  
    num resq 1         ; 64-bit integer

section .text
    global printNum
    global hanoi
    global _start 
    global printFromAndTo

printNum:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Write code to print an arbitary number stored in rax
    push rbp
    mov rbp, rsp
    sub rsp, 32  

    push rbx
    push rax

    mov rcx, 19
    mov rbx, 10
.whi:
    cmp rax, 0
    jle .print

    xor rdx, rdx   
    div rbx
    add dl,'0'
    mov  [buffer + rcx] , dl

    sub rcx,1
    jmp .whi
 
.print:  
    mov rax, 1          
    mov rdi, 1 

    mov rsi, buffer      
    add rsi, rcx         
    add rsi, 1    

    mov rdx,19
    sub rdx, rcx   
    syscall 

    pop rax
    pop rbx
    mov rsp, rbp 
    pop rbp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printFromAndTo:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to print " from " *rax " to " *rdi
    push rbp
    mov rbp, rsp
    sub rsp, 32

    push rdi
    push rax

    mov rax, 1          
    mov rdi, 1 
    mov rsi, from_str    
    mov rdx,from_len 
    syscall 


    pop rax
    mov rsi, rax   
    mov rax, 1          
    mov rdi, 1 
    mov rdx,1
    syscall 

    mov rax, 1          
    mov rdi, 1 
    mov rsi, to_str    
    mov rdx, to_len 
    syscall 

    mov rax, 1          
    pop rdi
    mov rsi, rdi
    mov rdi, 1 
    mov rdx,1 
    syscall 

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rsp, rbp 
    pop rbp
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hanoi:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; C code for function
;;;; void hanoi(int n, char from, char to, char aux) {
;;;;     if (n == 1) {
;;;;         printf("Shifted disk 1 from %c to %c\n", from, to);
;;;;         return;
;;;;     }
;;;;     hanoi(n - 1, from, aux, to);
;;;;     printf("Shifted disk %d from %c to %c\n", n, from, to);
;;;;     hanoi(n - 1, aux, to, from);
;;;; }
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp-8], rdi   
    mov [rbp-16], rsi  
    mov [rbp-24], rdx  
    mov [rbp-32], rcx  

    cmp rdi, 1
    jne .recur

    mov rax, 1
    mov rdi, 1
    mov rsi, shifted_disk
    mov rdx, shifted_len
    syscall

    mov rax, 1
    call printNum

    mov rax, [rbp-16]  
    mov rdi, [rbp-24]  
    call printFromAndTo

    jmp .end_hanoi

.recur:
    mov rdi, [rbp-8]   
    dec rdi             
    mov rsi, [rbp-16]   
    mov rdx, [rbp-32]   
    mov rcx, [rbp-24]   
    call hanoi

    mov rax, 1
    mov rdi, 1
    mov rsi, shifted_disk
    mov rdx, shifted_len
    syscall

    mov rax, [rbp-8]
    call printNum

    mov rax, [rbp-16] 
    mov rdi, [rbp-24]  
    call printFromAndTo

    mov rdi, [rbp-8]    
    dec rdi             
    mov rsi, [rbp-32]   
    mov rdx, [rbp-24]  
    mov rcx, [rbp-16]   
    call hanoi

.end_hanoi:
    mov rsp, rbp
    pop rbp
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to take in number as input, then call hanoi(num, 'A','B','C')

    mov rax, 0
    mov rdi, 0
    mov rsi, input_buf
    mov rdx, 20
    syscall

    mov rsi, input_buf
    xor rax, rax
.convert1:
    movzx rcx, byte [rsi]
    cmp rcx, 10
    je .done1
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .convert1

.done1:
    mov rdi, rax  
    mov rsi, a_rod
    mov rdx, b_rod
    mov rcx, c_rod   
    call hanoi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall
