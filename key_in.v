module key_in(clk, stb, enb, check_clk, n_state, key_col, key_row, SEG_C,SEG_SEL,dot_10,dot_14);

	input clk,stb,enb;
	input n_state;
	input [3:0] key_row;
	output [2:0] key_col;
	
	output reg [13:0] dot_14;
	output reg [9:0] dot_10; 
	
	reg [3:0] key_data,n_state;
	reg [2:0] state;
	reg [13:0] counts;
	reg [3:0] nn1,nn2,nn3,nn4;
	reg [3:0] n1,n2,n3,n4;
	reg clk1;
	reg [2:0] s1,b1,s2,b2,s3,b3,s4,b4,S,B;
	
	output [7:0] SEG_C;
	output [7:0] SEG_SEL;
	output [8:0] check_clk;
	
	wire [7:0] SEG_C;
	reg [7:0] SEL_SEG;
	reg [7:0] SEG_SEL;
	reg [7:0] seg_TMP;
	reg [7:0] check_clk;
	reg [3:0] check;
	reg [31:0] countc;
	reg [1:0] submit;
	wire [7:0] COUNT_1, COUNT_10, COUNT_M, COUNT_M_dot;
	
	
	// define state of FSM
	parameter no_scan = 3'b000;
	parameter column1 = 3'b001;
	parameter column2 = 3'b010;
	parameter column3 = 3'b100; 
	parameter ss = 3'b000; 
	parameter sb = 3'b001; 
	parameter so = 3'b010;
	 	
	assign key_stop = key_row[0] | key_row[1] | key_row[2] | key_row[3] ;
	assign key_col = state;
	
	//inital 
	initial
		begin 
		S<=0;B<=0;			
		s1<=0;b1<=0;
		s2<=0;b2<=0;
		s3<=0;b3<=0;
		s4<=0;b4<=0;
		dot_10 <= 10'b1111111111;
		dot_14 <= 14'b00000000000000;
		check_clk<=9'b011111111;
		check <= 0;
		end

	random_number(clk,stb,enb,n1,n2,n3,n4);

	//clk divide
	always @(posedge clk or posedge enb)  
		begin
	  	if(enb) begin counts <= 0; clk1 <= 1; end
		else if (counts >= 12499) begin counts <= 0; clk1 <= !clk1; end
		else counts <= counts +1; end

	//clk divide
	always @(posedge clk or posedge stb)  
		begin
	  	if(stb) begin check <= 0; countc <= 0; check_clk <= 9'b011111111; end
		else if(S==4) begin check_clk <= check_clk; check<=check; end 
		else if (countc >= 24999999) begin countc <= 0; check_clk <= check_clk >> 1; end
		else if (check_clk <= 9'b000000000) begin check_clk <= 9'b011111111; check <= check+1; end
		else countc <= countc +1; end
	
	// key pad scan FSM drive
	always @(posedge clk1 or posedge enb)
	begin
		if (enb) state <= no_scan;
		else begin
		  if (!key_stop) begin
		    case (state)
		    no_scan : state <= column1;
		    column1 : state <= column2;
		    column2 : state <= column3;
		    column3 : state <= column1;
		    default : state <= no_scan;
		    endcase
		  end
		end
	end

	// key_data

	always @ (posedge clk1) 
	begin
	case (state)
	  column1 : case (key_row)
	  	4'b0001 : key_data <= 1; // key_1
	  	4'b0010 : key_data <= 4; // key_4 
	  	4'b0100 : key_data <= 7; // key_7
	  	4'b1000 : key_data <= 0;
	  	endcase
	  column2 : case (key_row)
	  	4'b0001 : key_data <= 2; // key_2
	  	4'b0010 : key_data <= 5; // key_5 
	  	4'b0100 : key_data <= 8; // key_8
	  	4'b1000 : key_data <= 0; // key_0
	  	endcase
	  column3 : case (key_row)
	  	4'b0001 : key_data <= 3; // key_3
	  	4'b0010 : key_data <= 6; // key_6 
	  	4'b0100 : key_data <= 9; // key_9
	  	4'b1000 : submit <= 1;
	  	endcase	  	
	endcase

	//dip switch n_state 
	case (n_state)
		4'b0001 : nn1 <= key_data;
		4'b0010 : nn2 <= key_data;
		4'b0011 : begin nn2 <= key_data; nn1 <= key_data;end
		4'b0100 : nn3 <= key_data;
		4'b0101 : begin nn3 <= key_data; nn1 <= key_data;end
		4'b0110 : begin nn3 <= key_data; nn2 <= key_data;end
		4'b0111 : begin nn3 <= key_data; nn2 <= key_data; nn1 <= key_data;end
		4'b1000 : nn4 <= key_data;
		4'b1001 : begin nn4 <= key_data; nn1 <= key_data;end
		4'b1010 : begin nn4 <= key_data; nn2 <= key_data;end
		4'b1011 : begin nn4 <= key_data; nn2 <= key_data; nn1 <= key_data;end
		4'b1100 : begin nn4 <= key_data; nn3 <= key_data;end
		4'b1101 : begin nn4 <= key_data; nn3 <= key_data; nn1 <= key_data;end
		4'b1110 : begin nn4 <= key_data; nn3 <= key_data; nn2 <= key_data;end
		4'b1111 : begin nn4 <= key_data; nn3 <= key_data; nn2 <= key_data; nn1 <= key_data;end
	endcase
		end		

//sbo check
	always@(stb or check)
		if(stb)
			begin	
			S<=0;B<=0;			
			s1<=0;b1<=0;
			s2<=0;b2<=0;
			s3<=0;b3<=0;
			s4<=0;b4<=0;	
			end
		else 
			begin
			s1<=0;b1<=0;
			s2<=0;b2<=0;
			s3<=0;b3<=0;
			s4<=0;b4<=0;
				
			case(nn1)
				n1 : begin s1<=1;b1<=0; end
				n2 : begin b1<=1;s1<=0; end
				n3 : begin b1<=1;s1<=0; end
				n4 : begin b1<=1;s1<=0; end
			endcase
	
			case(nn2)
				n2 : begin s2<=1;b2<=0; end
				n1 : begin b2<=1;s2<=0; end
				n3 : begin b2<=1;s2<=0; end
				n4 : begin b2<=1;s2<=0; end
			endcase

		
			case(nn3)
				n3 : begin s3<=1;b3<=0; end			
				n1 : begin b3<=1;s3<=0; end
				n2 : begin b3<=1;s3<=0; end
				n4 : begin b3<=1;s3<=0; end
			endcase		


			case(nn4)	
				n4 : begin s4<=1;b4<=0; end
				n1 : begin b4<=1;s4<=0; end
				n2 : begin b4<=1;s4<=0; end
				n3 : begin b4<=1;s4<=0; end
			endcase
			
			S <= s1+s2+s3+s4; B <= b1+b2+b3+b4;
			end

//time
	times(clk, stb, S, COUNT_1, COUNT_10, COUNT_M);

//segment circulation
always@(negedge clk1) // SEL_SEG
	if(SEL_SEG==7) SEL_SEG <=0;
	else SEL_SEG <= SEL_SEG+1;

always@(SEL_SEG) 
	case(SEL_SEG)
	0 : SEG_SEL <= 8'b11111110;
	1 : SEG_SEL <= 8'b11111101;
	2 : SEG_SEL <= 8'b11111011;
	3 : SEG_SEL <= 8'b11110111;
	4 : SEG_SEL <= 8'b11101111;
	5 : SEG_SEL <= 8'b11011111;
	6 : SEG_SEL <= 8'b10111111;
	7 : SEG_SEL <= 8'b01111111;
	endcase

	
//key pad seg part
always@(*)
	begin
	if(check < 15)begin
	case (SEL_SEG) 
	0 : seg_TMP <= nn1;
	1 : seg_TMP <= nn2;
	2 : seg_TMP <= nn3;
	3 : seg_TMP <= nn4;
	4 : seg_TMP <= COUNT_1;
	5 : seg_TMP <= COUNT_10;
	6 : seg_TMP <= COUNT_M+20;
	7 : seg_TMP <= check;
	endcase end
	else if(check >= 15)
		seg_TMP <= 15;
	end
	DOT(S,B,clk, dot_14, dot_10);
 	SEG_DEC U0 (seg_TMP,SEG_C);
endmodule