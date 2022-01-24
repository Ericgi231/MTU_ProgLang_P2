	.data
.newline: .asciiz "\n"
.string0: .asciiz "i = "
.string1: .asciiz "j = "
.string2: .asciiz "k = "
.string3: .asciiz "l = "
.string4: .asciiz "m = "
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
#Load variable address
	addi $s0, $gp, 8
#Read integer
	li $v0, 5
	syscall
	sw $v0, 0($s0)
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
#Load variable address
	addi $s0, $gp, 12
#Read integer
	li $v0, 5
	syscall
	sw $v0, 0($s0)
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
#Load variable address
	addi $s0, $gp, 16
#Read integer
	li $v0, 5
	syscall
	sw $v0, 0($s0)
#Load constant string
	la $s0, .string4
#Write string
	li $v0, 4
	move $a0, $s0
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 20
#Read integer
	li $v0, 5
	syscall
	sw $v0, 0($s0)
#Load variable address
	addi $s0, $gp, 24
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 8
#Get variable from address
	lw $s3, 0($s1)
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s4, 0($s1)
#Math operation
	add $s1, $s3, $s4
#Compare operation
	slt $s3, $s2, $s1
#Load variable address
	addi $s1, $gp, 4
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s4, 0($s1)
#Compare operation
	sne $s1, $s2, $s4
#Bitwise operation
	xori $s2, $s1, 1
#Bitwise operation
	and $s1, $s3, $s2
#Assign value to address
	sw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 24
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
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 16
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	mul $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 8
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s3, 0($s1)
#Math operation
	mul $s1, $s2, $s3
#Compare operation
	sgt $s2, $s0, $s1
#Load constant integer
	li $s0, 1
#Load variable address
	addi $s1, $gp, 20
#Get variable from address
	lw $s3, 0($s1)
#Compare operation
	sle $s1, $s0, $s3
#Bitwise operation
	or $s0, $s2, $s1
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
	addi $s0, $gp, 16
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	mul $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 8
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s3, 0($s1)
#Math operation
	add $s1, $s2, $s3
#Load variable address
	addi $s2, $gp, 16
#Get variable from address
	lw $s3, 0($s2)
#Math operation
	add $s2, $s1, $s3
#Compare operation
	sgt $s1, $s0, $s2
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s2, 0($s0)
#Load variable address
	addi $s0, $gp, 8
#Get variable from address
	lw $s3, 0($s0)
#Compare operation
	sne $s0, $s2, $s3
#Bitwise operation
	and $s2, $s1, $s0
#Load variable address
	addi $s0, $gp, 16
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 24
#Get variable from address
	lw $s3, 0($s0)
#Compare operation
	sgt $s0, $s1, $s3
#Bitwise operation
	or $s1, $s2, $s0
#Write integer
	li $v0, 1
	move $a0, $s1
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
	addi $s0, $gp, 8
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	div $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 4
#Get variable from address
	lw $s2, 0($s1)
#Math operation
	sub $s1, $s0, $s2
#Load variable address
	addi $s0, $gp, 20
#Get variable from address
	lw $s2, 0($s0)
#Compare operation
	sgt $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s3, 0($s1)
#Load variable address
	addi $s1, $gp, 24
#Get variable from address
	lw $s4, 0($s1)
#Math operation
	mul $s1, $s3, $s4
#Math operation
	add $s3, $s2, $s1
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s4, 0($s1)
#Load variable address
	addi $s1, $gp, 24
#Get variable from address
	lw $s5, 0($s1)
#Math operation
	mul $s1, $s4, $s5
#Math operation
	add $s4, $s2, $s1
#Compare operation
	sne $s1, $s3, $s4
#Bitwise operation
	and $s2, $s0, $s1
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
