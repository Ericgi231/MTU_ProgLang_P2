	.data
.newline: .asciiz "\n"
.string0: .asciiz "Your grader"
.string1: .asciiz "will put"
.string2: .asciiz "a random"
.string3: .asciiz "string here"
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
#Load constant string
	la $s0, .string1
#Write string
	li $v0, 4
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load constant string
	la $s0, .string2
#Write string
	li $v0, 4
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load constant string
	la $s0, .string3
#Write string
	li $v0, 4
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#End program
	li $v0, 10
	syscall
