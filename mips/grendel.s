#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
	lui $1, 0x1001
        nop
        nop
        nop
        ori $29, $1, 0x1000
	addiu $fp, $0, 0
	lasw $ra pump
	j main # jump to the starting location
pump:   nop
	halt


main:   nop
        addiu   $sp,$sp,-40 # MAIN
        nop
        nop
        nop
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add    	$fp,$sp,$zero
        nop
        nop
        nop
        sw      $0,24($fp)
        nop
        nop
        nop
        j       main_loop_control

main_loop_body: nop
        lw      $4,24($fp)
        lasw 	$ra, trucks
        j     is_visited
        trucks: nop

        xori    $2,$2,0x1
        nop
        nop
        nop
        andi    $2,$2,0x00ff
        nop
        nop
        nop
        beq     $2,$0,kick
        nop
        lw      $4,24($fp)
        # addi 	$k0, $k0,1# breakpoint
        lasw 	$ra, billowy
        j     	topsort
        billowy:

kick:   nop
        lw      $2,24($fp)
        nop
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        nop
        sw      $2,24($fp)
        nop
        nop
main_loop_control: nop
        lw      $2,24($fp)
        nop
        nop
        nop
        slti     $2,$2, 4
        nop
        nop
        nop
        beq	$2, $zero, hew # beq, j to simulate bne 
        nop
        j       main_loop_body
        hew: nop
        sw      $0,28($fp)
        j       welcome

wave: nop
        lw      $2,28($fp)
        nop
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        nop
        sw      $2,28($fp)
        nop
        nop
welcome: nop
        lw      $2,28($fp)
        nop
        nop
        nop
        slti    $2,$2,4
        nop
        nop
        nop
        xori	$2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop
        nop
        nop
        beq     $2,$0,wave
        nop
        move    $2,$0
        move    $sp,$fp
        nop
        nop
        nop
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        nop
        jr       $ra
        
interest: nop
        lw      $4,24($fp)
        lasw	$ra, new
        j	is_visited
	new: nop
        xori    $2,$2,0x1
        nop
        nop
        nop
        andi    $2,$2,0x00ff
        nop
        nop
        nop
        beq     $2,$0,tasteful
        nop
        lw      $4,24($fp)
        lasw	$ra, partner
        j     	topsort
        partner:

tasteful: nop
        addiu   $2,$fp,28
        nop
        nop
        nop
        move    $4,$2
        lasw	$ra, badge
        j     next_edge
        badge: nop
        sw      $2,24($fp)
        nop
        nop        
turkey: nop
        lw      $3,24($fp)
        li      $2,-1
        nop
        nop
        nop
        beq	$3,$2,telling # beq, j to simulate bne
        nop
        j	interest
        telling: nop
	lasw 	$v0, res_idx
        nop
        nop
        nop
	lw	$v0, 0($v0)
        nop
        nop
        nop
        addiu   $4,$2,-1
        lasw 	$3, res_idx
        nop
        nop
        nop
        sw 	$4, 0($3)
        lasw	$4, res
        #lui     $3,%hi(res_idx)
        #sw      $4,%lo(res_idx)($3)
        #lui     $4,%hi(res)
        sll     $3,$2,2
        nop
        nop
        nop
        srl	$3,$3,1
        nop
        nop
        nop
        sra	$3,$3,1
        nop
        nop
        nop
        sll     $3,$3,2
       
       	xor	$at, $ra, $2 # does nothing 
        nor	$at, $ra, $2 # does nothing 
        
        lasw	$2, res
        nop
        nop
        nop
        andi	$at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        nop
        nop
        nop
        addu 	$2, $4, $at
        nop
        nop
        nop
        addu    $2,$3,$2
        lw      $3,48($fp)
        nop
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop
        nop
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        nop
        jr      $ra
   
topsort: nop
        addiu   $sp,$sp,-48
        nop
        nop
        nop
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        nop
        nop
        nop
        sw      $4,48($fp)
        nop
        nop
        nop
        lw      $4,48($fp)
        lasw	$ra, verse
        j	mark_visited
        verse: nop

        addiu   $2,$fp,28
        lw      $5,48($fp)
        nop
        nop
        move    $4,$2
        lasw 	$ra, joyous
        j	iterate_edges
        joyous: nop

        addiu   $2,$fp,28
        nop
        nop
        nop
        move    $4,$2
        lasw	$ra, whispering
        j     	next_edge
        whispering: nop

        sw      $2,24($fp)
        nop
        nop
        nop
        j       turkey

