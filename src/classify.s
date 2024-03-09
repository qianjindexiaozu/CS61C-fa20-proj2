# .globl classify

# .text
# classify:
#     # =====================================
#     # COMMAND LINE ARGUMENTS
#     # =====================================
#     # Args:
#     #   a0 (int)    argc
#     #   a1 (char**) argv
#     #   a2 (int)    print_classification, if this is zero, 
#     #               you should print the classification. Otherwise,
#     #               this function should not print ANYTHING.
#     # Returns:
#     #   a0 (int)    Classification
#     # Exceptions:
#     # - If there are an incorrect number of command line args,
#     #   this function terminates the program with exit code 89.
#     # - If malloc fails, this function terminats the program with exit code 88.
#     #
#     # Usage:
#     #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

#     li, t5, 5
#     bne t5, a0, exit_89

#     addi sp, sp, -52
#     sw s11, 48(sp)
#     sw s10, 44(sp)
#     sw s9, 40(sp)
#     sw s8, 36(sp)
#     sw s7, 32(sp)
#     sw s6, 28(sp)
#     sw s5, 24(sp)
#     sw s4, 20(sp)
#     sw s3, 16(sp)
#     sw s2, 12(sp)
#     sw s1, 8(sp)
#     sw s0, 4(sp)
#     sw ra, 0(sp)

#     mv s1, a1
#     mv s2, a2
#     lw s3, 4(s1)        # m0 path
#     lw s4, 8(s1)        # m1 path
#     lw s5, 12(s1)        # input path
#     lw s6, 16(s1)       # output path
 
# 	# =====================================
#     # LOAD MATRICES
#     # =====================================
#     li a0, 24
#     call malloc
#     beq zero, a0, exit_88
#     mv s0, a0           # address of rows and cols of m0, m1 and input 

#     # Load pretrained m0
#     mv a1, s0
#     addi a2, a1, 4
#     mv a0, s3
#     call read_matrix
#     mv s7, a0           # address of m0

#     # Load pretrained m1
#     mv a1, s0
#     addi a1, a1, 8
#     addi a2, a1, 4
#     mv a0, s4
#     call read_matrix
#     mv s8, a0           # address of m1

#     # Load input matrix
#     mv a1, s0
#     addi a1, a1, 16
#     addi a2, a1, 4
#     mv a0, s5
#     call read_matrix
#     mv s9, a0           # address of input

#     # =====================================
#     # RUN LAYERS
#     # =====================================
#     # 1. LINEAR LAYER:    m0 * input
#     lw a1, 0(s0)        # rows of m0 and d
#     lw a5, 20(s0)       # cols of input and d
#     mul a0, a1, a5
#     slli a0, a0, 2
#     call malloc
#     beq zero, a0, exit_88
#     lw a1, 0(s0)        # rows of m0 and d
#     lw a2, 4(s0)        # cols of m0
#     mv a3, s9           # address of input
#     lw a4, 16(s0)       # rows of input
#     lw a5, 20(s0)       # cols of input and d
#     mv a6, a0           # address of d
#     mv a0, s7           # address of m0
#     call matmul
#     mv s10, a6          # address of d

#     # 2. NONLINEAR LAYER: ReLU(m0 * input)
#     lw a1, 0(s0)        # rows of m0 and d
#     lw a5, 20(s0)       # cols of input and d
#     mul a1, a1, a5
#     mv a0, s10
#     call relu
#     # j exit_99

#     # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
#     lw a1, 8(s0)        # rows of m1 and output
#     lw a5, 20(s0)       # cols of d and output
#     mul a0, a1, a5
#     slli a0, a0, 2
#     call malloc
#     beq zero, a0, exit_88
#     lw a1, 8(s0)        # rows of m1 and output
#     lw a2, 12(s0)       # cols of m1
#     mv a3, s10          # address of d
#     lw a4, 0(s0)        # rows of d
#     lw a5, 20(s0)       # cols of d and output
#     mv a6, a0           # address of output
#     mv a0, s4           # address of m1
#     call matmul
#     mv s11, a6          # address of output


#     # =====================================
#     # WRITE OUTPUT
#     # =====================================
#     # Write output matrix
#     mv a0, s6
#     mv a1, s11
#     lw a2, 8(s0)
#     lw a3, 20(s0)
#     call write_matrix

