section .data
    buffer  db 20 dup(0)     ; Output buffer for result string

section .bss
    input_buf resb 20  ; Reserve 20 bytes for input
    num     resq 1     ; 64-bit integer

section .text
    global _start ; essentially just means start here


_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Take in number as input from user
    ; You can do this using read(0, input_buffer, size) syscall, syscall number for read is 0
    ; Make sure your input buffer is stored in rsi :)

    mov rax, 0
    mov rdi, 0
    mov rsi, input_buf
    mov rdx, 20
    syscall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; The below code simply converts input string to a number, don't worry about it
    mov rsi, input_buf  ; rsi points to buffer
    xor rax, rax        ; accumulator = 0

.convert1:
    movzx rcx, byte [rsi] ; load byte
    cmp rcx, 10           ; check for newline
    je .done1
    sub rcx, '0'          ; convert ASCII to digit
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .convert1

.done1:
    ; Now RAX contains the number entered

    ; Implement following C code:
    ; int a = 0;
    ; int b = 1;
    ; for (int i=0; i < n; i++) {
    ;     int c = a + b;
    ;     a = b;
    ;     b = c;
    ; }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov rdx, 0
    mov rcx, 1
    mov rsi, rcx
    
    mov rbx,0

.forBegin:    
    cmp rbx, rax  
    jge .forEnd
    
    add rsi, rdx
    mov rdx, rcx
    mov rcx, rsi

    add rbx,1
    jmp .forBegin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Print the result
    ; C code is:
    ; i = 19
    ; while (a > 0) {
    ;   buff[i] = a % 10 + '0'; Note you must access only the lower 8 bits of your register storing a here :) for example, for rdx, lower 8 bits are stored in dl
    ;   a /= 10;
    ;   i--;
    ; }
    ; write(1, buff + i + 1, 19 - i); 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.forEnd:
    mov rcx, 19
    mov rbx, 10
    mov rax, rdx

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF YOUR CODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov rax, 60              ; syscall: exit
    xor rdi, rdi             ; exit code 0
    syscall
