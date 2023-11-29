.data
size: .word 6 # Size N stored at 0x10010000
num: .word 23 76 14 -45 15 0 # Array stored at 0x10010004

.text

# Load &num into $t0
lui $t0, 0x1001
nop
nop
nop
ori $t0, $t0, 4 # Set $t0 to &num
nop
nop
nop

# Load N-1 into $t1
lw $t1, -4($t0) # Load N into $t1

# Set variables i ($t2) to -1
addi $t2, $0, -1

nop
nop
addi $t1, $t1, -1

outer:
# Check for outer loop
nop
addi $t2, $t2, 1
nop
nop
nop
slt $t7, $t2, $t1
nop
nop
nop
beq $t7, $0, Exit
nop

add $t4, $0, $0 # Set swapRequired ($t4) to 0 (false)
sub $t5, $t1, $t2 # Set $t5 to N-i-1
nop
nop
nop
sll $t5, $t5, 2 # Multiply $t5 by 4
addi $t3, $0, -4 # Set j*4 ($t3) to -4
nop
nop

inner:
# Check for inner loop
nop
addi $t3, $t3, 4
nop
nop
nop
slt $t7, $t3, $t5
nop
nop
nop
beq $t7, $0, checkSwap
nop

add $t6, $t0, $t3 # Set $t6 to j*4 + &num
nop
nop
nop

# Check if num[j + 1] < num[j]
lw $t8, 4($t6) # Load num[j + 1] into $t8
lw $t9, 0($t6) # Load num[j] into $t9
nop
nop
nop
slt $t7, $t8, $t9
nop
nop
nop
beq $t7, $0, inner
nop

# Swap $t8 and $t9
sw $t9, 4($t6)
sw $t8, 0($t6)
ori $t4, $t4, 1 # Set swapRequired to 1 (true)
j inner
nop

checkSwap:
# Check if swapRequired is true
nop
blez $t4, Exit
nop
j outer
nop

Exit:
nop
halt
