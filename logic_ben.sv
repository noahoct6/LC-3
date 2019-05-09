module logic_ben(input logic [15:0] IR,
                 input logic N,Z,P,
					  output logic ben);

        always_comb
		  begin
				ben = (IR[11]&N) +(IR[10]&Z)+(IR[9]&P);
		  end 

endmodule
