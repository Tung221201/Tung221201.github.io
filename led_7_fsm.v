`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:08:33 02/16/2023 
// Design Name: 
// Module Name:    fsm_chia_clock_hienthiso 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fsm_chia_clock_hienthiso(
	i_clk,
	i_rst_n, 
	i_enable, 
	i_up_down_n,
	o_an_out,
	o_seg
    );
	input wire  i_clk;
	input wire	i_rst_n;
	input wire	i_enable;
	input wire 	i_up_down_n;
    output reg	[3:0] o_an_out;
    output reg  [6:0] o_seg;
	reg 		[3:0] counter;
	reg			[3:0] seg_mid;
	reg			clk_1Hz 	= 1'b1;
	reg			clk_100Hz = 1'b1;
	reg   		[27:0] 	cnt_1Hz ;
	reg   		[27:0] 	cnt_100Hz ;
	reg 		[2:0] state;
	wire 		[3:0] chuc;
	wire 		[3:0] donvi;
	localparam	IDLE 	= 3'b001;
	localparam	UP	  	= 3'b010;
	localparam	DOWN 	= 3'b100;
	
	
	assign chuc = counter/10;
	assign donvi= counter%10*10;
	// chia clock thanh clk_1HZ and clk_100Hz
always @(posedge i_clk or negedge i_rst_n)
	begin
		if (!i_rst_n)
			begin
         clk_1Hz 		<= 0;
         cnt_1Hz 		<= 0;
			clk_100Hz	<= 0;
			cnt_100Hz 	<= 0;
			end
		else
			begin
				cnt_1Hz <= cnt_1Hz + 1;
				cnt_100Hz <= cnt_100Hz + 1;
            if ( cnt_1Hz == 50000000 )
            begin
                 cnt_1Hz <= 0;
                 clk_1Hz <= !clk_1Hz;
            end
				if ( cnt_100Hz == 500000 )
            begin 
                 cnt_100Hz <= 0;
                 clk_100Hz <= !clk_100Hz;
            end
			end
	end
 	
	// mo ta mach trang thai ke tiep va trang thai thanh ghi vao chung mot cai
always @(posedge clk_1Hz or negedge i_rst_n)
	begin
	if(!i_rst_n) state <= IDLE;
	else begin
		case(state) 
	   IDLE: begin
			if 			(i_enable == 0					  )	state <= IDLE;
			else if 	(i_enable == 1 && i_up_down_n == 1) state <= UP;
			else if 	(i_enable == 1 && i_up_down_n == 0) state <= DOWN;
		end
		UP:	begin
			if 			(i_enable == 1 && i_up_down_n == 1 && counter != 15) state <= UP;
			else if 	(i_enable == 1 && i_up_down_n == 1 && counter == 15) state <= IDLE;
			else if 	(i_enable == 1 && i_up_down_n == 0				   ) state <= DOWN;
		end
		DOWN:	begin 
			if 			(i_enable == 1 && i_up_down_n == 0 && counter != 0	) state <= DOWN;
			else if 	(i_enable == 1 && i_up_down_n == 0 && counter == 0	) state <= IDLE;
			else if 	(i_enable == 1 && i_up_down_n == 1					) state <= UP;
		end
		endcase
	end
	end
	// mo ta mach tao ngo ra
always @(posedge clk_1Hz or negedge i_rst_n)
	begin
	if (!i_rst_n) begin
						if(i_up_down_n) counter <= 0;
						else				 counter <= 15;
						end
	else	begin			
			case (state) 
			IDLE: begin
				if (i_up_down_n == 1) counter <= 0;
				else 				  counter <= 15;
					end
			UP:   					 counter <= counter + 1;
			DOWN:					 counter <= counter - 1;	
			endcase
	end
	end
	
// mo ta qua trinh quet led
always @(*)
	begin
		case (clk_100Hz)
			1'b0 : begin
			seg_mid = chuc ;
			o_an_out = 4'b1101 ;
			end
			1'b1 : begin
			seg_mid = donvi ;
			o_an_out = 4'b1110 ;
			end
		endcase
	end
	// hien thi so tu 1 den 9 
always @* begin 
           case(seg_mid)
           4'd0 : o_seg = 7'b1000000; //to display 0
           4'd1 : o_seg = 7'b1111001; //to display 1
           4'd2 : o_seg = 7'b0100100; //to display 2
           4'd3 : o_seg = 7'b0110000; //to display 3
           4'd4 : o_seg = 7'b0011001; //to display 4
           4'd5 : o_seg = 7'b0010010; //to display 5
           4'd6 : o_seg = 7'b0000010; //to display 6
           4'd7 : o_seg = 7'b1111000; //to display 7
           4'd8 : o_seg = 7'b0000000; //to display 8
           4'd9 : o_seg = 7'b0010000; //to display 9
           endcase 
         end
endmodule
