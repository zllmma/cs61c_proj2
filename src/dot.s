.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    ebreak
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    ble a2, x0, length_err
    ble a3, x0, stride_err
    ble a4, x0, stride_err
    
    mv s0, a0 # copy the address of arr0
    mv s1, a1 # copy the address of arr1
    li s2, 0 # number of elements used
    li t0, 0 # the current index of arr0
    li t1, 0 # the current index of arr1
    li a0, 0 # result
    
loop_start:
    bge s2, a2, loop_end
    
    slli t2, t0, 2
    slli t3, t1, 2
    add t2, s0, t2
    add t3, s1, t3
    
    lw t4, 0(t2)
    lw t5, 0(t3)
    mul t6, t4, t5
    add a0, a0, t6
    
    addi s2, s2, 1
    add t0, t0, a3
    add t1, t1, a4
    j loop_start
    
loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    jr ra
    
length_err:
    lw s0, 0(sp)
    lw s1, 8(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    li a0, 36
    j exit

stride_err:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    li a0 37
    j exit
