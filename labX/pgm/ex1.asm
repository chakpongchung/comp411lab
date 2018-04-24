# ------------------------------------------------------
# Notes for this assignment:
#
# When using byte to store small numbers, remember to
# 	use appropriate 'lb' instruction ('lb' and 'lbu')
#
# Remember to exit the program by calling 'syscall 10'!
# ------------------------------------------------------

.data 0x0
	picture:	.space 4096
	blur:		.space 4096
	magic:		.space 4
	DX:			.byte -1, 0, 1, -1, 0, 1, -1, 0, 1
	DY:			.byte -1, -1, -1, 0, 0, 0, 1, 1, 1
	
.text 0x3000
main:
	# x -> $s0
	# y -> $s1
	# max -> $s2
	
	la		$a0, magic
	ori		$a1, $zero, 4
	ori		$v0, $zero, 8
	syscall
	
	# read x
	ori		$v0, $zero, 5
	syscall
	add		$s0, $zero, $v0
	
	# read y
	ori		$v0, $zero, 5
	syscall
	add		$s1, $zero, $v0
	
	# read max
	ori		$v0, $zero, 5
	syscall
	add		$s2, $zero, $v0
	
	# i -> $s3
	# j -> $s4
	
	add		$s3, $zero, $zero
read_i:
	# if (!(i < y)) end
	slt		$t0, $s3, $s1
	beq		$t0, $zero, end_read_i
	
	# body of read_i
	
	add		$s4, $zero, $zero
read_j:
	# if (!(j < x)) end
	slt		$t0, $s4, $s0
	beq		$t0, $zero, end_read_j
	
	# body of read_j
	
	# scanf("%hi", &picture[y - i - 1][j]);
	
	subu	$t1, $s1, $s3
	addiu	$t1, $t1, -1		# $t1 = y - i - 1
	sll		$t1, $t1, 6			# $t1 = (y - i - 1) * 64
	addu	$t1, $t1, $s4		# $t1 = (y - i - 1) * 64 + j
	
	ori		$v0, $zero, 5
	syscall
	sb		$v0, picture($t1)
	
	addiu	$s4, $s4, 1
	j		read_j
end_read_j:

	addiu	$s3, $s3, 1
	j		read_i
end_read_i:

	add		$s3, $zero, $zero
process_i:
	# if (!(i < y)) end
	slt		$t0, $s3, $s1
	beq		$t0, $zero, end_process_i
	
	# body of process_i
	
	add		$s4, $zero, $zero
process_j:
	# if (!(j < x)) end
	slt		$t0, $s4, $s0
	beq		$t0, $zero, end_process_j
	
	# body of process_j
	
	# $t1 = j * 64 + i
	sll		$t1, $s4, 6
	add		$t1, $t1, $s3
	
	# validate(j, i, x, y)
	add		$a0, $zero, $s4
	add		$a1, $zero, $s3
	add		$a2, $zero, $s0
	add		$a3, $zero, $s1
	jal		validate
	
	bne		$v0, $zero, normal
	
	lbu		$t0, picture($t1)
	sb		$t0, blur($t1)
	addiu	$s4, $s4, 1
	j		process_j
	
normal:
	# for (int d = 0; d < 9; d++) temp += picture[j + DX[d]][i + DY[d]];
	# j * 64 + i -> $t1
	# temp -> $t2
	# d -> $t3
	
	add		$t2, $zero, $zero
	add		$t3, $zero, $zero
process_d:
	slti	$t0, $t3, 9
	beq		$t0, $zero, end_process_d
	
	# body of process_d
	
	lb		$t0, DX($t3)
	sll		$t0, $t0, 6			# $t0 = DX[d] * 64
	add		$t4, $t1, $t0		# $t4 = j * 64 + i + DX[d] * 64
	lb		$t0, DY($t3)		# $t0 = DY[d]
	add		$t4, $t4, $t0		# $t4 = j * 64 + i + DX[d] * 64 + DY[d]
	
	lbu		$t0, picture($t4)
	add		$t2, $t2, $t0
	
	addiu	$t3, $t3, 1
	j		process_d
end_process_d:

	ori		$t0, $zero, 9
	div		$t2, $t0
	mflo	$t2
	sb		$t2, blur($t1)
	
	addiu	$s4, $s4, 1
	j		process_j
end_process_j:

	addiu	$s3, $s3, 1
	j		process_i
end_process_i:

	# print P2 and other information
	
	la		$a0, magic
	ori		$v0, $zero, 4
	syscall
	
	add		$a0, $zero, $s0
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11
	syscall
	
	add		$a0, $zero, $s1
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11
	syscall
	
	add		$a0, $zero, $s2
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11
	syscall

	add		$s3, $zero, $zero
print_i:
	slt		$t0, $s3, $s1
	beq		$t0, $zero, end_print_i

	add		$s4, $zero, $zero
print_j:
	slt		$t0, $s4, $s0
	beq		$t0, $zero, end_print_j
	
	# $t1 = j * 64 + i
	sll		$t1, $s4, 6
	add		$t1, $t1, $s3
	
	lbu		$a0, blur($t1)
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11
	syscall
	
	addiu	$s4, $s4, 1
	j		print_j
end_print_j:

	addiu	$s3, $s3, 1
	j		print_i
end_print_i:

exit:
	ori		$v0, $zero, 10
	syscall

validate:
	# return (j >= 1) && (i >= 1) && (j+1 < x) && (i+1 < y);

	# j -> $a0
	# i -> $a1
	# x -> $a2
	# y -> $a3
	
	slti	$t0, $a0, 1
	bne		$t0, $zero, return_0
	
	slti	$t0, $a1, 1
	bne		$t0, $zero, return_0
	
	addiu	$a0, $a0, 1
	addiu	$a1, $a1, 1
	
	slt		$t0, $a0, $a2
	beq		$t0, $zero, return_0
	
	slt		$t0, $a1, $a3
	beq		$t0, $zero, return_0
	
	addi	$v0, $zero, 1
	jr		$ra
	
return_0:
	add		$v0, $zero, $zero
	jr		$ra