iterate_edges: nop
        addiu   $sp,$sp,-24
        nop
        nop
        nop
        sw      $fp,20($sp)
        move    $fp,$sp
        nop
        nop
        nop
        subu	$at, $fp, $sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        nop
        nop
        nop
        lw      $2,28($fp)
        nop
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        lw      $2,24($fp)
        nop
        lw      $4,8($fp)
        lw      $3,12($fp)
        nop
        nop
        sw      $4,0($2)
        sw      $3,4($2)
        lw      $2,24($fp)
        move    $sp,$fp
        nop
        nop
        nop
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        nop
        jr      $ra
        
next_edge: nop
        addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw      $31,28($sp)
        sw      $fp,24($sp)
        add	$fp,$zero,$sp
        nop
        nop
        nop
        sw      $4,32($fp)
        nop
        nop
        nop
        j       waggish

snail: nop
        lw      $2,32($fp)
        nop
        nop
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        nop
        move    $5,$2
        move    $4,$3
        lasw	$ra,induce
        j       has_edge
        induce: nop
        beq     $2,$0,quarter
        nop
        lw      $2,32($fp)
        nop
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        nop
        addiu   $4,$2,1
        lw      $3,32($fp)
        nop
        nop
        nop
        sw      $4,4($3)
        j       cynical


quarter: nop
        lw      $2,32($fp)
        nop
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        nop
        addiu   $3,$2,1
        lw      $2,32($fp)
        nop
        nop
        nop
        sw      $3,4($2)

waggish: nop
        lw      $2,32($fp)
        nop
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        nop
        slti    $2,$2,4
        nop
        nop
        nop
        beq	$2,$zero,mark # beq, j to simulate bne 
        nop
        j	snail
        mark: nop
        li      $2,-1

cynical: nop
        move    $sp,$fp
        nop
        nop
        nop
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        nop
        jr      $ra
has_edge: nop
        addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        nop
        sw      $4,32($fp)
        sw      $5,36($fp)
        lasw      $2,adjacencymatrix
        lw      $3,32($fp)
        nop
        nop
        nop
        sll     $3,$3,2
        nop
        nop
        nop
        addu    $2,$3,$2
        nop
        nop
        nop
        lw      $2,0($2)
        nop
        nop
        nop
        sw      $2,16($fp)
        li      $2,1
        nop
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        nop
        nop
        nop
        j       measley

look: nop
        lw      $2,8($fp)
        nop
        nop
        nop
        sll     $2,$2,1
        nop
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        nop
        sw      $2,12($fp)
        nop
        nop
measley: nop
        lw      $3,12($fp)
        lw      $2,36($fp)
        nop
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        nop
        beq     $2,$0,experience # beq, j to simulate bne 
        nop
        j 	look
       	experience: nop
        lw      $3,8($fp)
        lw      $2,16($fp)
        nop
        nop
        nop
        and     $2,$3,$2
        nop
        nop
        nop
        slt     $2,$0,$2
        nop
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        
mark_visited: nop
        addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        nop
        sw      $4,32($fp)
        li      $2,1
        nop
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        nop
        nop
        nop
        j       recast

example: nop
        lw      $2,8($fp)
        nop
        nop
        nop
        sll     $2,$2,8
        nop
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        nop
        sw      $2,12($fp)
        nop
        nop
recast: nop
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        nop
        beq	$2,$zero,pat # beq, j to simulate bne
        nop
        j	example
        pat: nop

       	lasw	$2, visited
        nop
        nop
        nop
        sw      $2,16($fp)
        nop
        nop
        nop
        lw      $2,16($fp)
        nop
        nop
        nop
        lw      $3,0($2)
        lw      $2,8($fp)
        nop
        nop
        nop
        or      $3,$3,$2
        lw      $2,16($fp)
        nop
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        nop
        jr      $ra
        
is_visited: nop
        addiu   $sp,$sp,-32
        nop
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        nop
        sw      $4,32($fp)
        ori     $2,$zero,1
        nop
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        nop
        nop
        nop
        j       evasive

justify: nop
        lw      $2,8($fp)
        nop
        nop
        nop
        sll     $2,$2,8
        nop
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        nop
        sw      $2,12($fp)
        nop
        nop
evasive: nop
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        nop
        beq	$2,$0,representitive # beq, j to simulate bne
        nop
        j     	justify
        representitive: nop

        lasw	$2,visited
        nop
        nop
        nop
        lw      $2,0($2)
        nop
        nop
        nop
        sw      $2,16($fp)
        nop
        nop
        nop
        lw      $3,16($fp)
        lw      $2,8($fp)
        nop
        nop
        nop
        and     $2,$3,$2
        nop
        nop
        nop
        slt     $2,$0,$2
        nop
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
