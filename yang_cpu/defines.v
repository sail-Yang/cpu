
//******************gloabl define****************** 
`define RstEnable	1'b1		//Reset Enable
`define RstDisable 	1'b0		//Reset Disable

`define ZeroWord	32'h00000000	//32 bit 0

`define WriteEnable	1'b1		//Write Enable
`define WriteDisable 	1'b0		//Write Disable
`define ReadEnable	1'b1		//Read Enable
`define ReadDisable 	1'b0		//Read Disable

`define AluOpBus	7:0		// when decode,the width of aluop
`define AluSelBus	2:0		// when decode,the width of alusel

`define InstValid	1'b0		//order enable
`define InstInvalid	1'b1		//order disable

`define True_v		1'b1
`define False_v		1'b0

`define ChipEnable	1'b1		//chip enable
`define ChipDisable	1'b0

//****************** order define****************** 
`define EXE_NOP		6'b000000	//op of NOP

`define EXE_AND		6'b100100	//op of AND
`define EXE_OR		6'b100101	//op of OR
`define EXE_XOR		6'b100110	//op of XOR
`define EXE_NOR		6'b100111	//op of NOR
`define EXE_ADD		6'b100000
`define	EXE_ADDU	6'b100001
`define EXE_SUB		6'b100010
`define EXE_SUBU	6'b100011
`define EXE_SLT		6'b101010
`define EXE_SLTU	6'b101011

`define EXE_ORI		6'b001101	//op of ORI
`define EXE_XORI	6'b001110
`define EXE_ADDI	6'b001000
`define EXE_ADDIU	6'b001001
`define EXE_ANDI	6'b001100
`define EXE_LUI		6'b001111
`define EXE_SLTI	6'b001010
`define EXE_SLTIU	6'b001011

`define EXE_SLL		6'b000000	
`define EXE_SLLV	6'b000100
`define EXE_SRLV	6'b000110
`define EXE_SRAV	6'b000111
`define EXE_SRL		6'b000010
`define EXE_SRA		6'b000011

`define EXE_SYNC	6'b001111
`define EXE_PREF	6'b110011
`define	R_TYPE		6'b000000

`define EXE_J		6'b000010
`define EXE_JAL		6'b000011
`define EXE_JR		6'b001000
`define EXE_BEQ		6'b000100
`define EXE_BNE		6'b000101

`define EXE_LW		6'b100011
`define EXE_SW		6'b101011

//AluOp
`define EXE_NOP_OP	8'b00000000
`define EXE_SLT_OP	8'b00101010
`define EXE_SLTU_OP	8'b00101011
`define EXE_AND_OP	8'b00100100
`define EXE_OR_OP	8'b00100101
`define EXE_XOR_OP	8'b00100110
`define EXE_NOR_OP	8'b00100111
`define EXE_ADD_OP	8'b00100000
`define EXE_ADDU_OP	8'b00100001
`define EXE_SUB_OP	8'b00100010
`define EXE_SUBU_OP	8'b00100011

`define EXE_SLL_OP	8'b00000000
`define EXE_SRL_OP	8'b00000010
`define EXE_SRA_OP	8'b00000011
`define EXE_SLLV_OP	8'b00000100
`define EXE_SRLV_OP	8'b00000110
`define EXE_SRAV_OP	8'b00000111

`define EXE_JAL_OP	8'b00000011
`define EXE_J_OP	8'b00000010
`define EXE_BEQ_OP	8'b00000100
`define EXE_BNE_OP	8'b00000101
`define EXE_JR_OP	8'b00001000

`define EXE_LW_OP	8'b00100011
`define EXE_SW_OP	8'b00101011

//AluSel
`define EXE_RES_LOGIC	3'b001
`define EXE_RES_SHIFT	3'b010
`define EXE_RES_BASIC	3'b011
`define EXE_RES_JUMP	3'b100
`define EXE_RES_MEMORY	3'b101
`define EXE_RES_NOP	3'b000

//branch
`define Branch		1'b1
`define NotBranch	1'b0
`define InDelaySlot	1'b1	//in delay slot
`define NotInDelaySlot	1'b0	//not in delay slot
//****************** Order Memory ROM ****************** 
`define InstAddrBus	31:0		//the width of ROM's address BUS
`define InstBus		31:0		//The wodth of ROM's data BUS
`define InstMemNum	4096		//size 4KB
`define InstMemNumLog2	17		//using width of address B
`define InitAddr	32'h00003000

//****************** Order Memory RAM ****************** 
`define DataAddrBus	31:0		//the width of RAM's address BUS
`define DataBus		31:0		//The wodth of RAM's data BUS
`define DataMemNum	4096		//size 4KB
`define DataMemNumLog2	17		//using width of address
`define ByteWidth	7:0		// width of a Byte


//****************** Common Reg ****************** 
`define RegAddrBus	4:0		//the width of Reg's address wire
`define RegBus		31:0
`define RegWidth	32
`define DoubleRegBus	63:0
`define DoubleRegWidth	64

`define RegNum		32
`define RegNumLog2	5		//the bits to find address
`define NOPRegAddr	5'b00000

//****************** Control ****************** 
`define Stop	1'b1
`define	NoStop	1'b0
