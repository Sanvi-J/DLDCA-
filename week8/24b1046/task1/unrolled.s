.data
CONTROL: .word32 0x10000
DATA:    .word32 0x10008

prompt:  .asciiz "Enter n to compute Fibonacci(n): "
unroll: .asciiz "Enter unroll factor: "
result_msg: .asciiz "Fibonacci number: "
nl:      .asciiz "\n"

        .text
        ; Load MMIO register addresses
        lwu   $t9, CONTROL($zero)   ; $t9 = CONTROL address
        lwu   $t8, DATA($zero)      ; $t8 = DATA address

        ; Print prompt
        daddi $v0, $zero, 4         ; 4 = print string
        daddi $a0, $zero, unroll
        sd    $a0, 0($t8)           
        sd    $v0, 0($t9)

        ; Read n 
        daddi $v0, $zero, 8         ; 8 = read integer
        sd    $v0, 0($t9)
        ld    $t0, 0($t8)           ; $t0 = unroll


        ; Print prompt
        daddi $v0, $zero, 4         ; 4 = print string
        daddi $a0, $zero, prompt
        sd    $a0, 0($t8)           
        sd    $v0, 0($t9)

        ; Read n 
        daddi $v0, $zero, 8         ; 8 = read integer
        sd    $v0, 0($t9)
        ld    $s0, 0($t8)           ; $s0 = n
        ; Compute Fibonacci(n) 
        ; F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)
        
        daddi $s1, $zero, 0         ; prev = 0
        daddi $s2, $zero, 1         ; curr = 1
        daddi $s3, $s0, 0         ; i = n

        beq $t0, $zero, fib_loop_0
        slti $t1, $t0,2
        bnez $t1, fib_loop_1
        slti $t2, $t0,3
        bnez $t2, fib_loop_2
        slti $t3, $t0,4
        bnez $t3, fib_loop_3



fib_loop0:
        beq   $s3, $zero, fib_done    ; if i == n, done
        
        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next
        daddi $s3, $s3, -1           ; i++
        j     fib_loop0


fib_loop1:
        daddi $s3, $s3, -3        ; i-3
        slt $t1, $s3, $zero
        bnez  $t1, case3    ; if i == n, done

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next
        
        j     fib_loop1

case3:
        daddi $s3, $s3, 3
        j fib_loop0



fib_loop2:
        daddi $s3, $s3, -5         ; i-5
        slt $t1, $s3, $zero
        bnez  $t1, case5    ; if i == n, done

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

        j     fib_loop2

case5:
        daddi $s3, $s3, 5
        j fib_loop0


fib_loop3:
        daddi $s3, $s3, -7         ; i-7
        slt $t1, $s3, $zero
        bnez  $t1, case7    ; if i == n, done
        
        dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next

         dadd  $s4, $s1, $s2         ; next = prev + curr
        dadd  $s1, $zero, $s2       ; prev = curr
        dadd  $s2, $zero, $s4       ; curr = next
        
        j     fib_loop3


case7:
        daddi $s3, $s3, 7
        j fib_loop0

fib_done:
        ; Result in $s1 

        ; Print result message
        daddi $v0, $zero, 4
        daddi $a0, $zero, result_msg
        sd    $a0, 0($t8)
        sd    $v0, 0($t9)

        ; Print result
        daddi $v0, $zero, 2         ; 2 = print integer
        sd    $s1, 0($t8)
        sd    $v0, 0($t9)

        ; Print newline
        daddi $v0, $zero, 4
        daddi $a0, $zero, nl
        sd    $a0, 0($t8)
        sd    $v0, 0($t9)

        halt