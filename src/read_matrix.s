.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
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
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -32
    sw s5, 28(sp)
    sw s6, 24(sp)
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)
    mv s5, a1       # address of the # of rows
    mv s6, a2       # address of the # of cols

    # open the file
    mv a1, a0
    li a2, 0
    call fopen
    li t5, -1
    beq a0, t5, exit_90
    # describtion
    mv s0, a0
    # j read_loop_end

    # read the # of rows and cols
    mv a1, s0
    mv a2, s5
    li a3, 4
    call fread
    li t0, 4
    bne a0, t0, exit_91
    mv a1, s0
    mv a2, s6
    li a3, 4
    call fread
    li t0, 4
    bne a0, t0, exit_91
    # the # of rows
    lw s1, 0(s5)
    # the # of cols
    lw s2, 0(s6)
    mul s3, s1, s2

    # malloc memory
    mv a0, s3
    li t4, 4
    mul a0, a0, t4
    call malloc
    beq zero, a0, exit_88
    # the beginning of the address
    mv s4, a0       
    
    # read the file
    li t0, 0        # i = 0
read_loop_start:
    mv a1, s0
    mv a2, s4
    mul t1, t0, t4                  # offset = i * 4
    add a2, a2, t1                  # place = begin + offset
    li a3, 4
    call fread
    bne a0, t4, exit_91
    addi t0, t0, 1                  # i++
    beq t0, s3, read_loop_end       # if i == top break
    j read_loop_start

read_loop_end:
    mv a1, s0
    call fclose
    li t5, -1
    beq a0, t5, exit_92

    mv a0, s4
    mv a1, s5
    mv a2, s6
    # Epilogue
    lw s4, 0(sp)
    lw s3, 4(sp)
    lw s2, 8(sp)
    lw s1, 12(sp)
    lw s0, 16(sp)
    lw ra, 20(sp)
    lw s6, 24(sp)
    lw s5, 28(sp)
    addi sp, sp, 32

    ret

exit_88:
    li a1, 88
    call exit2
exit_90:
    li a1, 90
    call exit2
exit_91:
    li a1, 91
    call exit2
exit_92:
    li a1, 92
    call exit2