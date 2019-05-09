module testbench();

	timeunit 10ns;
	timeprecision 1ns;
	
	logic [15:0] S;
	logic Clk = 0; 
	logic Reset, Run, Continue;
	logic [11:0] LED;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic CE, UB, LB, OE, WE,ld_pc_d,beno_d;
	logic [19:0] ADDR;
	wire [15:0] DataSRAM,Data_debug;
	logic [15:0] PCdisp,IRdisp,MARdisp,MDRdisp,
	R0,R1,R2,R3,R4,R5,R6,R7,toCPU_debug,sr1o_d,sr2o_d,sr2muxo_d,pcmuxo_d;
	logic [2:0] DRMUXo_debug;
	logic [1:0] pcmux_d;
	
	lab6_toplevel lab6(.*);
	
	always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
	end
	
	initial begin: CLOCK_INITIALIZATION
		Clk = 0;
	end 
	
	initial begin: TEST_VECTORS
		Reset = 0;
		Run = 1;
		Continue = 1;
		S = 16'H0014;
		
		#2	Reset = 1;
		#2 Run = 0;
		#2 Run = 1;
		#90 S = 16'H0055;
		#20 Continue = 0;
		#2 Continue = 1;
		#90 S=16'H007F;
		#2 Continue=0;
		#2 Continue=1;
	end

endmodule
