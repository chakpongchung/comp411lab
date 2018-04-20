# Starter file for ex1.asm

.data 0x0
	magic:		.space 4 		# more than enough space to read in "P3\n" plus null
	default:	.asciiz "P2\n"
	new_line:	.asciiz "\n"
	
	# $s0 = columns
	# $s1 = rows
	# $s2 = ppm_max
	
	# $s3 = i
	# $s4 = j

.text 0x3000

main:
	#------------------------------------------------------------#
	# Write code here to do exactly what main does in the C program.
	# That is, read and write the magic numbers,
	# read and write the number of cols and rows,
	# and read and write the ppm_max values.  The output's
	# magic number will be "P2".  And, regardless of the input's
	# ppm_max, the output will always have 255 as its ppm_max.
	#------------------------------------------------------------#
	
	ori		$v0, $0, 8			# syscall 8 for reading string
	la		$a0, magic			# read into magic
	addi	$a1, $0, 4			# max 4 characters (including null)
	syscall
	
	ori		$v0, $0, 4			# syscall 4 for printing string
	la		$a0, default
	syscall
	
	ori		$v0, $0, 5			# syscall 5 for reading integer
	syscall
	add		$s0, $0, $v0		# $s0 = columns
	
	ori		$v0, $0, 5
	syscall
	add		$s1, $0, $v0		# $s1 = rows
	
	ori		$v0, $0, 1			# syscall 1 for printing integer
	add		$a0, $0, $s0
	syscall
	
	ori		$v0, $0, 4			# syscall 4 for printing string
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

	#------------------------------------------------------------#
	# Write code here to implement the double-for loop of the C
	# program, to iterate through all the pixels in the image.
	#
	# The actual conversion from RGB to gray value of a single
	# pixel must be done by a separate procedure called rgb_to_gray
	#------------------------------------------------------------#
	
	add		$s3, $0, $0			# i = 0
	
loop_i:
	slt		$t0, $s3, $s1		# if (i < rows) $t0 = 1
	beq		$t0, $0, end		# if (i < rows == 0) jump to end
	
	add		$s4, $0, $0			# j = 0
	
loop_j:
	slt		$t0, $s4, $s0		# if (j < columns) $t0 = 1
	beq		$t0, $0, end_loop_j	# if (j < columns == 0) jump to end_loop_j
	
	ori		$v0, $0, 5
	syscall
	add		$a0, $0, $v0
	
	ori		$v0, $0, 5
	syscall
	add		$a1, $0, $v0
	
	ori		$v0, $0, 5
	syscall
	add		$a2, $0, $v0
	
	add		$a3, $0, $s2
	
	jal	rgb_to_gray
	
	add		$a0, $0, $v0
	ori		$v0, $0, 1
	syscall
	
	ori		$v0, $0, 4
	la		$a0, new_line		# print the newline
	syscall
	
	addi	$s4, $s4, 1
	j		loop_j
end_loop_j:

	addi	$s3, $s3, 1
	j		loop_i

end: 
	ori   $v0, $0, 10     # system call 10 for exit
	syscall               # exit

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
