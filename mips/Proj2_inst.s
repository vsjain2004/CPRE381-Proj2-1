.data

size: .word 6

.text

addi $t0, $0, 6
addiu $t1, $0, -25
ori $t2, $0, 5
lui $t3, 0x1001
sll $t4, $t0, 1
srl $t5, $t0, 1
xori $t7, $t2, 4
lw $t8, 0($t3)
sra $t6, $t1, 1
slti $t9, $t2, 6
sltiu $s0, $t2, -6
sw $t8, 4($t3)
sllv $s1, $t0, $t7
srlv $s2, $t0, $t7
srav $s3, $t0, $t7

halt