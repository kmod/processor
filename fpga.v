`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:12:55 07/16/2013 
// Design Name: 
// Module Name:    fpga 
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
module fpga(
		input wire input_clk,
		input wire [7:0] sw,
		input wire [4:0] btn,
		output wire [7:0] led,
		output wire [7:0] seg,
		output wire [3:0] an
	);

	wire clk; // 10MHz clock
	dcm dcm(.CLK_IN(input_clk), .CLK_OUT(clk)); // 100MHz -> 10MHz DCM

	assign led = sw;
	
	reg [15:0] ctr;
	always @(posedge clk) begin
		if (btn[0]) ctr <= ctr + 1'b1;
	end
	
	sseg #(.N(16)) sseg(.clk(clk), .in(ctr), .c(seg), .an(an));
endmodule
