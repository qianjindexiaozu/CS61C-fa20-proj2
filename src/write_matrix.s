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
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

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

    mv s0, a0
    mv s1, a1
    mv s2, a2       # rows
    mv s3, a3       # cols
    mul s4, a2, a3  # rows * cols

    # open the file
    mv a1, s0
    li a2, 1
    call fopen
    li t5, -1
    beq a0, t5, exit_93
    # describtion
    mv s5, a0

    li a0, 8
    call malloc
    beq a0, zero, exit_88
    sw s2, 0(a0)
    sw s3, 4(a0)
    mv a1, s5
    mv a2, a0
    li a3, 2
    li a4, 4
    call fwrite
    li t0, 2
    bne a0, t0, exit_94

    mv a1, s5
    mv a2, s1
    mv a3, s4
    li a4, 4
    call fwrite
    mul t0, s2, s3
    bne a0, t0, exit_94

    mv a1, s5
    call fclose
    li t5, -1
    beq a0, t5, exit_95
    
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
exit_93:
    li a1, 93
    call exit2
exit_94:
    li a1, 94
    call exit2
exit_95:
    li a1, 95
    call exit2


    ret
