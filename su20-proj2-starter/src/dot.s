.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    ble a2,x0,exit_5
    ble a3,x0,exit_6
    ble a4,x0,exit_6
    addi sp,sp,-12
    sw s0,0(sp)#sum
    sw s1,4(sp)
    sw s2,8(sp)
    addi t3,x0,4
    mul t0,a3,t3
    mul t1,a4,t3
    mv t4,zero#count
    mv s0,zero

    # Prologue


loop_start:
    lw s1,0(a0)
    lw s2,0(a1)
    mul s1,s1,s2
    add s0,s0,s1
    add a0,a0,t0
    add a1,a1,t1
    addi t4,t4,,1
    beq t4,a2,loop_end
    j loop_start
loop_end:
    mv a0,s0
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    addi sp,sp,12
    # Epilogue

    
    ret
exit_5:
    li a1,5
    j exit2
exit_6:
    li a1,6
    j exit2