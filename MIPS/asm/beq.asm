_start:
	ori $1,$0,0x0001
	beq $1,$1,test
	ori $2,$0,0x0007
	ori $3,$0,0x0003
test:
	ori $4,$0,0x0006
	