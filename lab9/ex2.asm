.text
	ori		$v0, $zero, 5			# syscall 5 for reading an integer
	syscall
	
	add		$s0, $zero, $v0			# $s0 = seed
	
	add		$s1, $zero, $s0			# random = seed
	
loop:
	ori		$v0, $zero, 1			# syscall 1 for printing an integer
	add		$a0, $zero, $s1
	syscall
	
	ori		$v0, $zero, 11
	addi	$a0, $zero, '\n'
	syscall
	
	srl		$t1, $s1, 4				# $t1 = b4
	andi	$t1, $t1, 1
	
	srl		$t2, $s1, 2				# $t2 = b2
	andi	$t2, $t2, 1
	
	xor		$t0, $t1, $t2			# b = b4 ^ b2
	
	sll		$s1, $s1, 1
	andi	$s1, $s1, 31
	or		$s1, $s1, $t0
	
	beq		$s1, $s0, exit
	j		loop
	
exit:
	ori		$v0, $zero, 10
	syscall
