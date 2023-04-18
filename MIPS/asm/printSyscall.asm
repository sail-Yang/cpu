.data
	myInteger:	.word 100
	#myinteger: .word 50
	myString:	.asciiz "Hello world!"
	myFloat:	.float 3.14
	myDouble:	.double 3.1415926 
.text
.globl main
main:
	# print Integer(word 32bit)
	li $v0,1
	lw $a0,myInteger
	syscall
	
	# print String 
	li $v0,4
	la $a0,myString
	syscall
	
	# print float
	li $v0,2
	lwc1 $f12,myFloat
	syscall	
	
	# print Double
	li $v0,3
	ldc1 $f12,myDouble
	syscall
	
	# program end
	li $v0,10
	syscall
	