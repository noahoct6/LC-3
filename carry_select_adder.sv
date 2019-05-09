module csa
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic [3:0] c;
	
	always_comb begin
		c[0] = 0;
	end
	
	fourbit_adder	fbA2(.c_in(c[0]),.A(A[3:0]),.B(B[3:0]),.s(Sum[3:0]),.c_out(c[1]));
	csa_col			COL1(.c_in(c[1]),.A(A[7:4]),.B(B[7:4]),.s(Sum[7:4]),.c_out(c[2]));
	csa_col			COL2(.c_in(c[2]),.A(A[11:8]),.B(B[11:8]),.s(Sum[11:8]),.c_out(c[3]));
	csa_col			COL3(.c_in(c[3]),.A(A[15:12]),.B(B[15:12]),.s(Sum[15:12]),.c_out(CO));	
	
endmodule
