// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg unsigned [psum_bw-1:0] psum_uq;
reg signed [psum_bw-1:0] psum_mag;

reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;
reg unsigned [bw-1:0] A_q;
reg unsigned [bw-1:0] B_q;


assign out = psum_q;

// Your code goes here

always@(posedge clk) begin
	if(reset) begin
		psum_q <= 15'b0;
		psum_uq <= 15'b0;
		a_q    <=  7'b0;
		b_q    <=  7'b0;
	end
	else begin
		a_q <= A;
		b_q <= B;

		if(acc) begin
			if(format) begin
		         	psum_q <= psum_uq;
			end
			else begin
				psum_q <= psum_q + a_q*b_q;
			end
		end
		else psum_q <= psum_q;
	end
end


always@(*) begin
	if(reset) begin
		psum_uq = 15'b0;
	end
	else begin
		if(acc) begin
			if(format) begin
		         	if(psum_uq[15] != psum_mag[15]) begin
						if(psum_uq[psum_bw-2:0] > psum_mag[psum_bw-2:0]) begin
							psum_uq[14:0] = psum_uq[14:0] - psum_mag[14:0];
						end else begin
                                                        psum_uq[14:0] = psum_mag[14:0] - psum_uq[14:0];	
							psum_uq[15] = psum_mag[15];
						end
				end
				else begin 
					psum_uq[14:0] = psum_uq[14:0] + psum_mag[14:0]; 
				end
			end
			else begin
				psum_uq = 'b0;
			end
		end
		else psum_uq = 'b0;
	end
end

always@(*) begin
	if(reset) begin
	        psum_mag = 15'b0;
		A_q = 7'b0;
		B_q = 7'b0;
	end
	else begin
		A_q = A;
		B_q = B;
		if(acc) begin
			if(format) begin
                                psum_mag = A_q[6:0]*B_q[6:0];
				if(A_q[7] != B_q[7]) begin
					psum_mag[15] = 1'b1;
				end
				else begin     
					psum_mag[15] = 1'b0;
				end
			end
			else psum_mag = 15'b0;
		end
		else psum_mag = 15'b0;;
	end
end
					
	      	

endmodule
