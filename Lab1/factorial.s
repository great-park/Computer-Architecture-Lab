factorial: 
    addi $sp, $sp, ā8  # make room on stack
    sw $a0, 4($sp)     # store $a0
    sw $ra, 0($sp)     # store $ra
    addi $t0, $0, 2    # $t0 = 2
    slt $t0, $a0, $t0  # n <= 1 ?
    beq $t0, $0, else  # no: go to else
    addi $v0, $0, 1    # yes: return 1
    addi $sp, $sp, 8   # restore $sp
    jr $ra             # return
else: 
 	addi $a0, $a0, ā1  #n = n ā 1
    jal factorial      # recursive call
    lw $ra, 0($sp)     # restore $ra
    lw $a0, 4($sp)     # restore $a0
    addi $sp, $sp, 8   # restore $sp
    mul $v0, $a0, $v0  # n * factorial(nā1)
    jr $ra             # return