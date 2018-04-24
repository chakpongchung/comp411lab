#------------------------------------------------
# Notes:
#
# If you mistype '$a3' to '$s3', God help you :)
#------------------------------------------------

.data 0x0
    disk:   .asciiz "Move disk "
    from:   .asciiz " from Peg "
    to:     .asciiz " to Peg "
.text 0x3000
main:

	ori		$v0, $zero, 5
	syscall
	add		$a3, $zero, $v0

    addi    $a0, $zero, 1
    addi    $a1, $zero, 3
    addi    $a2, $zero, 2
    jal		hanoi

exit:
    ori     $v0, $zero, 10
    syscall

hanoi:
    # Move 'n' disks from 's' to 't', using 'm' as medium.
    # s -> $a0
    # t -> $a1
    # m -> $a2
    # n -> $a3

    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)
    
    sltiu   $t0, $a3, 2
    beq     $t0, $zero, normal      # if !(n < 2) normal

    add     $a2, $zero, $a1         # "Move n"
    add     $a1, $zero, $a0         # "from s"
    add     $a0, $zero, $a3         # "to t"
    jal     print

    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4

    jr      $ra

normal:
    addiu   $sp, $sp, -16
    sw      $a0, 12($sp)
    sw      $a1, 8($sp)
    sw      $a2, 4($sp)
    sw      $a3, 0($sp)

    # hanoi(s, m, t, n - 1);
    add     $t0, $zero, $a1			# $t0 = t
    add     $a1, $zero, $a2         # $a1 = m
    add     $a2, $zero, $t0         # $a2 = t
    addiu   $a3, $a3, -1            # $a3 = n - 1
    jal     hanoi

    lw      $a0, 12($sp)
    lw      $a1, 8($sp)
    lw      $a2, 4($sp)
    lw      $a3, 0($sp)

    add     $a2, $zero, $a1         # $a2 = t
    add     $a1, $zero, $a0         # $a1 = s
    add     $a0, $zero, $a3         # $a0 = n
    jal     print

    lw      $a0, 12($sp)
    lw      $a1, 8($sp)
    lw      $a2, 4($sp)
    lw      $a3, 0($sp)
    addiu	$sp, $sp, 16

    # hanoi(m, t, s, n - 1);
    add     $t0, $zero, $a0
    add     $a0, $zero, $a2         # from 'm'
    add     $a2, $zero, $t0         # using 's' as medium
    addiu   $a3, $a3, -1            # moving 'n - 1' disks
    jal     hanoi

    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4

    jr      $ra

print:
    # Move disk 'n' from Peg 's' to Peg 't'\n
    # n -> $a0
    # s -> $a1
    # t -> $a2

    add     $t1, $zero, $a0

    la      $a0, disk
    ori     $v0, $zero, 4
    syscall                         # "Move disk "

    add     $a0, $zero, $t1
    ori     $v0, $zero, 1
    syscall                         # "n"

    la      $a0, from
    ori     $v0, $zero, 4
    syscall                         # " from Peg "

    add     $a0, $zero, $a1
    ori     $v0, $zero, 1
    syscall                         # "s"

    la      $a0, to
    ori     $v0, $zero, 4
    syscall                         # " to Peg "

    add     $a0, $zero, $a2
    ori     $v0, $zero, 1
    syscall                         # "t"

    addi    $a0, $zero, '\n'
    ori     $v0, $zero, 11
    syscall                         # "\n"

    jr      $ra
