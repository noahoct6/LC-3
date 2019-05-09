// ALU does AND and ADD operation.

module ALU(input logic [15:0] A,B,
           input logic [1:0] ALUK,
			  output logic [15:0] Dout);
			  
	logic [15:0] Sum;
	
	csa 		ADDER(.A(A),.B(B),.Sum(Sum));
	
   always_comb
	begin
		case(ALUK)
		2'b00	:	Dout = Sum;//add, use 16-bit adder here
		2'b01	:	Dout = A & B;  //AND
		2'b10	:	Dout = A^16'HFFFF;    //B will be all 1's from SR2MUX 
		2'b11	:	Dout = A;		//A simply passes through
		endcase
	end 


endmodule 