# Starter file for ex1.asm

.data 0x0
	default:	.asciiz "P3\n"
	new_line:	.asciiz "\n"
	
	# $s0 = cols
	# $s1 = rows
	# $s2 = ppm_max
	
	# $s3 = x1
	# $s4 = x2
	# $s5 = y1
	# $s6 = y2

.text 0x3000

main:
	
	ori		$v0, $0, 5			# syscall 5 for reading integer
	syscall
	add		$s3, $0, $v0		# $s3 = x1
	
	ori		$v0, $0, 5
	syscall
	add		$s4, $0, $v0		# $s4 = x2
	
	ori		$v0, $0, 5
	syscall
	add		$s5, $0, $v0		# $s5 = y1
	
	ori		$v0, $0, 5
	syscall
	add		$s6, $0, $v0		# $s6 = y2
	
	ori		$v0, $0, 4			# syscall 4 for printing string
	la		$a0, default
	syscall
	
	ori		$v0, $0, 5
	syscall
	add		$s0, $0, $v0		# $s0 = cols
	
	ori		$v0, $0, 5
	syscall
	add		$s1, $0, $v0		# $s1 = rows
	
	ori		$v0, $0, 1			# syscall 1 for printing integer
	add		$a0, $0, $s0
	syscall
	
	ori		$v0, $0, 4
	la		$a0, new_line
	syscall
	
	ori		$v0, $0, 1
	add		$a0, $0, $s1
	syscall
	
	ori		$v0, $0, 4
	la		$a0, new_line
	syscall
	
	ori		$v0, $0, 5
	syscall
	add		$s2, $0, $v0		# $s2 = ppm_max
	
	ori		$v0, $0, 1
	addi	$a0, $0, 255
	syscall
	
	ori		$v0, $0, 4
	la		$a0, new_line
	syscall
	
	jal		iterate

end: 
	ori   $v0, $0, 10     # system call 10 for exit
	syscall               # exit

iterate:
	#------------------------------------------------------------#
	# $s0 = rows
	# $s1 = columns
	# $s2 = ppm_max
	
	# $s3 = x1
	# $s4 = x2
	# $s5 = y1
	# $s6 = y2
	
	# $t1 = i
	# $t2 = j
	#------------------------------------------------------------#
	
	addi	$sp, $sp, -4
	sw		$ra, 0($sp)
	
	add		$t1, $0, $0			# i = 0
	
loop_i:
	slt		$t0, $t1, $s1		# if (i < rows) $t0 = 1
	beq		$t0, $0, end_loop_i	# if (i < rows == 0) jump to end_loop_i
	
	add		$t2, $0, $0			# j = 0
	
loop_j:
	slt		$t0, $t2, $s0		# if (j < columns) $t0 = 1
	beq		$t0, $0, end_loop_j	# if (j < columns == 0) jump to end_loop_j
	
	ori		$v0, $0, 5			# $a0 = r
	syscall
	add		$a0, $0, $v0
	
	ori		$v0, $0, 5			# $a1 = g
	syscall
	add		$a1, $0, $v0
	
	ori		$v0, $0, 5			# $a2 = b
	syscall
	add		$a2, $0, $v0
	
	add		$a3, $0, $s2		# $a3 = ppm_max
	
	#------------------------------------------------------------#
	# inside is the RGB -> Gray process for pixels outside
	slt		$t0, $t1, $s5		# if (i < y1)
	bne		$t0, $0, gray		# then go gray
	
	slt		$t0, $s6, $t1		# if (y2 < i)
	bne		$t0, $0, gray		# then go gray
	
	slt		$t0, $t2, $s3		# if (j < x1)
	bne		$t0, $0, gray		# then go gray
	
	slt		$t0, $s4, $t2		# if (x2 < j)
	bne		$t0, $0, gray		# then go gray
	
	j		print
	
gray:	
	addi	$sp, $sp, -8		# reserve memory
	sw		$t1, -4($sp)		# save i
	sw		$t2, 0($sp)			# save j
	
	jal	rgb_to_gray
	
	lw		$t1, -4($sp)		# restore i
	lw		$t2, 0($sp)			# restore j
	addi	$sp, $sp, 8			# release memory
	
	add		$a0, $0, $v0		# r = gray
	add		$a1, $0, $v0		# g = gray
	add		$a2, $0, $v0		# b = gray
	#------------------------------------------------------------#

print:
	add		$a0, $0, $a0		# print r
	ori		$v0, $0, 1
	syscall
	
	ori		$v0, $0, 4			# print the newline
	la		$a0, new_line
	syscall
	
	add		$a0, $0, $a1		# print g
	ori		$v0, $0, 1
	syscall
	
	ori		$v0, $0, 4			# print the newline
	la		$a0, new_line
	syscall
	
	add		$a0, $0, $a2		# print b
	ori		$v0, $0, 1
	syscall
	
	ori		$v0, $0, 4			# print the newline
	la		$a0, new_line
	syscall
	
	addi	$t2, $t2, 1
	j		loop_j
end_loop_j:

	addi	$t1, $t1, 1
	j		loop_i
end_loop_i:

	lw		$ra, 0($sp)
	jr		$ra

rgb_to_gray:

	#------------------------------------------------------------#
	# $a0 has r 30
	# $a1 has g 59
	# $a2 has b 11
	# $a3 has ppm_max
	#
	# Write code to compute gray value in $v0 and return.
	#------------------------------------------------------------#
	
	addi	$t0, $0, 30
	mult	$a0, $t0
	mflo	$a0
	
	addi	$t0, $0, 59
	mult	$a1, $t0
	mflo	$a1
	
	addi	$t0, $0, 11
	mult	$a2, $t0
	mflo	$a2
	
	add		$t1, $a0, $a1
	add		$t1, $t1, $a2
	addi	$t0, $0, 255
	mult	$t1, $t0
	mflo	$t1					# $t1 = (r*30 + g*59 + b*11) * 255)
	
	add		$t2, $0, $a3
	addi	$t0, $0, 100
	mult	$t2, $t0
	mflo	$t2					# $t2 = (100 * ppm_max)
	
	div		$t1, $t2
	mflo	$v0
	
	jr	$ra
