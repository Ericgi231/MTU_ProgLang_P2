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
	li $s1, 2
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
	addi $s0, $gp, 20
#Load variable address
	addi $s1, $gp, 4
#Get variable from address
	lw $s2, 0($s1)
#Load constant integer
	li $s1, 7
#Math operation
	add $s3, $s2, $s1
#Assign value to address
	sw $s3, 0($s0)
#Load variable address
	addi $s0, $gp, 20
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
	addi $s0, $gp, 24
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s2, 0($s1)
#Load constant integer
	li $s1, 5
#Math operation
	sub $s3, $s2, $s1
#Assign value to address
	sw $s3, 0($s0)
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
	addi $s0, $gp, 8
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 12
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	mul $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s2, 0($s1)
#Math operation
	mul $s1, $s0, $s2
#Write integer
	li $v0, 1
	move $a0, $s1
	syscall
#Write new line
	li $v0, 4
	la $a0, .newline
	syscall
#Load variable address
	addi $s0, $gp, 8
#Get variable from address
	lw $s1, 0($s0)
#Load variable address
	addi $s0, $gp, 12
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	mul $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s2, 0($s1)
#Math operation
	sub $s1, $s0, $s2
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
	addi $s0, $gp, 8
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	add $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 16
#Get variable from address
	lw $s3, 0($s1)
#Math operation
	mul $s1, $s2, $s3
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
#Math operation
	div $s1, $s0, $s2
#Load variable address
	addi $s0, $gp, 4
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	sub $s0, $s1, $s2
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
	addi $s0, $gp, 8
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	add $s0, $s1, $s2
#Load variable address
	addi $s1, $gp, 12
#Get variable from address
	lw $s2, 0($s1)
#Load variable address
	addi $s1, $gp, 4
#Get variable from address
	lw $s3, 0($s1)
#Load variable address
	addi $s1, $gp, 20
#Get variable from address
	lw $s4, 0($s1)
#Math operation
	mul $s1, $s3, $s4
#Math operation
	add $s3, $s2, $s1
#Math operation
	mul $s1, $s0, $s3
#Load variable address
	addi $s0, $gp, 24
#Get variable from address
	lw $s2, 0($s0)
#Math operation
	div $s0, $s1, $s2
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
