`include "defines.v"

module im(
	input wire			ce,
	input wire[`InstAddrBus]	addr,
	output reg[`InstBus]		inst
);
	reg[`InstBus]	inst_mem[0:`InstMemNum-1];

	// user file to initialize ROM
	reg[30*8:1] dataPath = "bin/test.data";	
	initial $readmemh (dataPath,inst_mem);

	always @ (*) begin
		if(ce == `ChipDisable) begin
			inst <= `ZeroWord;
		end else begin
			inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
	    	end
	end
endmodule
