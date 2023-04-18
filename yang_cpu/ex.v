`include "defines.v"

module ex(
	input wire 		rst,
	input wire[`AluOpBus] 	aluop_i,
	input wire[`AluSelBus] 	alusel_i,
	input wire[`RegBus]	reg1_i,
	input wire[`RegBus]	reg2_i,
	input wire[`RegAddrBus] wd_i,
	input wire		wreg_i,

	input wire[`RegBus]	link_address_i,
	input wire		is_in_delayslot_i,
	
	input wire[`RegBus]	inst_i,	

	output reg[`RegAddrBus]	wd_o,
	output reg		wreg_o,
	output reg[`RegBus]	wdata_o,
	
	output wire[`AluOpBus]	aluop_o,
	output wire[`RegBus]	mem_addr_o,
	output wire[`RegBus]	reg2_o,

	output wire		stallreq
);

//save the result of logic conut
reg[`RegBus]	logicout;
reg[`RegBus]	shiftres;
reg[`RegBus]	basicres;


wire		ov_sum;
wire		reg1_eq_reg2;
wire		reg1_lt_reg2;
wire[`RegBus]	reg2_i_mux;
wire[`RegBus]	reg1_i_not;
wire[`RegBus]	result_sum;

assign reg2_i_mux = (	(aluop_i == `EXE_SUB_OP) ||
			(aluop_i == `EXE_SUBU_OP) ||
			(aluop_i == `EXE_SLT_OP) 
		    ) ? (~reg2_i)+1 : reg2_i;
		

assign result_sum = reg1_i + reg2_i_mux;

assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) || 
	((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));

assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
			((reg1_i[31] && !reg2_i[31]) || 
			(!reg1_i[31] && !reg2_i[31] && result_sum[31]) || 
			(reg1_i[31] && reg2_i[31] && result_sum[31]))
			: (reg1_i < reg2_i);

assign reg1_i_not = ~reg1_i;

//aluop_o will be send to mem to define load or store
assign aluop_o = aluop_i;

// mem_addr_o will be send to mem to express the address of memory
assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};

// reg2_o os the data to store in sw or the data to load in destination in lw
assign reg2_o = reg2_i;

//according to aluop_i,do logic calculator
always @ (*) begin
	if(rst == `RstEnable) begin
		logicout <= `ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_OR_OP:begin
				logicout <= reg1_i | reg2_i;
			end
			`EXE_AND_OP:begin
				logicout <= reg1_i & reg2_i;
			end
			`EXE_XOR_OP:begin
				logicout <= reg1_i ^ reg2_i;
			end
			`EXE_NOR_OP:begin
				logicout <= ~(reg1_i | reg2_i);
			end
			default: begin
				logicout <= `ZeroWord;
			end
		endcase
	end
end

//according to aluop_i,do shift calculator
always @ (*) begin
	if(rst == `RstEnable) begin
		shiftres <= `ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_SLL_OP: begin
				shiftres <= reg2_i << reg1_i[4:0];
			end
			`EXE_SRL_OP: begin
				shiftres <= reg2_i >> reg1_i[4:0];
			end
			`EXE_SRA_OP:begin
				shiftres <= ({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]}))
				| reg2_i >> reg1_i[4:0];
			end
			default: begin
				shiftres <= `ZeroWord;
			end
		endcase
	end
end

//according to aluop_i,do basic calculator
always @ (*) begin
	if(rst == `RstEnable) begin
		basicres <= `ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_SLT_OP,`EXE_SLTU_OP: begin
				basicres <= reg1_lt_reg2;
			end
			`EXE_ADDU_OP, `EXE_ADD_OP: begin
				basicres <= result_sum;
			end
			`EXE_SUBU_OP,`EXE_SUB_OP: begin
				basicres <= result_sum;
			end
			default: begin
				basicres <= `ZeroWord;
			end
		endcase
	end
end

//according to alusel_i ,choose one result as the end result
always @ (*) begin
	//????????????????????????????
	if(is_in_delayslot_i == `NotInDelaySlot)begin
		wd_o <= wd_i;		//the address of the reg to write
		wreg_o <= wreg_i;
		case (alusel_i)
			`EXE_RES_LOGIC: begin
				wdata_o <= logicout;
			end
			`EXE_RES_SHIFT: begin
				wdata_o <= shiftres;
			end
			`EXE_RES_BASIC: begin
				wdata_o <= basicres;
			end
			`EXE_RES_JUMP:begin
				wdata_o <= link_address_i;
			end
			default: begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end else begin
		wdata_o <= `ZeroWord;
	end
	
end

endmodule
