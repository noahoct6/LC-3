module logic_nzp(input logic [15:0] Din,
                 output logic N,Z,P);
					  
	logic d1;
					  
	always_comb
	begin
		N = Din[15];
		d1 = Din[14]|Din[13]|Din[12]|Din[11]|Din[10]|Din[9]|Din[8]|Din[7]|Din[6]|Din[5]|Din[4]|Din[3]|Din[2]|Din[1]|Din[0];
		Z = ~(Din[15] | d1);
		P = (~Din[15])&d1;
   end
					  
endmodule
