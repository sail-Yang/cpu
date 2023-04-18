`include "defines.v"

module im(
	input wire			ce,
	input wire[`InstAddrBus]	addr,
	output reg[`InstBus]		inst
);
	
	parameter INIT_LONG = `InitAddr >> 2;
	reg[`InstBus]	inst_mem[INIT_LONG:INIT_LONG+`InstMemNum-1];

	// user file to initialize ROM
	reg[30*8:1] dataPath = "bin/code.data";	
	initial $readmemh (dataPath,inst_mem,INIT_LONG);

	always @ (*) begin
		if(ce == `ChipDisable) begin
			inst <= `ZeroWord;
		end else begin
			inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
			$display("inst : 0x%h",inst_mem[addr[`InstMemNumLog2+1:2]]);
	    	end
	end
endmodule
