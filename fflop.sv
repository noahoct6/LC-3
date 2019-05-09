module fflop(input logic Clk, Load, Reset, D, Clr,
				 output logic Q);
	
	always_ff @ (posedge Clk)
		begin
			if(Reset)
				Q <= 1'b0;
			else if (Clr)
				Q <= 1'b0;
			else
				if(Load)
					Q <= D;
				else
					Q <= Q;
		end
		 
endmodule
