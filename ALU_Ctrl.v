//0516016 蘇育劭 、 0516225 蔡坤哲
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer: 0516016 蘇育劭 、 0516225 蔡坤哲     
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
       
//Select exact operation 

always @(*) begin
	case(ALUOp_i)
		2:	begin 								//R-type
				case(funct_i)
					33:	ALUCtrl_o <= 4'b0010;	//addu
					35: ALUCtrl_o <= 4'b0110;	//subu
					36: ALUCtrl_o <= 4'b0;		//and
					37: ALUCtrl_o <= 4'b0001;	//or
					42: ALUCtrl_o <= 4'b0111;	//slt
					3 : ALUCtrl_o <= 4'b1000;   //sra
					7 : ALUCtrl_o <= 4'b1011;   //srav
					8 : ALUCtrl_o <= 4'b1101;   //JR Smith
					24: ALUCtrl_o <= 4'b1111;	//mul
				endcase
			end
		0:	ALUCtrl_o <= 4'b0010;				//addi
		1:	ALUCtrl_o <= 4'b0110;				//beq
		3:	ALUCtrl_o <= 4'b0111;				//sltiu
		4:  ALUCtrl_o <= 4'b0010; 				//lw , sw
		6:  ALUCtrl_o <= 4'b0011;				//lui
		5:  ALUCtrl_o <= 4'b0001; 				//ori
		7:  ALUCtrl_o <= 4'b1001; 				//bne
	endcase
end


endmodule     





                    
                    