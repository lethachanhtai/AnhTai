`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:55:21 PM
// Design Name: 
// Module Name: D_flop
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


module D_flop(data_out, data_in, load, clk, rst);
  output 		data_out;
  input 		data_in;
  input 		load;
  input 		clk, rst;
  reg 		data_out;//luôn luôn ph?i có reg khi có kh?i always

  always @ (posedge clk or negedge rst)
    if (rst == 0) data_out <= 0; else if (load == 1)data_out <= data_in;
endmodule