#     # =====================================
#     # CALCULATE CLASSIFICATION/LABEL
#     # =====================================
#     # Call argmax
#     mv a0, s6
#     lw t0, 8(s0)
#     lw t1, 20(s0)
#     mul a2, t0, t1
#     call argmax
#     slli t3, a0, 4
#     add t4, s11, t3
#     lw t5, 0(t4)

#     # Print classification
#     bne zero, s2, free_space
#     mv a1, t5
#     call print_int



#     # Print newline afterwards for clarity
#     li a1, 10
#     call print_char

# free_space:
#     mv a0, s0
#     call free
#     mv a0, s7
#     call free
#     mv a0, s8
#     call free
#     mv a0, s9
#     call free
#     mv a0, s10
#     call free
#     mv a0, s11
#     call free

#     mv a0, t5

#     lw ra, 0(sp)
#     lw s0, 4(sp)
#     lw s1, 8(sp)
#     lw s2, 12(sp)
#     lw s3, 16(sp)
#     lw s4, 20(sp)
#     lw s5, 24(sp)
#     lw s6, 28(sp)
#     lw s7, 32(sp)
#     lw s8, 36(sp)
#     lw s9, 40(sp)
#     lw s10, 44(sp)
#     lw s11, 48(sp)
#     addi sp, sp, 52


# end:
#     ret

# exit_88:
#     li a1, 88
#     call exit2
# exit_89:
#     li a1, 89
#     call exit2
# exit_99:
#     li a1, 99
#     call exit2

.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

	# check the number of command line args
	li t0, 5
    bne a0, t0, exit_89
	
    # prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    
    
    
	mv s0, a1 # argv
    mv s1, a2 # flag
	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Load pretrained m0
	li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s2, a0    # s2 -> m0.rows, m0.cols
	lw a0, 4(s0) # a0 = argv[1]
    addi a1, s2, 0
    addi a2, s2, 4
    jal read_matrix
    mv s3, a0    # s3 -> m0
    
    # Load pretrained m1
	li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s4, a0    # s4 -> m1.rows, m1.cols
    lw a0, 8(s0) # a0 = argv[2]
    addi a1, s4, 0
    addi a2, s4, 4
    jal read_matrix
    mv s5, a0    # s5 -> m1
    
    # Load input matrix
	li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s6, a0	  # s6 -> input.rows, input.cols
    lw a0, 12(s0) # a0 = argv[3]
    addi a1, s6, 0
    addi a2, s6, 4
	jal read_matrix
    mv s7, a0	  # s7 -> input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	
    # allocate memory for hidden layer
    lw t0, 0(s2)
    lw t1, 4(s6)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_88
    mv s8, a0     # s8 -> hidden_layer
    # hidden_layer = m0 * input
	mv a0, s3
	lw a1, 0(s2)
	lw a2, 4(s2)
	mv a3, s7
    lw a4, 0(s6)
	lw a5, 4(s6)
	mv a6, s8
	jal matmul
    
    # ReLU(hidden_layer)
	lw t0, 0(s2)
    lw t1, 4(s6)
    mul a1, t0, t1 # number of elements in the array
    mv a0, s8
    jal relu
    
    # allocate memory for scores
    li a0, 80
    jal malloc
    beq a0, x0, exit_88
    mv s9, a0 # s9 -> scores
    # scores = matmul(m1, hidden_layer)
	mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s8
    lw a4, 0(s2)
    lw a5, 4(s6)
    mv a6, s9
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
	lw a0, 16(s0) # argv[4]
    mv a1, s9
    lw a2, 0(s4)
    lw a3, 4(s6)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s9
    li a1, 10
    jal argmax
	mv s10, a0 # classification
    
    bne s1, x0, not_print
    # Print classification
    mv a1, s10
    jal print_int

    # Print newline afterwards for clarity
	li a1 '\n'
    jal print_char
    
not_print:
	# free the space
	mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    
    mv a0, s10 # return classification
    
    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret

exit_89:
	li a1, 89
    jal exit2
    
exit_88:
	li a1, 88
    jal exit2