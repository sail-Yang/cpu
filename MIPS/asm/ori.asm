.org 0x0
.global _start
.set noat
_start:
	lui $2,0xffff
	lui $3,0x0001
	addu $4,$2,$3
	lui $5,0x0303
	subu $4,$4,$5
	