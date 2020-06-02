`timescale 1ns / 1ps



module drawcon(input [11:0] sw,
                input [10:0] blkpos_x, blkpos_y, wall_x, gap_y, gap_size, draw_x, draw_y,
               output [3:0] r,g,b,
               output lose);
               
               reg [3:0] bg_r, bg_g, bg_b, blk_r, blk_g, blk_b, wall_r, wall_g, wall_b;
		reg[3:0] reg_r, reg_b, reg_g;
		reg collide;
               
               always@*
               begin
                    if(draw_x > 4'd9 & draw_x < 11'd1429 & draw_y > 4'd9 & draw_y < 11'd889 )  begin                  
                           bg_r = sw[3:0];
                           bg_b = sw[11:8];
                           bg_g = sw[7:4];
                    end
                    else begin
                           bg_r = 4'd15;
                           bg_b = 4'd15;
                           bg_g = 4'd15;
                    end

               end
               
               always@*
               begin
                    if(draw_x > blkpos_x & draw_x < blkpos_x + 6'd32 & draw_y > blkpos_y & draw_y < blkpos_y + 6'd32 )  begin                  
                           blk_r = 4'd13;
                           blk_b = 4'd8;
                           blk_g = 4'd7;
                    end
                    else begin
                           blk_r = 4'd0;
                           blk_b = 4'd0;
                           blk_g = 4'd0;
                    end
               end 
               

	       always@* begin

			if(draw_x > wall_x & draw_x < wall_x + 10 & ((draw_y < gap_y & draw_y > 9)| (draw_y > gap_y +gap_size & draw_y < 889))) begin
				wall_r = 4'd15;
				wall_b = 4'd0;
				wall_g = 4'd0;
			end
			else begin
				wall_r = 4'd0;
				wall_b = 4'd0;
				wall_g = 4'd0;
			end	
		end

		always@* begin
		
			if(blkpos_x > wall_x - 31 & blkpos_x < wall_x + 11 & (blkpos_y < gap_y | blkpos_y > gap_y + gap_size - 32))
				collide=1;
			else
				collide=0;
		end
              


		always@* begin
		
			if(collide) begin
				reg_r=15;
				reg_b=0;
				reg_g=0;
			end
			else begin
				if(blk_r + wall_r == 0)begin
					reg_r=bg_r;
					reg_b=bg_b;
					reg_g=bg_g;
				end
				else begin
					reg_r=blk_r+wall_r;	
					reg_g=blk_g+wall_g;
					reg_b=blk_b+wall_b;
		end
end 
end

              assign lose = collide;

	       assign r = reg_r;
               assign g = reg_g;
               assign b = reg_b;
               
endmodule
