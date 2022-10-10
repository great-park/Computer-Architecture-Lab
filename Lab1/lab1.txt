main:
    addiu $s0, $0, 10
    addiu $s1, $0, 3

for:
    slt $t1, $s1, $s0
    beq $t1, $0, set
    nop
    subu $s0, $s0, $s1
    j for
    nop

set:
    addu $s2, $0, $s0

done: