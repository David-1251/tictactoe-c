`timescale 1ns / 1ps


module vga_out (input clk,
		input [3:0] rin, gin, bin, 
		output [3:0] pix_r, pix_b, pix_g, 
		output hsync, vsync,
		output [10:0] curr_x, curr_y
		); 
 
reg [10:0] hcount = 11'd0, xcount = 11'd0, ycount = 10'd0;
reg [9:0] vcount = 10'd0; 

 
always @ (posedge clk) 
begin 
	if (hcount == 11'd1903) 
	begin 
		hcount <= 11'd0; 

		if (vcount == 10'd931) 
			vcount <= 10'd0; 

		else begin
			vcount <= vcount + 1'd1;
		    if (vcount == 10'd32)
                    ycount <= 0;
			if (vcount > 10'd32) begin
			if (vcount < 10'd930)
                    ycount <= ycount + 1;
         end
			 
	end
	end 

	else
		hcount <= hcount + 1'd1;
		
	if (hcount == 11'd384)
                xcount <= 0; 
                 
	if (hcount > 11'd384) begin
	if (hcount < 11'd1824)
		xcount <= xcount + 1;
    end

			
end

assign curr_x = xcount;
assign curr_y = ycount;

assign hsync = (hcount > 11'd151) ? 1 : 0; 
assign vsync = (vcount > 11'd2) ? 0 : 1; 
 
assign pix_r = (hcount < 11'd384) ? 4'd0 : (hcount > 11'd1824) ? 4'd0 : (vcount < 10'd30) ? 4'd0 : rin; 
assign pix_g = (hcount < 11'd384) ? 4'd0 : (hcount > 11'd1824) ? 0 : (vcount < 10'd30) ? 4'd0 : gin; 
assign pix_b = (hcount < 11'd384) ? 4'd0 : (hcount > 11'd1824) ? 0 : (vcount < 10'd30) ? 4'd0 : bin;
 
 
endmodule


