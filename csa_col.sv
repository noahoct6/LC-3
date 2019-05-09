module csa_col(input logic c_in,
					input logic [3:0] A, B,
					output logic [3:0] s,
					output logic c_out);
	
	logic [1:0] ac; //adder carry, 0 index is top carry, 1 is bottom
	logic [7:0] is; //intermediate s
	
	fourbit_adder	fbA0(.A,.B,.c_in(0),.c_out(ac[0]),.s(is[3:0]));
	fourbit_adder	fbA1(.A,.B,.c_in(1),.c_out(ac[1]),.s(is[7:4]));
	always_comb begin
		c_out = ac[0]|(c_in & ac[1]);
		unique case (c_in)
			1'b0	:	s[3:0] = is[3:0];
			1'b1	:	s[3:0] = is[7:4];
		endcase
	end
endmodule
