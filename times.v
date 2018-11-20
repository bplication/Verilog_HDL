module times(CLK, RESET,S,COUNT_1, COUNT_10, COUNT_M);

input CLK, RESET, S;
output [3:0] COUNT_1, COUNT_10, COUNT_M;
reg [2:0] S;
reg [3:0] COUNT_1, COUNT_10, COUNT_M, COUNT_TMP;
reg [31:0] CLK_COUNT;
reg [7:0] CLK_COUNT0;
reg CLK1;
reg CLK0;

always @(negedge CLK or posedge RESET) // CLK/0
	if(RESET) CLK0<=0;
	else if (CLK_COUNT0==100) begin CLK_COUNT0<=0; CLK0<=1; end
	else begin CLK_COUNT0 <= CLK_COUNT0+1; CLK0<=0; end

always @(negedge CLK or posedge RESET) // CLK/1
	if(RESET) CLK1<=0;
	else if (CLK_COUNT==24999999) begin CLK_COUNT<=0; CLK1<=1; end
	else begin CLK_COUNT <= CLK_COUNT+1; CLK1<=0; end

always @(negedge CLK1 or posedge RESET) // COUNT_1
	if(RESET) COUNT_1<=0;
	else if(S==4) COUNT_1<=COUNT_1; 
	else if (COUNT_1==9) COUNT_1<=0;
	else COUNT_1 <= COUNT_1+1;

always @(negedge CLK1 or posedge RESET) // COUNT_10
	if(RESET) COUNT_10<=0;
	else if(S==4) COUNT_10<=COUNT_10; 
	else if (COUNT_1 ==9) begin
	if (COUNT_10==5) COUNT_10<=0;
	else COUNT_10 <= COUNT_10+1; end

always @(negedge CLK1 or posedge RESET) // COUNT_100
	begin
	if(RESET) COUNT_M<=0;
	else if(S==4) COUNT_M<=COUNT_M; 
	else if((COUNT_1 ==9) && (COUNT_10==5)) 
		begin
		if (COUNT_M==9) COUNT_M<=0;
		else COUNT_M <= COUNT_M+1; 
		end
	end


endmodule
