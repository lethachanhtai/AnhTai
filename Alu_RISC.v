`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:59:36 PM
// Design Name: 
// Module Name: Alu_RISC
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


module Alu_RISC(alu_zero_flag, alu_out, data_1, data_2, sel);
  parameter word_size = 8;
  parameter op_size = 4;
  // Opcodes
  parameter NOP 	= 4'b0000;
  parameter ADD 	= 4'b0001;
  parameter SUB 	= 4'b0010;
  parameter AND 	= 4'b0011;
  parameter NOT 	= 4'b0100;
  parameter RD  	= 4'b0101;
  parameter WR		= 4'b0110;
  parameter BR		= 4'b0111;
  parameter BRZ 	= 4'b1000;
  parameter SHL     = 4'B1001;
  parameter SHR     = 4'B1010;
  parameter SUBT    = 4'B1011;
  


  output 			alu_zero_flag;
  output [word_size-1: 0] 	alu_out;
  input 	[word_size-1: 0] 	data_1, data_2;
  input 	[op_size-1: 0] 	sel;
  reg 	[word_size-1: 0]	alu_out;

  assign  alu_zero_flag = ~|alu_out;
  //C? zero ðý?c kích ho?t (1) khi t?t c? bit c?a alu_out = 0:
  //Toán t? | th?c hi?n OR t?t c? bit, ~ ð?o ngý?c k?t qu?
  always @ (sel or data_1 or data_2)  
     case  (sel)
      NOP:	alu_out = 0;
      ADD:	alu_out = data_1 + data_2;  // Reg_Y + Bus_1
      SUB:	alu_out = data_2 - data_1;
      AND:	alu_out = data_1 & data_2;
      SHL:  alu_out = data_2 << 1;
      SHR:  alu_out = data_2 >> 1;
      NOT:	alu_out = ~ data_2;	 // Gets data from Bus_1
      SUBT: alu_out = data_2 +  1;
      default: 	alu_out = 0;
    endcase 
endmodule
