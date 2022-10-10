lui $s0, $0, 0x1234
ori $s0, $s0, 0xDE00
addi $s1, $0, $0
addi $t0, $0, 2
addi $t1, $0, 0xFF

loop:
    slt $t2, $s1, $t0
    beq $t2, $0, exit

    sll $t3, $s1, 2
    add $t3, $t3, $s0

    lw $t4, 0($t3)
    srl $t4, $t4, 16
    and $t4, $t4, $t1
    sw $t4, 0($t3)

    addi $s1, $s1, 1
	j loop

exit: