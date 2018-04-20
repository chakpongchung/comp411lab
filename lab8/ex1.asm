.data 
	input:		.space 22
	
.text

loop:
	la		$a0, input
	ori		$a1, $zero, 22
	ori		$v0, $zero, 8
	syscall
	
	la		$a0, input
	
	jal		h_to_i
	
	beq		$v0, $zero, exit
	
	add		$a0, $zero, $v0
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11
	syscall
	
	j		loop

exit:
	ori		$v0, $zero, 10
	syscall

	
h_to_i:
		#------------------------------------
		# $t1 = i			(max: 20)
		# $t2 = n			(unsigned)
		# $t3 = input[i]	(unsigned)
		#------------------------------------
		add		$t1, $zero, $zero		# i = 0
		add		$t2, $zero, $zero		# n = 0
	
	parse:
		lbu		$t3, input($t1)			# $t3 = input[i]
		
		addi	$t0, $zero, 10			# '\n' == 10
		beq		$t3, $t0, return		# if (input[i] == '\n') return
		beq		$t3, $zero, return		# if (input[i] == '\0') return
	
		sll		$t2, $t2, 4				# n *= 16
		
		slti	$t0, $t3, 58			# if (input[i] <= '9') $t0 = 1
		bne		$t0, $zero, number		# if ($t0 == 1) input[i] is a number
		
		j		letter					# else it is a letter
		
	number:
		
		addu	$t2, $t2, $t3			# n += input[i]
		addiu	$t2, $t2, -48			# n -= '0'
		
		addi	$t1, $t1, 1				# i++
		j		parse
	
	letter:
		
		# the following two lines results in n += input[i] - 'a' + 10;
		
		addu	$t2, $t2, $t3			# n += input[i]
		addiu	$t2, $t2, -87			# n -= 'a' - 10
		
		addi	$t1, $t1, 1
		j		parse
	
	return:
		add		$v0, $zero, $t2
		jr		$ra
	