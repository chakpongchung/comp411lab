.text
.globl do_task

do_task:

    #---------------------------
    # $a0 = a
    # $a1 = b
    #---------------------------

    addiu   $sp, $sp, -8
    sw      $ra, 4($sp)
    sw      $fp, 0($sp)
    addiu   $fp, $sp, 4

    addiu   $sp, $sp, -8
    sw      $s0, 4($sp)             # save $s0
    sw      $s1, 0($sp)             # save $s1

    add     $s0, $zero, $a0         # $s0 = a
    add     $s1, $zero, $a1         # $s1 = b

    addu    $a0, $s0, $s1           # $a0 = a + b
    add     $a1, $zero, $s0         # $a1 = a
    jal     NchooseK

    add     $a0, $zero, $v0
    jal     print_it

    add     $a0, $zero, $s1
    jal     Fibonacci

    add     $a0, $zero, $v0
    jal     print_it

    lw      $s0, 4($sp)
    lw      $s1, 0($sp)
    addiu   $sp, $sp, 8

exit:
    lw      $ra, 0($fp)
    lw      $fp, -4($fp)
    addiu   $sp, $sp, 8
    jr      $ra
