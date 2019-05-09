module mux_3bit (input logic [2:0] Din0,
					  input logic [2:0] Din1,
					  input logic sel,
					  output logic [2:0] Dout);
				 
	    always_comb
		 begin
		    case (sel)
			 1'b0: Dout=Din0;
			 1'b1: Dout=Din1;
			 endcase
		 end

endmodule 