`include "defines.v"
module if_id (
	input wire	clk,
	input wire	rst,
	input wire[5:0]	stall,
	//from the state of getting order
	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,

	//from count code
	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst
);

	always @ (posedge clk) begin
		if(rst==`RstEnable) begin
			id_pc <= `InitAddr;	//When Reset, PC=0
			id_inst <= `ZeroWord;	//When Rest,order = 0
		// getcode stop , decode with NOP
		end else if(stall[1] == `Stop && stall[2] == `NoStop) begin
			id_pc <= `InitAddr;
			id_inst <= `ZeroWord;
		end else if(stall[1] == `NoStop)begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
endmodule
