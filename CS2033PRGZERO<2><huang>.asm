.globl main
main:
	la $t1, string #load address of string in t1
	li $s1, 0 #s1=0
	li $s2, 1 #s2=1
	li $v0, 4 #$System call code for print string
	la $a0, input #$address of string to print
	syscall#print
	li $v0, 8 #$System call code for read string
	la $a0, ($t1) #$address where string to be stored
	addi $a1, $zero, 16 #number of character to read
	syscall #print
	j loop#jump to loop
	
loop:
	lb $s6, 0($t1) #load 0 byte of t1 in s6
	jal check #jump and link check
	addi $t1, $t1, 1 #add 1 in t1 store in t1
	j loop

check:
	li $t4, 45 #t4=45
	beq $s6, $t4, negative # if s6=t4, negative
	# if null, exit2
	li $t4, 10 #t4=10
	beq $s6, $t4, exit2 # if s6=t4, exit2
	# if $s6 < 48, exit1
	slti $s0, $s6, 48
	bne $s0, $zero, exit1
	# if $s6 - 58 > 0, exit1
	subi $s0, $s6, 58
	slti $t0, $s0, 0
	beqz $t0, exit1
	# else 
	li $t0, 10 #t0=10
	# should be the same as mul $s1, $s1, $t0
	mult $s1, $t0 
	mflo $s1 
	subi $s6, $s6, 48 #store s6-48 in s6
	add $s1, $s6, $s1 #add s6 and s1 in s1
	jr $ra #return
	
negative:
	li $s2, -1 # s2=-1
	jr $ra # jump to return address in ra

exit1:
	li $v0, 1 #$System call code for print integer
	li $a0, -1 #$integer to print
	syscall #print
	j exit

exit2:
	mul $s1,$s1,$s2 #multiply by s2 and convert it to negative  
	li $v0, 1 #$System call code for print integer
	add $a0, $s1, $zero #$integer to print
	syscall #print
	j exit

exit:
	

.data
	string:	.space 16
	input: .asciiz "Enter a string: "
	output: .asciiz "the number is: "
