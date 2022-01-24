	.data
.newline: .asciiz "\n"
.string0: .asciiz "input an integer:"
	.text
	.globl main
main:	nop
	move $fp, $sp
#Load constant string
	la $s0, .string0
#Write string
	li $v0, 4
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 4
#Read integer
	li $v0, 5
	syscall
	sw $v0, 0($s0)
#Load variable address
	addi $s0, $gp, 4
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
#Load constant integer
	li $s0, 1
#Write integer
	li $v0, 1
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load constant integer
	li $s0, 1
#Load constant integer
	li $s1, 2
#Math operation
	add $s2, $s0, $s1
#Write integer
	li $v0, 1
	move $a0, $s2
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#End program
	li $v0, 10
	syscall
