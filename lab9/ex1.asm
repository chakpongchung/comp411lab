.text

loop:
	ori		$v0, $zero, 5			# syscall 5 for reading integer
	syscall
	
	add		$s0, $zero, $v0
	
	add		$a0, $zero, $v0
	jal		parse
	
	beq		$s0, $zero, exit			# if n == 0 exit
	
	j		loop
	
exit:
	ori		$v0, $zero, 10
	syscall
	
parse:
	
	add		$t1, $zero, $a0			# $t1 = n
	ori		$t2, $zero, 15			# i = 0
	
loop_i:
	srlv	$t3, $t1, $t2			# $t3 = n >> i
	andi	$a0, $t3, 1				# $a0 = $t3 | 1
	
	ori		$v0, $zero, 1
	syscall
	
	beq		$t2, $zero, end_i
	
	addi	$t2, $t2, -1
	j		loop_i
	
end_i:
	ori		$v0, $zero, 11			# syscall 11 for printing a char
	addi	$a0, $zero, '\n'
	syscall
	
	jr		$ra