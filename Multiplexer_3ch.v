`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:59:05 PM
// Design Name: 
// Module Name: Multiplexer_3ch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplexer_3ch(mux_out, data_a, data_b, data_c, sel);
  parameter 	word_size = 8;
  output 		[word_size-1: 0]	 mux_out;
  input 		[word_size-1: 0] 	data_a, data_b, data_c;
  input 		[1: 0] sel;

  assign  mux_out = (sel == 0) ? data_a: (sel == 1) ? data_b : (sel == 2) ? data_c: 'bx;
endmodule
