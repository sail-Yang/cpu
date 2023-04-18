`include "defines.v"
module id (
	input wire	rst,
	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		inst_i,
	
	// read Regfile
	input wire[`RegBus]		reg1_data_i,
	input wire[`RegBus]		reg2_data_i,
	
	//if it is a jal before this inst,is_in_delay_slot=1
	input wire			is_in_delayslot_i,

	// for avoid RAW
	//ex's result
	input wire			ex_wreg_i,
	input wire[`RegBus]		ex_wdata_i,
	input wire[`RegAddrBus]		ex_wd_i,
	//mem's result
	input wire			mem_wreg_i,
	input wire[`RegBus]		mem_wdata_i,
	input wire[`RegAddrBus]		mem_wd_i,

	//about load
	input wire[`AluOpBus]		ex_aluop_i,

	//output to Regfile
	output reg			reg1_read_o,
	output reg			reg2_read_o,
	output reg[`RegAddrBus]		reg1_addr_o,
	output reg[`RegAddrBus]		reg2_addr_o,

	//the information send to ex
	output reg[`AluOpBus]		aluop_o,
	output reg[`AluSelBus]		alusel_o,
	output reg[`RegBus]		reg1_o,
	output reg[`RegBus]		reg2_o,
	output reg[`RegAddrBus]		wd_o,
	output reg			wreg_o,

	//delayslot
	output reg			next_inst_in_delayslot_o,
	output reg			branch_flag_o,
	output reg[`RegBus]		branch_target_address_o,
	output reg[`RegBus]		link_addr_o,
	output reg			is_in_delayslot_o,

	//Memory R/W
	output wire[`RegBus] 		inst_o,
	output wire			stallreq

);

//get op
wire[5:0] op1 = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];

//store the imm
reg[`RegBus]  imm;

//enable order
reg instValid;

//about branch
wire[`RegBus]	pc_plus_8;
wire[`RegBus]	pc_plus_4;
wire[`RegBus]	imm_sll2_signedext;


//offset left 2 bits then extend to 32bit
assign pc_plus_8 = pc_i + 8;
assign pc_plus_4 = pc_i + 4'h4;
assign imm_sll2_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};

// memory W/R
assign inst_o = inst_i;


//stallreq
reg stallreq_reg1_load_about;
reg stallreq_reg2_load_about;
wire pre_inst_load_about;

