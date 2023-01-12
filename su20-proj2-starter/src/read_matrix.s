.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp,sp,-24
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    
    
    
    mv s0,a0
    mv s1,a1
    mv s2,a2
    #fopen
    mv a1,s0
    li a2,0
    jal fopen
    li t0,-1
    beq a0,t0,exit_50
    mv s3,a0 #fread
    mv a1,s3
    mv a2,s1
    li a3,4
    jal fread
    li t0,4
    bne a0,t0,exit_51
    lw s1,0(s1)   #rows
    mv a1,s3
    mv a2,s2
    li a3,4
    jal fread
    li t0,4
    bne a0,t0,exit_51
    lw s2,0(s2)   #cols
    mul t1,s1,s2
    slli t1,t1,2
    #malloc
    mv a0,t1
    jal malloc
    mv s4,a0
    #fread
    
    mv a1,s3
    mv a2,s4
    mv a3,t1
    jal fread
    bne a0,t1,exit_51
    
    mv a1,s3
    jal fclose
    li t0,-1
    beq a0,t0,exit_52
    mv a0,s4
    
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    addi sp,sp,24
    ret
    
    

exit_50:
    li a1, 50
    j exit2

exit_51:
    li a1, 51
    j exit2

exit_52:
    li a1, 52
    j exit2