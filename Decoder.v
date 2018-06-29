//0516016 蘇育劭 、 0516225 蔡坤哲
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer: 0516016 蘇育劭 、 0516225 蔡坤哲     
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    func_code_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o,
    BranchType_o,
    Jump_o,
    MemRead_o,
    MemWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] func_code_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;

//new
output [2-1:0] MemToReg_o;
output [2-1:0] BranchType_o;
output [2-1:0] Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;

//new
reg	[2-1:0]    MemToReg_o;
reg	[2-1:0]	   BranchType_o;
reg	[2-1:0]    Jump_o;
reg		       MemRead_o;
reg		       MemWrite_o;

//改寫Main function


//Parameter

//Main function
always @( * ) begin
	case(instr_op_i)
		6'b000000:	begin 		//R-type
			if(func_code_i == 6'b001000) begin
				Jump_o <= 2'b10;
				RegWrite_o <= 0;
				RegDst_o <= 0;	
				ALU_op_o <= 3'b010;
				ALUSrc_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
			end			
			else begin
				Jump_o <= 2'b00;
				RegWrite_o <= 1;
				RegDst_o <= 1;
				ALU_op_o <= 3'b010;
				ALUSrc_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
			end
		end
		6'b001000:	begin   	//addi
			ALU_op_o <= 3'b000;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		6'b000100:	begin 		//beq
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		6'b001011: begin 		//sltiu
			ALU_op_o <= 3'b011;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		6'b001111: begin 		//lui  li
			ALU_op_o <= 3'b000;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		6'b001101: begin        //ori
			ALU_op_o <= 3'b101;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		6'b000101: begin 		//bne
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
			end
		//new    
		6'b100011: begin 		//lw
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 1;
				MemWrite_o <= 0;
				MemRead_o <= 1;
				BranchType_o <= 0;
				Jump_o <= 0;
				
		end
		6'b101011: begin 		//sw
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 1;
			RegWrite_o <= 0;
			Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 1;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
				
		end
		6'b000010: begin 		//jump
			//ALU_op_o <= 3'b110;
			//ALUSrc_o <= 1;
			RegWrite_o <= 0;
			//RegDst_o <= 0;
			//Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 1;
		end
		6'b000011: begin 		//jal
			//ALU_op_o <= 3'b110;
			//ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 2;
			Branch_o <= 1;
				MemToReg_o <= 3;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 1;
		end
		6'b000110: begin   //ble
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 1;
				Jump_o <= 0;			
		end
		6'b000101: begin  //bnez
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 0;
				Jump_o <= 0;
		end
		6'b000001: begin  //bltz
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				BranchType_o <= 2;
				Jump_o <= 0;
		end						
	endcase
end
endmodule





                    
                    