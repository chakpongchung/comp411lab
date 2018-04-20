.text
.globl  Fibonacci

Fibonacci:

    addi    $t0, $zero, 1
    beq     $a0, $t0, return_i
    beq     $a0, $zero, return_i

    addiu   $sp, $sp, -8
    sw      $ra, 4($sp)
    sw      $fp, 0($sp)

    addiu   $fp, $sp, 4
    
    addiu	$sp, $sp, -8
    sw		$s0, 4($sp)
    sw		$s1, 0($sp)
    
    add		$s0, $zero, $a0			# $s0 = n
    
    addiu	$a0, $s0, -1
    jal		Fibonacci
    
    add		$s1, $zero, $v0			# $s1 = Fibonacci(n - 1)
    
    addiu	$a0, $s0, -2
    jal		Fibonacci
    
    addu	$v0, $s1, $v0			# $v0 = Fibonacci(n - 1) + Fibonacci(n - 2)
    
    lw		$s0, 4($sp)
    lw		$s1, 0($sp)
    addiu	$sp, $sp, 8

exit:

    lw      $ra, 0($fp)
    lw      $fp, -4($fp)
    addiu   $sp, $sp, 8
    jr      $ra

return_i:
    add     $v0, $zero, $a0
    jr      $ra
