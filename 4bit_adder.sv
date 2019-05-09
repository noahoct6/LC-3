module fourbit_adder(input logic c_in,
							input logic [3:0] A,
							input logic [3:0] B,
							output logic c_out,
							output logic [3:0] s);
							
	logic [3:0] c;
	
	always_comb begin
		c[0] = c_in;
	end
	
	full_adder	FA0(.x(A[0]),.y(B[0]),.z(c[0]),.s(s[0]),.c(c[1]));
	full_adder	FA1(.x(A[1]),.y(B[1]),.z(c[1]),.s(s[1]),.c(c[2]));
	full_adder	FA2(.x(A[2]),.y(B[2]),.z(c[2]),.s(s[2]),.c(c[3]));
	full_adder	FA3(.x(A[3]),.y(B[3]),.z(c[3]),.s(s[3]),.c(c_out));
							
endmodule
