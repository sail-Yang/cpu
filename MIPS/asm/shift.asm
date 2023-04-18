_start:
	ori $1,$0,0x00000200
	ori $2,$0,4
	sll $3,$1,8
	srl $4,$1,8
	
	sllv $6,$1,$2
	srlv $7,$1,$2
	
	