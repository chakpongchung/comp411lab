.data 0x0

	startString:	.asciiz "Converting pixels to grayscale:\n"
	finishString:	.asciiz "Finished.\n"
	newline:		.asciiz "\n"
	pixels:			.word	0x00010000,	0x010101,	0x6,		0x3333,
							0x030c,		0x700853,	0x294999,	-1

	# iteration = $t0

	# r = $t1
	# g = $t2
	# b = $t3

	# pixel = $t4
	# grey = $t5


.text 0x3000

main:
	addi	$v0, $0, 4			# system call code 4 for printing a string
	la		$a0, startString	# put address of startString in $a0
	syscall
	
	add		$t0, $0, $0			# i = 0
	
loop:
	lw		$t4, pixels($t0)	# $t4 = pixel[i]
	beq		$t4, -1, endloop	# if pixel[i] == -1 break
	
	andi	$t3, $t4, 0xff		# $t3 = blue
	srl		$t4, $t4, 8			# t4 >> 8
	andi	$t2, $t4, 0xff		# $t2 = green
	srl		$t4, $t4, 8			# t4 >> 8
	andi	$t1, $t4, 0xff		# $t1 = red
	
	jal		rgb_to_gray			# $t5 = gray
	
	addi	$v0, $0, 1			# system call code 1 for printing integer
	add		$a0, $0, $t5		# put the value of gray into $a0
	syscall
	
	addi	$v0, $0, 4			# system call code 4 for printing string
	la		$a0, newline		# load the address of newline into $a0
	syscall
	
	addi	$t0, $t0, 4			# i = i + 1
	j		loop
	
rgb_to_gray:
	add		$t9, $t1, $t2		# temp = red + green
	add		$t9, $t9, $t3		# temp = temp + blue
	div		$t5, $t9, 3			# gray = temp / 3
	
	jr		$ra
	
endloop:
	addi	$v0, $0, 4
	la		$a0, finishString
	syscall
	
	addi	$v0, $0, 10
	syscall
