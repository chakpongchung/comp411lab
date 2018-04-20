

main:

	addi	$t1, $0, 0
	addi 	$t2, $0, 1
	addi 	$t0, $0, 2
	
loop:
	
	slti 	$t4, $t0, 13		# if $t0 < 13 then set $t4 be 1
	beq		$t4, $0, endloop	# if $t4 == 0 go to endloop
	
	add		$t3, $t2, $t1
	add		$t1, $t2, $0
	add		$t2, $t3, $0
	
endloop:

	addi	$v0, $0, 10
	syscall