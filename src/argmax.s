.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    addi sp, sp, -4
    sw s0, 0(sp)
    
    ble a1, x0, arg_max_error
    mv s0, a0 # copy the address of array
    li t0, 0 # curr index 
    li a0, 0 # max index
    
loop_start:
    beq t0, a1, loop_end # if curr_index == length, end the loop
    
    slli t1, t0, 2
    add t1, s0, t1
    lw t2, 0(t1)
    
    slli t3, a0, 2
    add t3, s0, t3
    lw t4, 0(t3)
    
    bgt t2, t4, set_max
    j loop_continue
    
set_max:
    mv a0, t0
    j loop_continue

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:
    lw s0, 0(sp)
    addi sp, sp, 4
    jr ra
    
arg_max_error:
    lw s0, 0(sp)
    addi sp, sp, 4
    li a0, 36
    j exit
