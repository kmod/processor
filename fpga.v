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
		output wire [3:0] an,
		output wire RsTx,
		input wire RsRx
	);

	wire clk; // 10MHz clock
	dcm dcm(.CLK_IN(input_clk), .CLK_OUT(clk)); // 100MHz -> 10MHz DCM

	assign led = sw;
	
	// button synchronizer:
	reg [4:0] btn_sync, btn_sync2;
	always @(posedge clk) begin
		{btn_sync, btn_sync2} <= {btn, btn_sync};
	end
	
	wire [4:0] btn_debounced;
	genvar idx;
	generate
		for (idx=0; idx<5; idx=idx+1) begin: debounce_btn
			debounce btn_db(.clk(clk), .in(btn_sync2[idx]), .out(btn_debounced[idx]));
		end
	endgenerate
	
	reg [15:0] ctr;
	reg [4:0] btn_prev;
	always @(posedge clk) begin
		if (btn_debounced[0] && !btn_prev[0]) ctr <= ctr + 1'b1;
		if (btn_debounced[2] && !btn_prev[2]) ctr <= 0;
		
		btn_prev <= btn_debounced;
	end
	
	sseg #(.N(16)) sseg(.clk(clk), .in(ctr), .c(seg), .an(an));
	
	
	wire [7:0] uart_tx_data;
	assign uart_tx_data = 8'd65;
	wire uart_tx_req, uart_tx_ready;
	assign uart_tx_req = (btn_debounced[3] && !btn_prev[3]);
	/*
	Baud rates:
	@10MHz:
	115,200: 87 cycles
	*/
	uart_tranceiver #(.CLK_CYCLES(87)) uart_tx(.clk(clk), .data(uart_tx_data), .req(uart_tx_req), .ready(uart_tx_ready), .uart_tx(RsTx));
endmodule
