_start:
	ori $1,$0,0x0001
	j test
	ori $2,$0,0x0007
	ori $3,$0,0x0003
test:
	ori $4,$0,0x0006
	jal test1
	addu $5,$4,$3
	subu $6,$4,$3
test1:
	ori $1,$0,0x0002
