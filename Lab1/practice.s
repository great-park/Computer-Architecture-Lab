main:
	...
	addi $a0, $0, 2         # argument 0 = 2
	addi $a1, $0, 3         # argument 1 = 3
	addi $a2, $0, 4         # argument 2 = 4
	addi $a3, $0, 5         # argument 3 = 5
	jal diffofsums          # call function
	add $s0, $v0, $0        # y = returned value
	...
# $s0 = result
diffofsums:
	addi $sp, $sp, −12  # make space on stack to store three registers
	sw $s0, 8($sp)      # save $s0 on stack
	sw $t0, 4($sp)      # save $t0 on stack
	sw $t1, 0($sp)      # save $t1 on stack
	add $t0, $a0, $a1   # $t0 = f+g
	add $t1, $a2, $a3   # $t1 = h+i
	sub $s0, $t0, $t1   # result = (f + g) − (h + i)
	add $v0, $s0, $0    # put return value in $v0
	lw $t1, 0($sp)      # restore $t1 from stack
	lw $t0, 4($sp)      # restore $t0 from stack
	lw $s0, 8($sp)      # restore $s0 from stack
	addi $sp, $sp, 12   # deallocate stack space
	jr $ra              # return to caller