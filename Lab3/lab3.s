addiu $sp, $0, 0x1000    # stack pointer
addiu $s0, $0, 6         # input
j main
nop

# multiplication
mult:
  addiu $v0, $0, 0
  addiu $t0, $0, 0
multloop:
  slt $t1, $t0, $a1
  beq $t1, $0, multreturn
  nop
  addu $v0, $v0, $a0
  addiu $t0, $t0, 1
  j multloop
  nop
multreturn:
  jr $ra
  nop

main:
  addiu $t1, $0, 1
  addu $a0, $0, $s0
  addiu $a1, $a0, -1
  addiu $sp, $sp, -12
  sw $t1, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  jal mult
  nop
  lw $t1, 0($sp)
  lw $a0, 4($sp)
  lw $a1, 8($sp)
  addiu $sp, $sp, 12
loop:
  slt $t2, $t1, $a1
  beq $t2, $0, else 
  nop
  addu $a0, $v0, $0
  addiu $a1, $a1, -1
  addiu $sp, $sp, -12
  sw $t1, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  jal mult
  nop
  lw $t1, 0($sp)
  lw $a0, 4($sp)
  lw $a1, 8($sp)
  addiu $sp, $sp, 12
  j loop
  nop
else:
  addu $s1, $0, $v0       # output
