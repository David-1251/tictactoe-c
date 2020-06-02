`timescale 1ns / 1ps


module points(
    	input clk, 
    	input reset, stop,
	    input points_clk,
    	output a,
    	output b,
      	output c,
    	output d,
    	output e,
    	output f,
    	output g,
    	output [7:0] an
    );


     wire div_clk;
     reg [3:0] points0 = 0, points1 = 0, points2 = 0, points3 = 0, points4 = 0, points5 = 0, points6 = 0, points7 = 0;
     wire [31:0] points;

     assign points = {points7, points6, points5, points4, points3, points2, points1, points0};

     always@(posedge points_clk)  begin
    
    if (reset == 0) begin
    if (stop == 0) begin
	if(points0 == 4'd9)  begin
		points0 <= 0;

		if(points1 == 4'd9)  begin
			points1 <= 0;

			if(points2 == 4'd9)  begin
				points2 <= 0;

				if(points3 == 4'd9)  begin
					points3 <= 0;

					if(points4 == 4'd9)  begin
						points4 <= 0;

						if(points5 == 4'd9)  begin
							points5 <= 0;

							if(points6 == 4'd9)  begin
								points6 <= 0;

								if(points7 == 4'd9)  
									points7 <= 0;

								else
									points7 <= points7 + 1;

							end

							else
								points6 <= points6 + 1;

						end
						
						else
							points5 <= points5 + 1;
		
					end
						
					else
						points4 <= points4 + 1;

				end

				else
					points3 <= points3 + 1;

			end

			else
				points2 <= points2 + 1;

		end

		else
			points1 <= points1 + 1;

	end
		
	else
		points0 <= points0 + 1;
		
	end
	end
	
	else begin
	
	points0 <= 0;
	points1 <= 0;
	points2 <= 0;
	points3 <= 0;
	points4 <= 0;
	points5 <= 0;
	points6 <= 0;
	points7 <= 0;
	
	end

end		
			
			








       
     wire [3:0] dig0 = points[3:0];
     wire [3:0] dig1 = points[7:4];
     wire [3:0] dig2 = points[11:8];
     wire [3:0] dig3 = points[15:12];
     wire [3:0] dig4 = points[19:16];
     wire [3:0] dig5 = points[23:20];
     wire [3:0] dig6 = points[27:24];
     wire [3:0] dig7 = points[31:28];
       
       
     seginterface mod1 (
		.a(a),
                .b(b),
                .c(c),
                .d(d),
                .e(e),
                .f(f),
                .g(g),
                .an(an),
                .clk(clk),
                .rst(rst),
                .div_clk(div_clk),
                .dig0(dig0),
                .dig1(dig1),
                .dig2(dig2),
                .dig3(dig3),
                .dig4(dig4),
                .dig5(dig5),
                .dig6(dig6),
                .dig7(dig7)
	   );
                       
  
                       
                       
endmodule
