`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 01:51:43 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
  Load_R0, Load_R1, 
  Load_R2, Load_R3, 
  Load_PC, Inc_PC, 
  Sel_Bus_1_Mux, Sel_Bus_2_Mux,
  Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, 
  write, instruction, zero, clk, rst);
 
  parameter word_size = 8, op_size = 4, state_size = 4;
  parameter src_size = 2, dest_size = 2, Sel1_size = 3, Sel2_size = 2;
  // State Codes
  parameter S_idle = 0, S_fet1 = 1, S_fet2 = 2, S_dec = 3;
  parameter  S_ex1 = 4, S_rd1 = 5, S_rd2 = 6;  
  parameter S_wr1 = 7, S_wr2 = 8, S_br1 = 9, S_br2 = 10, S_halt = 11;  
  // Opcodes
  parameter NOP = 0, ADD = 1, SUB = 2, AND = 3, NOT = 4, SHL = 9, SHR = 10, SUBT = 11;
  parameter RD  = 5, WR =  6,  BR =  7, BRZ = 8;  
  // Source and Destination Codes  
  parameter R0 = 0, R1 = 1, R2 = 2, R3 = 3;  

  output Load_R0, Load_R1, Load_R2, Load_R3;
  output Load_PC, Inc_PC;
  output [Sel1_size-1:0] Sel_Bus_1_Mux;
  output Load_IR, Load_Add_R;
  output Load_Reg_Y, Load_Reg_Z;
  output [Sel2_size-1: 0] Sel_Bus_2_Mux;
  output write;
  input [word_size-1: 0] instruction;
  input zero;
  input clk, rst;
 
  reg [state_size-1: 0] state, next_state;
  reg Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC;
  reg Load_IR, Load_Add_R, Load_Reg_Y;
  reg Sel_ALU, Sel_Bus_1, Sel_Mem;
  reg Sel_R0, Sel_R1, Sel_R2, Sel_R3, Sel_PC;
  reg Load_Reg_Z, write;
  reg err_flag;
  
 // Thao tác Bit Slicing c?t bit
  wire [op_size-1:0] opcode = instruction [word_size-1: word_size - op_size];
 //    opcode n?m ? bit 7 ð?n 4           [    7          :      4         ]
  wire [src_size-1: 0] src = instruction [src_size + dest_size -1: dest_size];
 // Bit ngu?n n?m ? bit 3 ð?n 2          [     3                 :  2      ]
  wire [dest_size-1:0] dest = instruction [dest_size -1:0];
 // Bit cu?i n?m ? bit 1 ð?n 0            [   1        :0]
 
  // Mux selectors
  assign  Sel_Bus_1_Mux[Sel1_size-1:0] = Sel_R0 ? 0:
                                      //n?u Sel_R0 = 1, gán Sel_Bus_1_Mux = 0
				 Sel_R1 ? 1:         //n?u Sel_R1 = 1, gán Sel_Bus_1_Mux = 1
				 Sel_R2 ? 2:        //n?u Sel_R2 = 1, gán Sel_Bus_1_Mux = 2
				 Sel_R3 ? 3:
				 Sel_PC ? 4: 3'bx;  // 3-bits, sized number

  assign  Sel_Bus_2_Mux[Sel2_size-1:0] = Sel_ALU ? 0:
				 Sel_Bus_1 ? 1:
				 Sel_Mem   ? 2: 2'bx;

  always @ (posedge clk or negedge rst) begin: State_transitions
    if (rst == 0) state <= S_idle; else state <= next_state; end
    always @ (state or opcode or zero) begin: Output_and_next_state 
    Sel_R0 = 0; 	Sel_R1 = 0;     Sel_R2 = 0;    	Sel_R3 = 0;    Sel_PC = 0;
    Load_R0 = 0; 	Load_R1 = 0; 	Load_R2 = 0; 	Load_R3 = 0;	Load_PC = 0;
    Load_IR = 0;	Load_Add_R = 0;	Load_Reg_Y = 0;	Load_Reg_Z = 0;
    Inc_PC = 0; 
    Sel_Bus_1 = 0; 
    Sel_ALU = 0; 
    Sel_Mem = 0; 
    write = 0; 
    err_flag = 0;	// Used for de-bug in simulation		
    next_state = state;

     case  (state)	S_idle:		next_state = S_fet1;      //state 0
                    S_fet1:		begin       	  	  	  //state 1
                                next_state = S_fet2; 
      	  	  		            Sel_PC = 1;
      	  	  		            Sel_Bus_1 = 1;
      	  	   		            Load_Add_R = 1; 
    				            end
      		        S_fet2:		begin 		             //state 2
                                next_state = S_dec; 
                                Sel_Mem = 1;
      	  	  		            Load_IR = 1; 
      	  	  		            Inc_PC = 1;
    				             end

      		        S_dec:    case  (opcode)           //state 3
      		 		           NOP: next_state = S_fet1;
		  		               ADD, SUB, AND, SHR, SHL,SUBT: begin
 		    		           next_state = S_ex1;
		    		           Sel_Bus_1 = 1;
		    		           Load_Reg_Y = 1;
		     		          case  (src)
		      		          R0: 		Sel_R0 = 1; 
		      		          R1: 		Sel_R1 = 1; 
		      		          R2: 		Sel_R2 = 1;
		      		          R3: 		Sel_R3 = 1; 
		      		          default : 	err_flag = 1;
		    		          endcase   
                              end // ADD, SUB, AND

			 	              NOT: begin
			    	          next_state = S_fet1;
			    	          Load_Reg_Z = 1;
			    	          Sel_Bus_1 = 1; 
			    	          Sel_ALU = 1; 
		 	     	          case  (src)
			      	          R0: 		Sel_R0 = 1;			      
      				          R1: 		Sel_R1 = 1;
			      	          R2: 		Sel_R2 = 1;			      
 			      	          R3: 		Sel_R3 = 1; 
			      	          default : 	err_flag = 1;
			    	          endcase   
  			     	          case  (dest)
			      	          R0: 		Load_R0 = 1; 
			      	          R1: 		Load_R1 = 1;			      
      				          R2: 		Load_R2 = 1;
			      	          R3: 		Load_R3 = 1;			      
      				          default: 	err_flag = 1;
			    	            endcase   
                                  end // NOT
  				             RD: begin
			    	         next_state = S_rd1;
			    	         Sel_PC = 1; Sel_Bus_1 = 1; Load_Add_R = 1; 
                             end // RD
			  	             WR: begin
			    	         next_state = S_wr1;
			    	         Sel_PC = 1; Sel_Bus_1 = 1; Load_Add_R = 1; 
                             end  // WR
			  	             BR: begin 
			    	         next_state = S_br1;  
                             Sel_PC = 1; Sel_Bus_1 = 1; Load_Add_R = 1; 
			    	         end  // BR
  				             BRZ: if (zero == 1) begin        // Neu alu tru ra 0 thi zero == 1 
			    	         next_state = S_br1;     // thuc hien lenh load dia chi 2 lan de dung may
                             Sel_PC = 1; Sel_Bus_1 = 1; Load_Add_R = 1; 
			    	         end // BRZ                
			  	             else begin 
                             next_state = S_fet1; 
                             Inc_PC = 1; 
                             end
        		  	         default : next_state = S_halt;
				             endcase  // (opcode)


  	                  S_ex1:		begin                       //state 4
  			  	              next_state = S_fet1;
			  	              Load_Reg_Z = 1;
			  	              Sel_ALU = 1; 
		 	   	            case  (dest)
  	    		    	    R0: begin Sel_R0 = 1; Load_R0 = 1; end
			    	        R1: begin Sel_R1 = 1; Load_R1 = 1; end
			    	        R2: begin Sel_R2 = 1; Load_R2 = 1; end
			    	        R3: begin Sel_R3 = 1; Load_R3 = 1; end
			    	        default : err_flag = 1; 
			   	        endcase  
				     end 

    	             S_rd1:		begin                //state5
                            next_state = S_rd2;
			  	            Sel_Mem = 1;
			  	            Load_Add_R = 1; 
			  	            Inc_PC = 1;
			                end

    	         	 S_wr1: 		begin               //state 7
			  	            next_state = S_wr2;
			  	            Sel_Mem = 1;
			  	            Load_Add_R = 1; 
			  	            Inc_PC = 1;
				            end 

      		       S_rd2:		begin               //state 6
  			  	            next_state = S_fet1;
			  	            Sel_Mem = 1;
		 	   	        case  (dest) 
    			            R0: 		Load_R0 = 1; //Neu dest la 0 th? ch?n R0 ðýa Load_R0 lên 1
		 	    	        R1: 		Load_R1 = 1; //Neu dest la 1 th? ch?n R1
		 	    	        R2: 		Load_R2 = 1; //Neu dest la 2 thi ch?n R2
		 	    	        R3: 		Load_R3 = 1; 
			    	      default : 	err_flag = 1;
			  	    endcase  
			   	end

              	   S_wr2:		begin                    //state 8
     			    	  next_state = S_fet1;
			  	          write = 1;
		 	  	      case  (src)
    			        R0: 		Sel_R0 = 1;		 	    
    			     	R1: 		Sel_R1 = 1;		 	    
   				        R2: 		Sel_R2 = 1; 		 	    
   				        R3: 		Sel_R3 = 1;			    
    				default : 	err_flag = 1;
			  	  endcase  
				end

    	        	S_br1:		begin next_state = S_br2; Sel_Mem = 1; Load_Add_R = 1; end //state 9
    	         	S_br2:		begin next_state = S_fet1; Sel_Mem = 1; Load_PC = 1; end  //state 10
    	      	    S_halt:  		next_state = S_halt;    //state 11
		        default:		next_state = S_idle;
     endcase    
  end
endmodule
