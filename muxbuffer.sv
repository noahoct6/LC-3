module muxbuffer(input logic [3:0] sel,
					  input logic [15:0] Din0,Din1,Din2,Din3,
					  output logic [15:0] Dout);
					  
		always_comb
		begin
			case(sel)
			4'b0001	:	Dout = Din0;
			4'b0010	:  Dout = Din1;
			4'b0100	:  Dout = Din2;
			4'b1000	:  Dout = Din3;
			default	: 	Dout = 16'b0;
			endcase
		end
						
endmodule
