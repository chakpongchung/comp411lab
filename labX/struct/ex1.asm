#------------------------------------
# Notes
# 
#------------------------------------

.data 0x0
    # each struct is 20 char + 1 int
    record:         .space 1200        # (20 + 4) * 50 = 1200

    # the following two arrays are just pointers
    result:         .space 200         # 50 * 4 = 200
    working_space:  .space 200

.text 0x3000
main:
    ori     $v0, $zero, 5
    syscall
    sll     $s0, $v0, 2                 # n * 4 -> $s0

    add     $s1, $zero, $zero           # i * 4 -> $s1
    add     $s2, $zero, $zero           # &record[i] -> $s2
read:
    slt     $t0, $s1, $s0
    beq     $t0, $zero, end_read

    sw      $s2, result($s1)            # result[i] = &record[i]

    add     $a0, $zero, $s2             # $a0 = &record[i]
    ori     $a1, $zero, 20
    ori     $v0, $zero, 8
    syscall                             # fgets(result[i], 20, stdin)

    ori     $v0, $zero, 5
    syscall
    sw      $v0, 20($s2)                # scanf("%d", result[i] + 20);

    addiu   $s1, $s1, 4
    addiu   $s2, $s2, 24
    j       read
end_read:

	add     $a0, $zero, $zero
    add     $a1, $zero, $s0
    jal     mergesort

    add     $s1, $zero, $zero           # i * 4 -> $s1
print:
    slt     $t0, $s1, $s0
    beq     $t0, $zero, end_print

    lw      $s2, result($s1)            # $s2 = result[i]

    add     $a0, $zero, $s2
    ori     $v0, $zero, 4
    syscall                             # printf("%s", result[i].string)

    lw      $a0, 20($s2)
    ori     $v0, $zero, 1
    syscall                             # printf("%d", result[i].int)

    addiu   $a0, $zero, '\n'
    ori     $v0, $zero, 11
    syscall                             # putchar('\n')

    addiu   $s1, $s1, 4
    j       print
end_print:

exit:
    ori     $v0, $zero, 10
    syscall

mergesort:
    # s * 4 -> $a0
    # t * 4 -> $a1

    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)

    subu    $t1, $a1, $a0
    sltiu   $t0, $t1, 8
    bne     $t0, $zero, done            # if (t - s < 2) done

    addiu   $sp, $sp, -24
    sw      $s0, 20($sp)
    sw      $s1, 16($sp)
    sw      $s2, 12($sp)
    sw      $s3, 8($sp)
    sw      $s4, 4($sp)
    sw      $s5, 0($sp)                 # store $s0 - $s5

    # m * 4 -> $s0
    add     $t0, $a0, $a1
    srl     $s0, $t0, 3                 # $s0 = (s * 4 + n * 4) / 8
    sll     $s0, $s0, 2                 # $s0 = ((s + n) / 2) * 4

    add     $s4, $zero, $a0             # s * 4 -> $s4
    add     $s5, $zero, $a1             # t * 4 -> $s5

    # mergesort(s, m, w, r);
    add     $a1, $zero, $s0
    jal     mergesort
    
    # mergesort(m, t, w, r);
    add     $a0, $zero, $s0
    add     $a1, $zero, $s5
    jal     mergesort

    add     $s1, $zero, $s4             # pi * 4 -> $s1
    add     $s2, $zero, $s0             # pj * 4 -> $s2
    add     $s3, $zero, $s4             # pw * 4 -> $s3
merge:
    # while (pi < m && pj < t)
    slt     $t0, $s1, $s0
    beq     $t0, $zero, append_j
    slt     $t0, $s2, $s5
    beq     $t0, $zero, append_i

    # if (r[pi] < r[pj])
    lw      $a0, result($s1)
    lw      $a1, result($s2)
    jal     less

    beq     $v0, $zero, right

left:
    lw      $t0, result($s1)
    sw      $t0, working_space($s3)

    addiu   $s1, $s1, 4
    addiu   $s3, $s3, 4
    j       merge

right:
    lw      $t0, result($s2)
    sw      $t0, working_space($s3)

    addiu   $s2, $s2, 4
    addiu   $s3, $s3, 4
    j       merge

append_i:
    slt     $t0, $s1, $s0
    beq     $t0, $zero, end_append

    lw      $t0, result($s1)
    sw      $t0, working_space($s3)

    addiu   $s1, $s1, 4
    addiu   $s3, $s3, 4
    j       append_i

append_j:
    slt     $t0, $s2, $s5
    beq     $t0, $zero, end_append

    lw      $t0, result($s2)
    sw      $t0, working_space($s3)

    addiu   $s2, $s2, 4
    addiu   $s3, $s3, 4
    j       append_j

end_append:
    add     $a0, $zero, $s4
    add     $a1, $zero, $s5

    lw      $s0, 20($sp)
    lw      $s1, 16($sp)
    lw      $s2, 12($sp)
    lw      $s3, 8($sp)
    lw      $s4, 4($sp)
    lw      $s5, 0($sp)                 # load back $s0 - $s5
    addiu   $sp, $sp, 24

    add     $t1, $zero, $a0
copy:
    slt     $t0, $t1, $a1
    beq     $t0, $zero, done

    lw      $t0, working_space($t1)
    sw      $t0, result($t1)

    addiu   $t1, $t1, 4
    j       copy

done:
    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4
    jr      $ra

less:
    # return (*a < *b), treating '*a' and '*b' as the structs that starts at
    #   the address specified by 'a' and 'b'.
    # a -> $a0
    # b -> $a1

    add     $t1, $zero, $a0
    add     $t2, $zero, $a1

string:
    lbu     $t3, 0($t1)                 # $t3 = *($t1)
    lbu     $t4, 0($t2)                 # $t4 = *($t2)

    slt     $t0, $t3, $t4
    bne     $t0, $zero, return_true     # if (*($t1) < *($t2)) return true
    slt     $t0, $t4, $t3
    bne     $t0, $zero, return_false    # if (*($t1) > *($t2)) return false

    addi    $t0, $zero, '\n'
    beq     $t0, $t3, integer           # if (*($t1) == '\0') compare int

    addiu   $t1, $t1, 1
    addiu   $t2, $t2, 1
    j       string

integer:
    lw      $t1, 20($a0)                # $t1 = *a.int
    lw      $t2, 20($a1)                # $t2 = *b.int

    slt     $t0, $t1, $t2
    beq     $t0, $zero, return_false    # if (*a.int >= *b.int) return false

return_true:
    ori     $v0, $zero, 1
    jr      $ra

return_false:
    ori     $v0, $zero, 0
    jr      $ra
