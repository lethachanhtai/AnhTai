`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:52:10 PM
// Design Name: 
// Module Name: Memory_Unit
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


module Memory_Unit(data_out, data_in, address, clk, write);
  parameter word_size = 8;
  parameter memory_size = 256; //Tao ra 256 dia chi

  output [word_size-1: 0] data_out;
  input [word_size-1: 0] data_in;
  input [word_size-1: 0] address;
  input clk, write;
  reg [word_size-1: 0] memory [memory_size-1: 0];// M?ng memory ch?a 256 ph?n t? (t? memory[0] ð?n memory[255]), m?i ph?n t? là m?t t? 8 bit.

  assign data_out = memory[address];// data_out lay ra tu dia chi trong o nho

  always @ (posedge clk)
    if (write) memory[address] = data_in;// Ghi giá tr? c?a data_in (8 bit) vào v? trí b? nh? ðý?c ch? ð?nh b?i address.
endmodule