assign pre_inst_load_about = (
	(ex_aluop_i == `EXE_LW_OP) 
) ? 1'b1 : 1'b0;


/***************************************************************
******************** uncoding ****************************
****************************************************************/
always @ (*) begin
	if(rst == `RstEnable) begin
		aluop_o 	<= `EXE_NOP_OP;
		alusel_o	<= `EXE_RES_NOP;
		wd_o		<= `NOPRegAddr;
		wreg_o		<= `WriteDisable;
		instValid	<= `InstValid;
		reg1_read_o	<=  1'b0;
		reg2_read_o	<=  1'b0;
		reg1_addr_o	<= `NOPRegAddr;
		reg2_addr_o	<= `NOPRegAddr;
		imm		<=  32'h0;

		link_addr_o 	<= `ZeroWord;
		branch_target_address_o <= `ZeroWord;
		branch_flag_o	<= `NotBranch;
		next_inst_in_delayslot_o <= `NotInDelaySlot;
	end else begin
		aluop_o 	<= `EXE_NOP_OP;
		alusel_o	<= `EXE_RES_NOP;
		wd_o		<=  inst_i[15:11];
		wreg_o		<= `WriteDisable;
		instValid	<= `InstInvalid;
		reg1_read_o	<=  1'b0;
		reg2_read_o	<=  1'b0;
		reg1_addr_o	<=  inst_i[25:21];
		reg2_addr_o	<=  inst_i[20:16];
		imm		<=  `ZeroWord;
		
		link_addr_o 	<= `ZeroWord;
		branch_target_address_o <= `ZeroWord;
		branch_flag_o	<= `NotBranch;
		next_inst_in_delayslot_o <= `NotInDelaySlot;

		
		case (op1)
			`R_TYPE: begin
				case (op2)
					5'b00000: begin
						case(op3)
							`EXE_SLT: 	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SLT_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_SLTU: 	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SLTU_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_AND: 	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_AND_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_OR:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_OR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_XOR:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_XOR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_NOR:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_NOR_OP;
								alusel_o <= `EXE_RES_LOGIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_ADD:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_ADD_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_ADDU:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_ADDU_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_SUB:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SUB_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_SUBU:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SUBU_OP;
								alusel_o <= `EXE_RES_BASIC;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_JR:	begin
								wreg_o <= `WriteDisable;
								aluop_o <= `EXE_JR_OP;
								alusel_o <= `EXE_RES_JUMP;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b0;
								link_addr_o <= `ZeroWord;
								branch_target_address_o <= reg1_o;
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								instValid <= `InstValid;
							end
							`EXE_SLLV:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SLL_OP;
								alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_SRLV:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SRL_OP;
								alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end
							`EXE_SRAV:	begin
								wreg_o <= `WriteEnable;
								aluop_o <= `EXE_SRA_OP;
								alusel_o <= `EXE_RES_SHIFT;
								reg1_read_o <= 1'b1;
								reg2_read_o <= 1'b1;
								instValid <= `InstValid;
							end			
							default:begin
							end
						endcase
					end
					default: begin
					end
				endcase
			end
			`EXE_ORI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_OR_OP;
				alusel_o <= `EXE_RES_LOGIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0,inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_ANDI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_AND_OP;
				alusel_o <= `EXE_RES_LOGIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0,inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_SLTI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_SLT_OP;
				alusel_o <= `EXE_RES_BASIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {{16{inst_i[15]}},inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_SLTIU:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_SLTU_OP;
				alusel_o <= `EXE_RES_BASIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {{16{inst_i[15]}},inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_ADDI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_ADD_OP;
				alusel_o <= `EXE_RES_BASIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {{16{inst_i[15]}},inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_ADDIU:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_ADDU_OP;
				alusel_o <= `EXE_RES_BASIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {{16{inst_i[15]}},inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_XORI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_XOR_OP;
				alusel_o <= `EXE_RES_LOGIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {16'h0,inst_i[15:0]};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_LUI:	begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_OR_OP;
				alusel_o <= `EXE_RES_LOGIC;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				imm <= {inst_i[15:0],16'h0};
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_J:	begin
				wreg_o <= `WriteDisable;
				aluop_o <= `EXE_J_OP;
				alusel_o <= `EXE_RES_JUMP;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b0;
				instValid <= `InstValid;
				link_addr_o <= `ZeroWord;
				branch_flag_o <= `Branch;
				next_inst_in_delayslot_o <= `InDelaySlot;
				branch_target_address_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
			end
			`EXE_JAL:	begin
				wreg_o <= `WriteEnable;
				aluop_o <= `EXE_JAL_OP;
				alusel_o <= `EXE_RES_JUMP;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b0;
				instValid <= `InstValid;
				wd_o <= 5'b11111;
				link_addr_o <= pc_plus_8;
				branch_flag_o <= `Branch;
				next_inst_in_delayslot_o <= `InDelaySlot;
				branch_target_address_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
			end
			`EXE_BEQ:	begin
				wreg_o <= `WriteDisable;
				aluop_o <= `EXE_BEQ_OP;
				alusel_o <= `EXE_RES_JUMP;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b1;
				instValid <= `InstValid;
				if(reg1_o == reg2_o) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
				end
			end
			`EXE_BNE:	begin
				wreg_o <= `WriteDisable;
				aluop_o <= `EXE_BNE_OP;
				alusel_o <= `EXE_RES_JUMP;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b1;
				instValid <= `InstValid;
				if(reg1_o != reg2_o) begin
					branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
				end
			end
			`EXE_LW:	begin
				wreg_o <= `WriteEnable;
				aluop_o <= `EXE_LW_OP;
				alusel_o <= `EXE_RES_MEMORY;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b0;
				wd_o <= inst_i[20:16];
				instValid <= `InstValid;
			end
			`EXE_SW:	begin
				wreg_o <= `WriteDisable;
				aluop_o <= `EXE_SW_OP;
				alusel_o <= `EXE_RES_MEMORY;
				reg1_read_o <= 1'b1;
				reg2_read_o <= 1'b1;
				instValid <= `InstValid;
			end
			default:begin
			end
		endcase

		if(inst_i[31:21] == 11'b00000000000) begin
			if(op3 == `EXE_SLL) begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_SLL_OP;
				alusel_o <= `EXE_RES_SHIFT;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				instValid <= `InstValid;
			end else if(op3 == `EXE_SRL) begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_SRL_OP;
				alusel_o <= `EXE_RES_SHIFT;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				instValid <= `InstValid;
			end else if(op3 == `EXE_SRA) begin
				wreg_o	<= `WriteEnable;
				aluop_o <= `EXE_SRA_OP;
				alusel_o <= `EXE_RES_SHIFT;
				reg1_read_o <= 1'b0;
				reg2_read_o <= 1'b1;
				imm[4:0] <= inst_i[10:6];
				wd_o <= inst_i[15:11];
				instValid <= `InstValid;
			end
		end
	end
end

/***************************************************************
******************** get rst1 ****************************
****************************************************************/
always  @  (*) begin
	stallreq_reg1_load_about <= `NoStop;
	if(rst == `RstEnable) begin
		reg1_o <= `ZeroWord;
	end else if(pre_inst_load_about == 1'b1 && ex_wd_i == reg1_addr_o && reg1_read_o == 1'b1) begin
		stallreq_reg1_load_about <= `Stop;
	//avoid RAW:1. if reg's port == ex's write reg 
	end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && 
		(ex_wd_i == reg1_addr_o) ) begin
		reg1_o <= ex_wdata_i;
	//avoid RAW:2. if reg's port == mem's write reg 
	end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && 
		(mem_wd_i == reg1_addr_o) ) begin
		reg1_o <= mem_wdata_i;
	end else if(reg1_read_o == 1'b1 ) begin
		reg1_o <= reg1_data_i;
	end else if(reg1_read_o == 1'b0) begin
		reg1_o <= imm;
	end else begin
		reg1_o <= `ZeroWord;
	end
end

/***************************************************************
******************** get rst2 ****************************
****************************************************************/
always @ (*) begin
	stallreq_reg2_load_about <= `NoStop;
	if(rst == `RstEnable) begin
		reg2_o <= `ZeroWord;
	end else if(pre_inst_load_about == 1'b1 && ex_wd_i == reg2_addr_o && reg2_read_o == 1'b1) begin
		stallreq_reg2_load_about <= `Stop;
	//avoid RAW:1. if reg's port == ex's write reg 
	end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && 
		(ex_wd_i == reg2_addr_o) ) begin
		reg2_o <= ex_wdata_i;
	//avoid RAW:2. if reg's port == mem's write reg 
	end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && 
		(mem_wd_i == reg2_addr_o) ) begin
		reg2_o <= mem_wdata_i;
	end else if(reg2_read_o == 1'b1) begin
		reg2_o <= reg2_data_i;
	end else if(reg2_read_o == 1'b0) begin
		reg2_o <= imm;
	end else begin
		reg2_o <= `ZeroWord;
	end
end

/***************************************************************
******************** delay slot ****************************
****************************************************************/
always @ (*) begin
	if(rst == `RstEnable) begin
		is_in_delayslot_o <= `NotInDelaySlot;
	end else begin
		is_in_delayslot_o <= is_in_delayslot_i;
	end
end


assign stallreq = stallreq_reg1_load_about | stallreq_reg2_load_about;
endmodule
