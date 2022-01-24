	.data
.newline: .asciiz "\n"
.string0: .asciiz "Hello world!"
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
#End program
	li $v0, 10
	syscall
