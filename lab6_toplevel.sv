//-------------------------------------------------------------------------
//      lab6_toplevel.sv                                                 --
//                                                                       --
//      Created 10-19-2017 by Po-Han Huang                               --
//                        Spring 2018 Distribution                       --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
module lab6_toplevel( input logic [15:0] S,
                      input logic Clk, Reset, Run, Continue,
                      output logic [11:0] LED,
                      output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
                      output logic CE, UB, LB, OE, WE,
                      output logic [19:0] ADDR,
                      inout wire [15:0] DataSRAM
							 // pull out to debug
							 ,output logic [15:0] PCdisp, IRdisp, MARdisp, MDRdisp,
							 R0,R1,R2,R3,R4,R5,R6,R7,toCPU_debug,sr1o_d,sr2o_d,sr2muxo_d,pcmuxo_d,
							 inout wire [15:0] Data_debug,
							 output logic [2:0] DRMUXo_debug,
							 output logic [1:0] pcmux_d,
							 output logic ld_pc_d,beno_d
							 );

//slc3 my_slc(.*,.Data(DataSRAM));
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(Reset_SH), .I_O(DataSRAM), .A(ADDR), .*);


// intialization of internal logic

logic [15:0] IRo,ALUo,SR1o,SR2o,ADDR1MUXo,ADDR2MUXo,PCo,PCMUXo,ADDERo,MARo,SR2MUXo; //16 bit intermediate outputs
logic [15:0] toM2IO,toSRAM,toCPU,MDRo,MIOMUXo; //16 bit extended
logic [2:0]	DRMUXo,SR1MUXo; //3 bit intermediate outputs
logic BENo,BENi,Ni,Zi,Pi,No,Zo,Po; //one bit intermediate logic
logic LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED;	//loads
logic GatePC,GateMDR,GateALU,GateMARMUX; 	//gate enables
logic DRMUX,SR1MUX,SR2MUX,ADDR1MUX; 		//one bit mux selects
logic [1:0] PCMUX,ADDR2MUX,ALUK;				//two bit mux selects
logic [3:0]	hex_0,hex_1,hex_2,hex_3,hex_4,hex_5,hex_6,hex_7; //hex nibs

wire [15:0]	Data; // Bus

//debug
assign toCPU_debug = toCPU[15:0];
assign Data_debug = Data[15:0];
assign DRMUXo_debug = DRMUXo[2:0];
assign sr1o_d = SR1o[15:0];
assign sr2o_d = SR2o[15:0];
assign sr2muxo_d = SR2MUXo[15:0];
assign pcmuxo_d = PCMUXo[15:0];
assign pcmux_d = PCMUX[1:0];
assign ld_pc_d = LD_PC;
assign beno_d = BENo;

