.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    # End Prologue

    mv s0, a1 # the pointer to the start of the matrix
    mv s1, a2 # row number
    mv s2, a3 # col number
    
    # Open the file
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0, fopen_err
    mv s3, a0 # the file descriptor
    
    # Write the row and col number to file
    addi sp, sp, -8
    sw s1, 0(sp)
    sw s2, 4(sp)
    
    # Row
    mv a0, s3
    addi a1, sp, 0
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, fwrite_err
    
    # Col
    mv a0, s3
    addi a1, sp, 4
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, fwrite_err
    
    lw s1, 0(sp)
    lw s2, 4(sp)
    addi sp, sp, 8
    
    # Write the matrix data
    mv a0, s3
    mv a1, s0
    mul t0, s1, s2
    mv a2, t0
    li a3, 4
    jal fwrite
    mul t0, s1, s2
    bne a0, t0, fwrite_err
    
    # Close the file
    mv a0, s3
    jal fclose
    bne a0, x0, fclose_err
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    # End epilogue
    jr ra

fopen_err:
    li a0, 27
    j exit
    
fwrite_err:
    li a0, 30
    j exit
    
fclose_err:
    li a0, 28
    j exit