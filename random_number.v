module random_number(clk,stb,enb,n1,n2,n3,n4);
	input clk,stb,enb;
	output n1,n2,n3,n4;
	reg [3:0] n1,n2,n3,n4;
	reg [3:0] COUNT_1, COUNT_10, COUNT_100, COUNT_1000;
	reg [31:0] CLK_COUNT;
	reg CLK1;
	
	initial
	begin
	n1<=0; n2<=0; n3<=0; n4<=0;
	end
	//CLK1
	always @(negedge clk or posedge enb) // CLK/10
		if(enb) CLK1<=0;
		else if (CLK_COUNT==9) 
			begin 
			CLK_COUNT<=0; CLK1<=1; 
			end
		else 
			begin 
			CLK_COUNT <= CLK_COUNT+1; 
			CLK1<=0;
			end

	//COUNT_1
	always @(negedge CLK1 or posedge enb) // COUNT_1
		if(enb) COUNT_1<=0;
		else if (COUNT_1==9) COUNT_1<=0;
		else COUNT_1 <= COUNT_1+1;

	//COUNT_10
	always @(negedge CLK1 or posedge enb) // COUNT_10
		if(enb) COUNT_10<=0;
		else if (COUNT_1 ==9) 
			begin
			if (COUNT_10==9) COUNT_10<=0;
			else COUNT_10 <= COUNT_10+1; 
			end

	//COUNT_100
	always @(negedge CLK1 or posedge enb) // COUNT_100
		begin
		if(enb) COUNT_100<=0;
		else if((COUNT_1 ==9) && (COUNT_10==9)) 
			begin
			if (COUNT_100==9) COUNT_100<=0;
			else COUNT_100 <= COUNT_100+1; 
			end
		end

	//COUNT_1000
	always @(negedge CLK1 or posedge enb) // COUNT_100
		begin
		if(enb) COUNT_1000<=0;
		else if((COUNT_1 ==9) && (COUNT_10==9)&& (COUNT_100==9)) 
			begin
			if (COUNT_1000==9) COUNT_1000<=0;
			else COUNT_1000 <= COUNT_1000+1; 
			end
		end
	
	//start, end	
	always @(negedge CLK1 or posedge stb)
		begin
		if(stb) 
			begin
			n1<=COUNT_1;
			n2<=COUNT_10;
			n3<=COUNT_100;
			n4<=COUNT_1000;
			end
		end

endmodule