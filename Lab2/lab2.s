  lui  $s0, 0x0001        	# $s0 = 0x00010000
  ori  $s0, $s0, 0xF000   	# $s0 = 0x0001F000
  addiu $s1, $0, 0        	# i = 0
  addiu $s2, $0, 0              # sum = 0
  addiu $t2, $0, 10       	# $t2 = 10
  addiu $t3, $0, 30             # $t3 = 30

loop:
  slt  $t0, $s1, $t2      	# i < 10?
  beq  $t0, $0, done      	# if not then done
  nop			    	# delay slot
  slt  $t4, $s2, $t3            # sum < 30?
  beq  $t4, $0, next            # if not then next
  nop
  addu $s2, $s2, $s1            # sum = sum + i  
  j    next
  nop

next:
  sll  $t0, $s1, 2        	# $t0 = i * 4 (byte offset)
  addu  $t0, $t0, $s0     	# address of array[i]
  lw   $t1, 0($t0)        	# $t1 = array[i]
  addu $t1, $t1, $s2        	# $t1 = array[i] + sum
  sw   $t1, 0($t0)        	# array[i] = array[i] + sum
  addiu $s1, $s1, 1       	# i = i + 1
  j    loop               	# repeat
  nop			    	# delay slot
done: