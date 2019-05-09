//this module is a parallel load 16-bit shift register 

module reg_16(input logic Clk, Reset, LD, Clr,
				 input logic [15:0] Din,
				 output logic [15:0] Dout);
	
	always_ff @ (posedge Clk)
		begin
			if(Reset)
				Dout <= 16'h0;
			else if(Clr)
				Dout <= 16'h0;
			else if(LD)
				Dout <= Din;
		end
	
endmodule
