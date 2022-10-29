.data
f:
g:
y:

.text
main:
	addi $sp, $sp, −4  # make stack frame
	sw $ra, 0($sp)     # store $ra on stack
	addi $a0, $0, 2    # $a0 = 2
	sw $a0, f          # f = 2
	addi $a1, $0, 3    # $a1 = 3
	sw $a1, g          # g = 3
	jal sum            # call sum function
	sw $v0, y          # y = sum(f, g)
	Iw $ra, 0($sp)     # restore $ra from stack
	addi $sp, $sp, 4   # restore stack pointer
	jr $ra             # return to operating system
sum:
	add $v0, $a0, $a1  # $v0 = a+b
	jr $ra             # return to caller