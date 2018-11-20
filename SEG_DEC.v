module SEG_DEC(DIGIT,SEG_DEC);

input [6:0] DIGIT;
output [7:0] SEG_DEC;
reg [7:0] SEG_DEC;

	always @(DIGIT)
	case (DIGIT) // gfe_dcba
	0 : SEG_DEC <= 8'h3f; // 0011_1111
	1 : SEG_DEC <= 8'h06; // 0000_0110
	2 : SEG_DEC <= 8'h5b; // 0101_1011
	3 : SEG_DEC <= 8'h4f; // 0100_1111
	4 : SEG_DEC <= 8'h66; // 0110_0110
	5 : SEG_DEC <= 8'h6d; // 0110_1101
	6 : SEG_DEC <= 8'h7d; // 0111_1101
	7 : SEG_DEC <= 8'h07; // 0000_0111
	8 : SEG_DEC <= 8'h7f; // 0111_1111
	9 : SEG_DEC <= 8'h6f; // 0110_1111
	10 : SEG_DEC <= 8'b0111_0111;//A
	11 : SEG_DEC <= 8'b0111_1100;//b
	12 : SEG_DEC <= 8'b0011_1001;//C
	13 : SEG_DEC <= 8'b0101_1110;//d
	14 : SEG_DEC <= 8'b0111_1001;//E
	15 : SEG_DEC <= 8'b0111_0001;//F
	
	20 : SEG_DEC <= 8'hbf; // 1011_1111
	21 : SEG_DEC <= 8'h86; // 1000_0110
	22 : SEG_DEC <= 8'hdb; // 1101_1011
	23 : SEG_DEC <= 8'hcf; // 1100_1111
	24 : SEG_DEC <= 8'he6; // 1110_0110
	25 : SEG_DEC <= 8'hed; // 1110_1101
	26 : SEG_DEC <= 8'hfd; // 1111_1101
	27 : SEG_DEC <= 8'h87; // 1000_0111
	28 : SEG_DEC <= 8'hff; // 1111_1111
	29 : SEG_DEC <= 8'hef; // 1110_1111
	30 : SEG_DEC <= 8'b0111_0111;//A
	31 : SEG_DEC <= 8'b0111_1100;//b
	32 : SEG_DEC <= 8'b0011_1001;//C
	33 : SEG_DEC <= 8'b0101_1110;//d
	34 : SEG_DEC <= 8'b0111_1001;//E
	35 : SEG_DEC <= 8'b0111_0001;//F
	endcase

endmodule
