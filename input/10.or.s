	.data
.newline: .asciiz "\n"
	.text
	.globl main
main:	nop
	move $fp, $sp
#Load variable address
	addi $s0, $gp, 4
#Load constant integer
	li $s1, 1
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Load constant integer
	li $s1, 0
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 12
#Load constant integer
	li $s1, 0
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 16
#Load constant integer
	li $s1, 1
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Get variable from address
	lw $s2, 0($s0)
#Bitwise operation
	or $s0, $s1, $s2
#Write integer
	li $v0, 1
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s2, 0($s0)
#Bitwise operation
	or $s0, $s1, $s2
#Write integer
	li $v0, 1
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 16
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 12
#Get variable from address
	lw $s2, 0($s0)
#Bitwise operation
	or $s0, $s1, $s2
#Write integer
	li $v0, 1
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 12
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Get variable from address
	lw $s2, 0($s0)
#Bitwise operation
	or $s0, $s1, $s2
#Write integer
	li $v0, 1
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#End program
	li $v0, 10
	syscall
