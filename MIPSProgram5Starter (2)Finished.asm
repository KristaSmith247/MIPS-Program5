# Author: Krista Smith
# Date: 12/9/23
# Description: Parse MIPS instructions based on opcode and print message
	

.globl main, decode_instruction, process_instruction, print_hex_info, print_opcode_type			# Do not remove this line
	

# Data for the program goes here
.data
	process: .asciiz "\nNow processing instruction "
	opcode_num: .asciiz "\tThe opcode value is: "
	newLine: .asciiz "\n"
	

	# number of test cases
	CASES: .word 5
	# array of pointers (addresses) to the instructions
	# ORIGINAL
	instructions:	.word 0x01095020, 		# add $t2, $t0, $t1
			.word 0x1220002C,  		# beqz $s1, label
			.word 0x3C011001,		# lw $a0, label($s0)
			.word 0x24020004,		# li $v0, 4
			.word 0x08100002		# j label
		
		
	# TEST 1
	#instructions: .word 0x3C011001,	
	#	.word 0x24020004, 
	#	.word 0x08100002, 
	#	.word 0x01095020, 
	#	.word 0x1220002C 
	
	# TEST 2
	#instructions: .asciiz "This is my string test"	
	
	# TEST 3
	#instructions: .word "This is my string test"	
	
	# TEST 4
	#instructions: .word 0xFC011001,	
	#	.word 0xF4020004, 
	#	.word 0xF8100002, 
	#	.word 0xF1095020, 
	#	.word 0xF220002C 
	
		
	
	inst_0:		.asciiz "\tR-Type Instruction\n"
	inst_other:	.asciiz "\tUnsupported Instruction\n"
	inst_2_3:	.asciiz "\tUnconditional Jump\n"
	inst_4_5:	.asciiz "\tConditional Jump\n"
	

	# You may use this array of labels to print the different instructions type messages
	inst_types: .word inst_0, inst_other, inst_2_3, inst_2_3, inst_4_5, inst_4_5
	
# Code goes here
.text
main:
	# Task 1A: Loop over the array of instructions 
	addi $t1, $t1, 0 # initialize loop counter i = 0
	addi $t2, $t2, 0 # initialize instructions[i]
	
loop_array:
	
	bge $t1, 5, end_main # break out of loop when i >= 5
	
	# 	Set registers and call: print_hex_info
	la $a0, process
	lw $a1, instructions($t2)
	jal print_hex_info

	# 	Set registers and call: decode_instruction
	lw $a0, instructions($t2) # 32 bit instruction to process
	jal decode_instruction
	
	# Print first return value
	move $a0, $v0 # move opcode value to a0
	jal print_opcode_type

	# Update branch and index values
	addi $t1, $t1, 1 # i += 1
	addi $t2, $t2, 4 # instructions[i] += 4
	j loop_array		# end of loop
			
		
end_main:
	li $v0, 10		# 10 is the exit program syscall
	syscall			# execute call
###############################################################
	

## Other procedures here
	

###############################################################
# Print Message based on opcode type
#
# $a0 - Message to print
# $a1 - Value to print
# Uses $s0: address of string for $a0 (required)
# Uses $s1: value from $a1 (required)
print_hex_info:
	##### Begin Save registers to Stack
	subi  $sp, $sp, 36
	sw   $ra, 32($sp)
	sw   $s0, 28($sp)
	sw   $s1, 24($sp)
	sw   $s2, 20($sp)
	sw   $s3, 16($sp)
	sw   $s4, 12($sp)
	sw   $s5, 8($sp)
	sw   $s6, 4($sp)
	sw   $s7, 0($sp)
	##### End Save registers to Stack
	
	move $s0, $a0
	move $s1, $a1
		
	li $v0, 4				# print message
	move $a0, $s0
	syscall
		
	li $v0, 34				# print address in hex value
	move $a0, $s1
	syscall
		
	li $v0, 4				# print message
	la $a0, newLine
	syscall
	

end_print_hex_info:
	##### Begin Restore registers from Stack
	lw   $ra, 32($sp)
	lw   $s0, 28($sp)
	lw   $s1, 24($sp)
	lw   $s2, 20($sp)
	lw   $s3, 16($sp)
	lw   $s4, 12($sp)
	lw   $s5, 8($sp)
	lw   $s6, 4($sp)
	lw   $s7, 0($sp)
	addi $sp, $sp, 36
	##### End Restore registers from Stack
		
    jr $ra
###############################################################



###############################################################
# Fetch instruction to correct procedure based on opcode for
# instruction parsing.
# Argument parameters:
# $a0 - input, 32-bit instruction to process (required)
# Return Value:
# $v0 - output, instruction opcode (bits 31-26) value (required)
# Uses:
# $s0: for input parameter (required)
# $s1: for opcode value (required)
decode_instruction:
# Save registers to Stack
	subi $sp, $sp, 36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
# End Save

	move $s0, $a0 # move 32 bit instruction
	move $s1, $a1 
# Isolate opcode (bits 31-26) 1111 1100 0000 0000 0000 0000 0000 0000
	andi $s0, $s0, 0xFC000000
	
# Right shift the opcode 26 positions
	srl $s0, $s0, 26

# Task 3 (later): Set/Values call process_instruction_procedure
	move $a0, $s0
	move $a1, $s1
	jal process_instruction
# Set return value (opcode value)
	move $v0, $s0

end_decode_instruction:
# Restore registers from Stack
	lw $ra, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)
	addi $sp, $sp, 36
# End Restore
	jr $ra
###############################################################



###############################################################
# Function to test the decode procedure
# Argument parameters:
# $a0 - opcode value
# Return Value:
# $v0 - opcode value
# Uses:
# $s0:  opcode value (required)
process_instruction:
# Save registers to Stack
	subi $sp, $sp, 36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
# End Save
	
	move $s0, $a0 # move input to $s0
	
	li $v0, 4	# print opcode message
	la $a0, opcode_num
	syscall
	
	li $v0, 34	# print opcode value
	la $a0, ($s0)
	syscall
	
	li $v0, 4	# print newline
	la $a0, newLine
	syscall
	
	move $v0, $s0 # return opcode value

end_process_instruction:
# Restore registers from Stack
	lw $ra, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)
	addi $sp, $sp, 36
# End Restore
	jr $ra
###############################################################



###############################################################
# Function to print the opcode
# Argument parameters:
# $a0 - input (opcode value)
# Return Value: None
# Uses:
# $s0:  opcode value (required)
print_opcode_type:
# Save registers to Stack
	subi $sp, $sp, 36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
# End Save
# save input parameters
	move $s0, $a0 # move opcode value to s0

# switch-case statement for printing
	# set up branch to default
	bltz $s0, default # if $s0 is somehow < 0; branch to default
	bgt $s0, 5, default # if $s0 exceeds case5: branch to default
case0:
	# inst_0: R-Type Instruction
	bne $s0, 0, case2
	li $v0, 4
	la $a0, inst_0
	syscall
	j end_print_opcode_type
case2:
case3:
	# inst_2_3: Unconditional Jump
	bge $s0, 4, case4 # branch to case4 if value > 2, 3
	li $v0, 4
	la $a0, inst_2_3
	syscall
	j end_print_opcode_type
case4:
case5:
	# inst_4_5: Conditional Jump
	li $v0, 4
	la $a0, inst_4_5
	syscall
	j end_print_opcode_type
default:
	# inst_other: Unsupported Instruction
	li $v0, 4
	la $a0, inst_other
	syscall

end_print_opcode_type:
# Restore registers from Stack
	lw $ra, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)
	addi $sp, $sp, 36
# End Restore
	jr $ra
###############################################################
