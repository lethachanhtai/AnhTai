`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:54:35 PM
// Design Name: 
// Module Name: Register_Unit
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


module Register_Unit(data_out, data_in, load, clk, rst);
  parameter 		word_size = 8;
  output [word_size-1: 0] 	data_out;
  input 	[word_size-1: 0] 	data_in;
  input 			load;
  input 			clk, rst;
  reg 	[word_size-1: 0]	data_out;

  always @ (posedge clk or negedge rst)
    if (rst == 0) data_out <= 0; else if (load) data_out <= data_in;
endmodule
