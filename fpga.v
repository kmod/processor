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
		input wire clk,
		input wire [7:0] sw,
		output wire [7:0] led,
		output wire [7:0] seg,
		output wire [3:0] an
	);

	assign led = sw;
	
	sseg sseg(.clk(clk), .in({sw, sw}), .c(seg), .an(an));
endmodule
