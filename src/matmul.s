.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    
    ble a1, x0, matmul_error
    ble a2, x0, matmul_error
    ble a4, x0, matmul_error
    ble a5, x0, matmul_error
    bne a2, a4, matmul_error
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv t4, a3
    mv s4, a5
   
    
    li t0, 0 # counter of outer_loop
    li t1, 0 # counter of inner_loop
    li t2, 0 # index of output arr
    
outer_loop_start:
    bge t0, s1, outer_loop_end
    
    j inner_loop_start

inner_loop_start:
    bge t1, s4, inner_loop_end
    
    # put the arguments
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s4
    
    # call dot
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw a6, 20(sp)
    
    jal ra, dot
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw a6, 20(sp)
    addi sp, sp, 24
    # end call dot
    
    slli t3, t2, 2
    add t3, a6, t3
    sw a0, 0(t3)
    
    addi t2, t2, 1
    addi t1, t1, 1
    addi s3, s3, 1
    j inner_loop_start

inner_loop_end:
    li t1, 0
    mv s3, t4
    addi t0, t0, 1
    add s0, s0, s2
    j outer_loop_start



outer_loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    jr ra
    
matmul_error:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    li a0 38
    j exit