//instantiate modules
assign LED = {12{LD_LED}}&IRo[11:0];
assign PCdisp = PCo[15:0];
assign IRdisp = IRo[15:0];
assign MDRdisp = MDRo[15:0];
assign MARdisp = MARo[15:0];
assign ADDR = {4'b0,MARo};

muxbuffer	  buffer(.sel({GatePC,GateMDR,GateALU,GateMARMUX}),
							.Din0(ADDERo),
							.Din1(ALUo),
							.Din2(MDRo),
							.Din3(PCo),
							.Dout(Data));

logic_nzp	nzp_inst(.Din(Data),					//from BUS
							.N(Ni),
							.Z(Zi),
							.P(Pi));
							
fflop					 N(.Clk(Clk),
							.Load(LD_CC),
							.D(Ni),
							.Q(No));
		
fflop					 Z(.Clk(Clk),
							.Load(LD_CC),
							.D(Zi),
							.Q(Zo));
							
fflop					 P(.Clk(Clk),
							.Load(LD_CC),
							.D(Pi),
							.Q(Po));

logic_ben	ben_inst(.IR(IRo),
							.N(No),
							.Z(Zo),
							.P(Po),
							.ben(BENi));
	
fflop				  BEN(.Clk(Clk),
							.Load(LD_BEN),
							.D(BENi),
							.Q(BENo));
							

ISDU		  ISDU_inst(.Clk(Clk), 
							.Reset(Reset_SH), 		//syncrhonized high reset button
							.Run(Run_SH),				//syncrhonized high run button
							.Continue(Continue_SH),	//syncrhonized high continue button
							.Opcode(IRo[15:12]), 	//opcode from IR
							.IR_5(IRo[5]),				//index of IR
							.IR_11(IRo[11]),			//index of IR
							.BEN(BENo),					//from branch enable, flip-flop?
								
							//load outputs
							.LD_MAR(LD_MAR),
							.LD_MDR(LD_MDR),
							.LD_IR(LD_IR),
							.LD_BEN(LD_BEN),
							.LD_CC(LD_CC),
							.LD_REG(LD_REG),
							.LD_PC(LD_PC),
							.LD_LED(LD_LED), // for PAUSE instruction
								
							//gate enable outputs
							.GatePC(GatePC),
							.GateMDR(GateMDR),
							.GateALU(GateALU),
							.GateMARMUX(GateMARMUX),
								
							//Mux select outputs
							.PCMUX(PCMUX),
							.DRMUX(DRMUX),
							.SR1MUX(SR1MUX),
							.SR2MUX(SR2MUX),
							.ADDR1MUX(ADDR1MUX),
							.ADDR2MUX(ADDR2MUX),
							.ALUK(ALUK),
				  
							//outputs to SRAM
							.Mem_CE(CE),
							.Mem_UB(UB),
							.Mem_LB(LB),
							.Mem_OE(OE),
							.Mem_WE(WE));

reg_unit		 regfile(.Clk(Clk),
							.Din(Data), 		//from bus
							.DRMUX(DRMUXo), 	//output of DRMUX
							.SR1MUX(SR1MUXo), //output of SR1MUX
							.SR2(IRo[2:0]), 	//check this, i think comes from IR
							.LD_REG(LD_REG), 	//from ISDU
							.SR1_OUT(SR1o), 	//to ALU_A
						   .SR2_OUT(SR2o),
							.R0(R0),
							.R1(R1),
							.R2(R2),
							.R3(R3),
							.R4(R4),
							.R5(R5),
							.R6(R6),
							.R7(R7)); 	//for debugging

mux_3bit		  DR_MUX(.sel(DRMUX),		//ISDU
							.Din0(IRo[11:9]),		//check order of inputs
							.Din1(3'b111), //check order of inputs
							.Dout(DRMUXo)); 	//output of DRMUX

mux_3bit		 SR1_MUX(.sel(SR1MUX),		//from ISDU
							.Din0(IRo[8:6]), //check order of inputs
							.Din1(IRo[11:9]),	//check order of inputs
							.Dout(SR1MUXo)); 	//outof SR1MUX

mux_16bit	 SR2_MUX(.sel({1'b0,SR2MUX}),							//from ISDU
							.Din0(SR2o),		//sign extension from IR
							.Din1({{11{IRo[4]}},IRo[4:0]}),							//check order of inputs
							.Dout(SR2MUXo));						//check order of inputs

ALU		  ALUS_inst(.A(SR1o),		//from reg file
							.B(SR2MUXo),	//from SR2MUX
							.ALUK(ALUK),	//from ISDU
							.Dout(ALUo));  //to ALUgate


reg_16		  IR_reg(.Clk(Clk),
							.LD(LD_IR),				//from ISDU
							.Din(Data),				//from bus
							.Dout(IRo));			//output of IR
							
mux_16bit  ADDR2_MUX(.sel(ADDR2MUX),							//from ISDU
							.Din0({{5{IRo[10]}},IRo[10:0]}),		//sign extension from IR
							.Din1({{7{IRo[8]}},IRo[8:0]}),		//sign extension
							.Din2({{10{IRo[5]}},IRo[5:0]}),
							.Din3(16'b0),
							.Dout(ADDR2MUXo));					
	
mux_16bit  ADDR1_MUX(.sel({1'b0,ADDR1MUX}),					//from ISDU
							.Din0(SR1o),								//SR1 out
							.Din1(PCo),									//output from PC
							.Dout(ADDR1MUXo));						
							
csa 				ADDER(.A(ADDR2MUXo),
							.B(ADDR1MUXo),
							.Sum(ADDERo));

mux_16bit	  PC_MUX(.sel(PCMUX),								//from ISDU
							.Din0(PCo+1),								//input from bus						
							.Din1(ADDERo),								//from adder
							.Din2(Data),								//PC incremented
							.Dout(PCMUXo));							//output of PCMUX
							
reg_16				PC(.Clk(Clk),	
							.LD(LD_PC),				//from ISDU
							.Reset(Reset_SH),		//synchronized active reset button
							.Din(PCMUXo),			//from PCMUX
							.Dout(PCo));			//output of PC
							
							
							
//South of BUS
reg_16			  MAR(.Clk(Clk),
							.LD(LD_MAR),
							.Din(Data),
							.Dout(MARo));
							
reg_16			  MDR(.Clk(Clk),
							.LD(LD_MDR),			//from ISDU
							.Din(MIOMUXo),			//from MIOMUX
							.Dout(MDRo));			//to MDR
							
mux_16bit	  MIOMUX(.sel({1'b0,~OE}),			// may need to change if MIO_EN is not ~OE 
							.Din0(Data),			//input from bus						
							.Din1(toCPU),			// from MEM2IO
							.Dout(MIOMUXo));		//output of MIOMUX
							
Mem2IO	Mem2IO_inst(.Clk(Clk),
							.Reset(Reset_SH),
							.ADDR({4'b0,MARo}),
							.CE(CE),
							.UB(UB),
							.LB(LB),
							.OE(OE),
							.WE(WE),
							.Switches(S),
							.Data_from_CPU(MDRo),
							.Data_from_SRAM(toM2IO),
							.Data_to_CPU(toCPU),
							.Data_to_SRAM(toSRAM),
							.HEX0(hex_0),
							.HEX1(hex_1),
							.HEX2(hex_2),
							.HEX3(hex_3));
							
tristate			  TSB(.Clk(Clk), 
							.tristate_output_enable(~WE),	// WE, active low  ?
							.Data_write(toSRAM), 			// Data from Mem2IO
							.Data_read(toM2IO), 				// Data to Mem2IO
							.Data(DataSRAM));					// between SRAM and tristate
							
// Hex Drivers
HexDriver   Hex0( .In0(hex_0),			//change all hex for week 2
                  .Out0(HEX0) );
							
HexDriver   Hex1( .In0(hex_1),
						.Out0(HEX1) );
							
HexDriver   Hex2( .In0(hex_2),
						.Out0(HEX2) );
						
HexDriver   Hex3( .In0(hex_3),
						.Out0(HEX3) );						

HexDriver   Hex4( .In0(PCo[3:0]),		//change for week 2
						.Out0(HEX4) );
			
HexDriver   Hex5( .In0(PCo[7:4]),		//chage for week 2
						.Out0(HEX5) );
							
HexDriver   Hex6( .In0(PCo[11:8]),		//chage for week 2
						.Out0(HEX6) );			
						
HexDriver   Hex7( .In0(PCo[15:12]),		//change for week 2
						.Out0(HEX7) );		
				
// Synchronizers
sync		buttons[2:0](Clk,{~Reset, ~Run, ~Continue},{Reset_SH, Run_SH, Continue_SH});
//sync	   switches(Clk, S, S_s);	

endmodule
