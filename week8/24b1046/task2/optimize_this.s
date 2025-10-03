.data
A:      .word 1,2,3,4,5,6,7,8,9,10
B:      .word 10,9,8,7,6,5,4,3,2,1
C:      .word 0,0,0,0,0,0,0,0,0,0
n:      .word 10

.text
    lwu r2, n(r0)
    daddi r3, r0, A
    daddi r4, r0, B
    daddi r5, r0, C

    daddi r6, r0, 0

loop:
    dsubu r7, r2, r6
    

    lwu r8, 0(r3)
    lwu r9, 0(r4)

    beqz r7, done
    dadd r10, r8, r9
       

    sw r10, 0(r5)

    daddi r3, r3, 4
    daddi r4, r4, 4
    daddi r5, r5, 4
    daddi r6, r6, 1

    j loop

done:
    halt
