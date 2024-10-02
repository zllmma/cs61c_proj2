.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # Check the number of args
    li t0, 5
    bne a0, t0, args_err
    
    # =========
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    # =========
    
    lw s0, 4(a1)  # pointer to filepath string of m0
    lw s1, 8(a1)  # pointer to filepath string of m1
    lw s2, 12(a1) # pointer to filepath string of input
    lw s3, 16(a1) # pointer to filepath string of output file
    mv s10, a2    # silent mode
    # Read pretrained m0
    li a0, 4
    jal malloc
    beq a0, x0, malloc_err
    mv t1, a0 # pointer to row number
    
    li a0, 4
    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    lw t1, 0(sp)
    addi sp, sp, 4
    beq a0, x0, malloc_err
    mv t2, a0 # pointer to col number
    
    mv a0, s0
    mv a1, t1
    mv a2, t2
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)
    jal read_matrix
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    mv s0, a0 # pointer to m0 
    lw s4, 0(t1) # row number of m0
    lw s5, 0(t2) # col number of m0
    mv a0, t1
    addi sp, sp, -4
    sw t2, 0(sp)
    jal free
    lw t2, 0(sp)
    addi sp, sp, 4
    mv a0, t2
    jal free
    
    # Read pretrained m1
    li a0, 4
    jal malloc
    beq a0, x0, malloc_err
    mv t1, a0 # pointer to row number
    
    li a0, 4
    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    lw t1, 0(sp)
    addi sp, sp, 4
    beq a0, x0, malloc_err
    mv t2, a0 # pointer to col number
    
    mv a0, s1
    mv a1, t1
    mv a2, t2
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)
    jal read_matrix
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    mv s1, a0 # pointer to m1 
    lw s6, 0(t1) # row number of m1
    lw s7, 0(t2) # col number of m1
    mv a0, t1
    addi sp, sp, -4
    sw t2, 0(sp)
    jal free
    lw t2, 0(sp)
    addi sp, sp, 4
    mv a0, t2
    jal free

    # Read input matrix
    li a0, 4
    jal malloc
    beq a0, x0, malloc_err
    mv t1, a0 # pointer to row number
    
    li a0, 4
    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    lw t1, 0(sp)
    addi sp, sp, 4
    beq a0, x0, malloc_err
    mv t2, a0 # pointer to col number
    
    mv a0, s2
    mv a1, t1
    mv a2, t2
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)
    jal read_matrix
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    mv s2, a0 # pointer to input
    lw s8, 0(t1) # row number of input
    lw s9, 0(t2) # col number of input
    mv a0, t1
    addi sp, sp, -4
    sw t2, 0(sp)
    jal free
    lw t2, 0(sp)
    addi sp, sp, 4
    mv a0, t2
    jal free
   
    # Compute h = matmul(m0, input)
    li a0, 4
    mul a0, a0, s4
    mul a0, a0, s9
    jal malloc
    beq a0, x0, malloc_err
    mv a6, a0
    mv a0, s0
    mv a1, s4
    mv a2, s5
    mv a3, s2
    mv a4, s8
    mv a5, s9
    addi sp, sp, -4
    sw a6, 0(sp)
    jal matmul
    mv a0, s0
    jal free
    lw a6, 0(sp)
    addi sp, sp, 4
    mv s0, a6 # pointer to h
    mv s4, s4 # row number of h
    mv s5, s9 # col number of h
    
    # Compute h = relu(h)
    mv a0, s0
    mul a1, s4, s5
    jal relu
    
    # Compute o = matmul(m1, h)
    li a0, 4
    mul a0, a0, s6
    mul a0, a0, s5
    jal malloc
    beq a0, x0, malloc_err
    mv a6, a0
    mv a0, s1
    mv a1, s6
    mv a2, s7
    mv a3, s0
    mv a4, s4
    mv a5, s5
    addi sp, sp, -4
    sw a6, 0(sp)
    jal matmul
    mv a0, s1
    jal free
    lw a6, 0(sp)
    addi sp, sp, 4
    mv s1, a6 # pointer to o
    mv s6, s6 # row number of o
    mv s7, s5 # col number of o
    
    # Write output matrix o
    mv a0, s3
    mv a1, s1
    mv a2, s6
    mv a3, s7
    jal write_matrix
    
    # Compute and return argmax(o)
    mv a0, s1
    mul a1, s6, s7
    jal argmax
    beq s10, x0, print_argmax
    j end
    
print_argmax:
    # If enabled, print argmax(o) and newline
    mv t0, a0
    addi sp, sp, -4
    sw t0, 0(sp)
    jal print_int
    li a0, '\n'
    jal print_char
    lw t0, 0(sp)
    addi sp, sp, 4
    mv a0, t0
    j end
    
end:
    
    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    lw a0, 0(sp)
    addi sp, sp, 4
    
    # =========
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi, sp, sp, 48
    # =========
    jr ra

args_err:
    li a0, 31
    j exit

malloc_err:
    li a0, 26
    j exit