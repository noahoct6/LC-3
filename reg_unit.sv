module reg_unit(inout wire [15:0] Din,
					 input logic [2:0] DRMUX, SR1MUX, SR2,
					 input logic LD_REG, Clk,
                output logic [15:0] SR1_OUT,
					 output logic [15:0] SR2_OUT,
					 //for debugging
					 output logic [15:0] R0,R1,R2,R3,R4,R5,R6,R7);
					 
	logic [7:0] loadi;
	logic [7:0] loadf;
	logic [15:0] o [7:0];
	
	always_comb
	begin
	   unique case(DRMUX)
		3'H0	:	loadi = 8'H01;
		3'H1	:	loadi = 8'H02;
		3'H2  :  loadi = 8'H04;
		3'H3  :  loadi = 8'H08;
		3'H4	:	loadi = 8'H10;
		3'H5	:	loadi = 8'H20;
		3'H6  :  loadi = 8'H40;
		3'H7  :  loadi = 8'H80;
		endcase
	end
	
	assign loadf = loadi & {8{LD_REG}};
	
	always_comb
	begin
	   unique case(SR1MUX)
		3'H0	:	SR1_OUT = o[0];
		3'H1	:	SR1_OUT = o[1];
		3'H2  :  SR1_OUT = o[2];
		3'H3  :  SR1_OUT = o[3];
		3'H4	:	SR1_OUT = o[4];
		3'H5	:	SR1_OUT = o[5];
		3'H6  :  SR1_OUT = o[6];
		3'H7  :  SR1_OUT = o[7];
		endcase
	end
	
	always_comb
	begin
		unique case(SR2)
		3'H0	:	SR2_OUT = o[0];
		3'H1	:	SR2_OUT = o[1];
		3'H2  :  SR2_OUT = o[2];
		3'H3  :  SR2_OUT = o[3];
		3'H4	:	SR2_OUT = o[4];
		3'H5	:	SR2_OUT = o[5];
		3'H6  :  SR2_OUT = o[6];
		3'H7  :  SR2_OUT = o[7];
		endcase	
	end
	
   reg_16    register0 (.Clk(Clk),.LD(loadf[0]),.Din(Din),.Dout(o[0]));
   reg_16    register1 (.Clk(Clk),.LD(loadf[1]),.Din(Din),.Dout(o[1]));
   reg_16    register2 (.Clk(Clk),.LD(loadf[2]),.Din(Din),.Dout(o[2]));
	reg_16    register3 (.Clk(Clk),.LD(loadf[3]),.Din(Din),.Dout(o[3]));
   reg_16    register4 (.Clk(Clk),.LD(loadf[4]),.Din(Din),.Dout(o[4]));
	reg_16    register5 (.Clk(Clk),.LD(loadf[5]),.Din(Din),.Dout(o[5]));
	reg_16    register6 (.Clk(Clk),.LD(loadf[6]),.Din(Din),.Dout(o[6]));
	reg_16    register7 (.Clk(Clk),.LD(loadf[7]),.Din(Din),.Dout(o[7]));
	
	//for debugging
	assign R0 = o[0];
	assign R1 = o[1];
	assign R2 = o[2];
	assign R3 = o[3];
	assign R4 = o[4];
	assign R5 = o[5];
	assign R6 = o[6];
	assign R7 = o[7];

endmodule
