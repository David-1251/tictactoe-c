`timescale 1ns / 1ps


module game_top(input clk, sw_up, sw_down, sw_left, sw_right, sw_centre,
        input [11:0] sw,
		output [3:0] pix_r, pix_b, pix_g, 
		output hsync, vsync,
		output a, b, c, d, e, f, g,
        output [7:0] an
        ); 
	
 	
wire [10:0] curr_x, curr_y;
        reg [10:0] blkpos_x = 11'd704, blkpos_y = 11'd435, wall_x = 0, gap_y = 11'd400, gap_size = 11'd150, lose_count = 4'd200;
        wire [3:0] rin, gin, bin;
        wire vga_clk, lose;
        wire logic_clk, points_clk;
        reg [16:0] clk_count = 0;
        reg [3:0] clk_count2 = 0;
        reg clk_60hz, clk_10hz,reset,stop;
        wire clk_4687khz;

clk_wiz_0 clk_div_106mhz(.clk_in1(clk),.clk_out1(vga_clk),.clk_out2(clk_4687khz));

vga_out m1(.clk(vga_clk), .rin(rin), .gin(gin), .bin(bin), 
            .pix_r(pix_r), .pix_b(pix_b), .pix_g(pix_g), 
			.hsync(hsync), .vsync(vsync), 
			.curr_x(curr_x), .curr_y(curr_y));

			
drawcon alex(.sw(sw),.blkpos_x(blkpos_x), .blkpos_y(blkpos_y), .wall_x(wall_x), .gap_y(gap_y), .gap_size(gap_size), .draw_x(curr_x), .draw_y(curr_y),
             .r(rin),.g(gin),.b(bin), .lose(lose));
            
points ptolemy(.clk(clk), .reset(reset), .stop(stop), .points_clk(points_clk), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .an(an));
                         
          
always@(posedge clk_4687khz) begin
	
	if(clk_count == 17'd19525) begin
		clk_60hz <= ~clk_60hz;
		clk_count <= 0;
		
		if(clk_count2 == 3'd5)  
			clk_10hz <= ~clk_10hz;
		
		else
			clk_count2 <= clk_count2 + 1;

	end

	else
		clk_count <= clk_count + 1;

end



assign logic_clk = clk_60hz;
assign points_clk = clk_10hz;



always@(posedge logic_clk)	begin
    if(lose_count > 11'd360 & lose_count < 11'd400)
		reset = 1;
	else
	   reset = 0;
	   
	if (lose_count < 11'd5) begin
			blkpos_x<=11'd704; 
            blkpos_y<=11'd435;
    end
    
    else begin
        if(sw_down & blkpos_y < 11'd856) blkpos_y <= blkpos_y + 11'd3;	
        if(sw_up & blkpos_y > 11'd14) blkpos_y <= blkpos_y - 11'd3;
        if(sw_right & blkpos_x < 11'd1396) blkpos_x <= blkpos_x + 11'd3;    
        if(sw_left & blkpos_x > 11'd10) blkpos_x <= blkpos_x - 11'd3;
    end
    
	if(lose_count < 11'd400) begin
		stop = 1;
	end
	
	else  begin  
        stop = 0;
	   
    end	
end


always@(posedge logic_clk) begin
	if(lose)
		lose_count <= 0;
	else
		if(lose_count < 11'd400)
			lose_count <= lose_count + 1;
	
end



always@(posedge logic_clk) begin
	if(lose_count<11'd400) begin
		wall_x <= 0;
		gap_size <= 11'd150;
		gap_y <= 11'd400;
	end

	else begin
		if(wall_x > 11'd1429) begin
			
			wall_x <= 0;
			
				if(gap_y-4'd9 < 11'd889 - gap_y)
					gap_y <= (11'd889 + gap_y)/2 +4'd10;
				else
					gap_y <= (4'd9 + gap_y)/2 - 4'd10;
					
					if(gap_size > 45)
					       gap_size <= gap_size - 11'd10;
					       
		end
		else
			wall_x <= wall_x+11'd4;
	end
end







endmodule