.data 
	input:		.space 22
	
.text

loop:
	
	#------------------------------------
	# $s1 = n
	# $s2 = k
	#------------------------------------
	
	# read the first number
	la		$a0, input
	ori		$a1, $zero, 22
	ori		$v0, $zero, 8				# syscall 8 for read a string
	syscall
	
	la		$a0, input
	jal		h_to_i
	
	beq		$v0, $zero, exit			# if (n == 0) exit
	
	add		$s1, $zero, $v0				# $s1 = n
	
	# read the second number
	la		$a0, input
	ori		$a1, $zero, 22
	ori		$v0, $zero, 8
	syscall
	
	la		$a0, input
	jal		h_to_i
	
	add		$s2, $zero, $v0				# $s2 = k
	
	add		$a0, $zero, $s1
	add		$a1, $zero, $s2
	
	jal		NchooseK
	
	add		$a0, $zero, $v0
	ori		$v0, $zero, 1
	syscall
	
	addi	$a0, $zero, '\n'
	ori		$v0, $zero, 11				# syscall 11 for printing a char
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
	
NchooseK:
		#------------------------------------
		# $a0 = n
		# $a1 = k
		#------------------------------------
		
		beq		$a1, $zero, return_1
		beq		$a1, $a0, return_1
		
		# push $ra, $a0 and $a1
		addiu	$sp, $sp, -8
		sw		$ra, 4($sp)
		sw		$fp, 0($sp)
		
		addiu	$fp, $sp, 4
		
		addiu	$sp, $sp, -8
		sw		$a0, -8($fp)
		sw		$a1, -12($fp)
		
		addiu	$a0, $a0, -1			# $a0 = n - 1
		addiu	$a1, $a1, -1			# $a1 = k - 1
		
		jal		NchooseK
		
		# pop $a0 and $a1, push $v0
		lw		$a0, -8($fp)
		lw		$a1, -12($fp)
		sw		$v0, -8($fp)			# $v0 = NchooseK(n - 1, k - 1)
		addiu	$sp, $sp, 4
		
		addiu	$a0, $a0, -1			# $a0 = n - 1
		
		jal		NchooseK
		
		lw		$t0, -8($fp)			# $t0 = NchooseK(n - 1, k - 1)
		addu	$v0, $v0, $t0			# $v0 = NchooseK(n - 1, k - 1) + NchooseK(n - 1, k)
		addiu	$sp, $sp, 4
		
		lw		$ra, 0($fp)
		lw		$fp, -4($fp)
		addiu	$sp, $sp, 8
		jr		$ra
		
	return_1:
		addi	$v0, $zero, 1
		jr		$ra
	