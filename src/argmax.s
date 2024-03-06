.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    bgt a1, zero, loop_start
    li a0, 77
    li a7, 93
    ecall

loop_start:
    lw t1, 0(a0)
    add t4, zero, zero  #目前最大数索引
    add t5, zero, zero  #当前指针位置

loop_continue:
    addi t5, t5, 1
    beq a1, t5, loop_end
    addi a0, a0, 4
    lw t2, 0(a0)
    bge t1, t2, loop_continue
    add t1, t2, zero
    add t4, t5, zero
    j loop_continue

loop_end:
    add a0, t4, zero

    # Epilogue


    ret
