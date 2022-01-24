	.data
.newline: .asciiz "\n"
	.text
	.globl main
main:	nop
	move $fp, $sp
#Load constant integer
	li $s0, 10
#Load constant integer
	li $s1, 20
#Math operation
	sub $s2, $s0, $s1
#Write integer
	li $v0, 1
	move $a0, $s2
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 4
#Load constant integer
	li $s1, 77
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 12
#Load constant integer
	li $s1, 3
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 16
#Load constant integer
	li $s1, 4
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Load variable address
	addi $s1, $gp, 4
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s3, 0($s1)
#Math operation
	sub $s1, $s2, $s3
#Load variable address
	addi $s2, $gp, 16
#Get variable from address
	lw $s3, 0($s2)
#Math operation
	sub $s2, $s1, $s3
#Assign value to address
	sw $s2, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Get variable from address
	lw $s1, 0($s0)
#Write integer
	li $v0, 1
	move $a0, $s1
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#End program
	li $v0, 10
	syscall
