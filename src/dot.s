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
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
test0:
    bgt a2, zero, test1
    li a0, 75
    li a7, 93
    ecall
test1:
    bgt a3, zero, test2
    li a0, 76
    li a7, 93
    ecall
test2:
    bgt a4, zero, testfinished
    li a0, 76
    li a7, 93
    ecall
testfinished:
    mv t5, zero
    addi t2, zero, 4
    mul a3, a3, t2
    mul a4, a4, t2

loop_start:
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul t3, t0, t1
    add t5, t5, t3
    addi a2, a2, -1
    beq a2, zero, loop_end
    add a0, a0, a3
    add a1, a1, a4
    j loop_start


loop_end:
    mv a0, t5

    # Epilogue

    
    ret
