.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    # End prologue
    li t0, 0
    ble a1, x0, relu_error
    
loop_start:
    bge t0, a1, loop_end
    slli t1, t0, 2
    add t3, a0, t1
    
    lw t2, 0(t3)
    blt t2, x0, set_zero
    j loop_continue

set_zero:
    sw x0 0(t3)

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    # End Epilogue
    jr ra
    
 relu_error:
    li a0, 36
    j exit
