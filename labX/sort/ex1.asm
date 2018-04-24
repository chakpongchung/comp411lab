#-----------------------------
# Notes:
# When deal with pointer instead of (index * 4), remember the comparison
#	code would require the same amount of shift if we are using pointers
#	since now 'if (a - b < 2) would be 'if (a - b < 8)' for example if 
#	the data type is integer.
#
# When use labels to handle spacial cases such as using a 'done' label
# 	to escape the middle bulk of a routine, remember to make the part before
# 	the 'j' instruction and after the label match. For example, don't reserve
#	one piece of stack space before jumping, but release two pieces of stack
#	space after the 'done' label. (make sure to escape the whole PAIR of both 
#	reserving and releasing)
#-----------------------------

.data 0x0
	result:			.space 200
	working_space:	.space 200
	
.text 0x3000
main:
	ori		$v0, $zero, 5
	syscall
	sll		$s0, $v0, 2					# n * 4 -> $s0
	
	# i * 4 -> $s1
	add		$s1, $zero, $zero
read_i:
	slt		$t0, $s1, $s0
	beq		$t0, $zero, end_read_i

	ori		$v0, $zero, 5
	syscall
	sw		$v0, result($s1)

	addiu	$s1, $s1, 4
	j		read_i
end_read_i:

	add		$a0, $zero, $zero			# s * 4= 0
	add		$a1, $zero, $s0				# t * 4 = n * 4
	la		$a2, working_space
	la		$a3, result
	
	jal		mergesort
	
	add		$s1, $zero, $zero
print_i:
	slt		$t0, $s1, $s0
	beq		$t0, $zero, end_print_i

	ori		$v0, $zero, 1
	lw		$a0, result($s1)
	syscall
	
	ori		$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall

	addiu	$s1, $s1, 4
	j		print_i
end_print_i:
	
exit:
	ori		$v0, $zero, 10
	syscall
	
mergesort:
	# s * 4 -> $a0
	# t * 4 -> $a1
	# working -> $a2
	# result -> $a3
	
	addiu	$sp, $sp, -4
	sw		$ra, 0($sp)
	
	subu	$t1, $a1, $a0
	sltiu	$t0, $t1, 8
	bne		$t0, $zero, done
	
	addiu	$sp, $sp, -4
	sw		$s0, 0($sp)				# store old $s0
	
	# m * 4 -> $s0
	add		$t0, $a0, $a1
	srl		$s0, $t0, 3				# $s0 = (s * 4 + n * 4) / 8
	sll		$s0, $s0, 2				# $s0 = ((s + n) / 2) * 4
	
	addiu	$sp, $sp, -8
	sw		$a0, 4($sp)
	sw		$a1, 0($sp)
	
    # mergesort(s, m, w, r);
	add		$a1, $zero, $s0
	jal		mergesort
	
    # mergesort(m, t, w, r);
	add		$a0, $zero, $s0
	lw		$a1, 0($sp)
	jal		mergesort
	
	lw		$a0, 4($sp)
	lw		$a1, 0($sp)
	addiu	$sp, $sp, 8
	
	add		$t1, $zero, $a0			# pi * 4 -> $t1
	add		$t2, $zero, $s0			# pj * 4 -> $t2
	add		$t3, $zero, $a0			# pw * 4 -> $t3
	
merge:
	# while (pi < m && pj < t)
	slt		$t0, $t1, $s0
	beq		$t0, $zero, append_i
	slt		$t0, $t2, $a1
	beq		$t0, $zero, append_i
	
	# r[pi] < r[pj]
	lw		$t4, result($t1)		# r[pi] -> $t4
	lw		$t5, result($t2)		# r[pj] -> $t5
	slt		$t0, $t4, $t5
	beq		$t0, $zero, right
	
left:
	lw		$t0, result($t1)
	sw		$t0, working_space($t3)
	addiu	$t1, $t1, 4
	addiu	$t3, $t3, 4
	
	j		merge

right:
	lw		$t0, result($t2)
	sw		$t0, working_space($t3)
	addiu	$t2, $t2, 4
	addiu	$t3, $t3, 4
	
	j		merge

append_i:
	slt		$t0, $t1, $s0
	beq		$t0, $zero, end_append_i
	
	lw		$t0, result($t1)
	sw		$t0, working_space($t3)
	addiu	$t1, $t1, 4
	addiu	$t3, $t3, 4

	j		append_i
end_append_i:

append_j:
	slt		$t0, $t2, $a1
	beq		$t0, $zero, end_append_j
	
	lw		$t0, result($t2)
	sw		$t0, working_space($t3)
	addiu	$t2, $t2, 4
	addiu	$t3, $t3, 4
	
	j		append_j
end_append_j:

	add		$t4, $zero, $a0			# s * 4 -> $t4
copy:
	slt		$t0, $t4, $a1
	beq		$t0, $zero, end_copy
	
	lw		$t0, working_space($t4)
	sw		$t0, result($t4)
	
	addiu	$t4, $t4, 4
	j		copy
end_copy:

	lw		$s0, 0($sp)
	addiu	$sp, $sp, 4

done:
	lw		$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr		$ra