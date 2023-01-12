.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory

    la a0,file_path
    jal read_matrix


    # Print out elements of matrix
    


    # Terminate the program