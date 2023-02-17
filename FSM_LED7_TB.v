`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:45:28 02/17/2023
// Design Name:   fsm_chia_clock_hienthiso
// Module Name:   D:/Acronics Solution/FSM_bai1/new_tb.v
// Project Name:  FSM_bai1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fsm_chia_clock_hienthiso
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module new_tb;

	// Inputs
	reg i_clk;
	reg i_rst_n;
	reg i_enable;
	reg i_up_down_n;

	// Outputs
	wire [3:0] o_an_out;
	wire [6:0] o_seg;
	wire [3:0] counter;

	// Instantiate the Unit Under Test (UUT)
	fsm_chia_clock_hienthiso uut (
		.i_clk(i_clk), 
		.i_rst_n(i_rst_n), 
		.i_enable(i_enable), 
		.i_up_down_n(i_up_down_n), 
		.o_an_out(o_an_out), 
		.o_seg(o_seg), 
		.counter(counter)
	);
 
	initial begin
		i_clk = 0 ;
		forever #5 i_clk = !i_clk ;
		end
		initial begin
		i_rst_n = 0;
		#10 i_rst_n = 1;
	end
	initial begin
		// Initialize Inputs
		i_enable = 1;
		i_up_down_n = 1;
		#400000000;
		i_up_down_n = 0;
		// Wait 100 ns for global reset to finish
		#500000000;
		i_up_down_n = 1;
		#500000000;
		i_enable = 0;
		#100000000;
		i_rst_n = 0;
		#40000000;
		i_rst_n = 1;
		i_enable = 1;
		i_up_down_n = 0; 
		#100000000;
		i_enable = 0;
		#100000000;
		i_enable = 1;
		i_up_down_n = 1; 
		#100000000;
		i_enable = 0;
		#100000000;
		i_enable = 1;
		i_up_down_n = 0; 
		#1000;
		end   
endmodule

