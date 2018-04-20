.text
.globl	NchooseK

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
	
exit:
	lw		$ra, 0($fp)
	lw		$fp, -4($fp)
	addiu	$sp, $sp, 8
	jr		$ra
		
return_1:
	addi	$v0, $zero, 1
	jr		$ra
	
