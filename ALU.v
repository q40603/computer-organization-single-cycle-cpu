//0516016 蘇育劭 、 0516225 蔡坤哲
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer: 0516016 蘇育劭 、 0516225 蔡坤哲     
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	shamt_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   shamt_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

//Parameter



//Main function
always @( * ) begin
	case (ctrl_i)
		0: result_o <= src1_i & src2_i;
		1: result_o <= src1_i | src2_i;						//or , ori
		2: result_o <= src1_i + src2_i;
		3: result_o <= src2_i << 16;						//lui
		6: begin
			result_o <= src1_i - src2_i;
			zero_o <= (result_o == 0) ? 1 : 0;  			//beq
			end						
		7: result_o <= src1_i < src2_i ? 1 : 0;				//slt
		8: result_o <= $signed(src2_i) >>> shamt_i;  		//sra
		9: 	begin
			result_o <= src1_i - src2_i;
			zero_o <= (result_o == 0) ? 0 : 1;  			//bne
			end
		11: result_o <= $signed(src2_i) >>> src1_i;			//srav
		12: result_o <= ~(src1_i | src2_i);					//result is nor
		15: result_o <= src1_i * src2_i;
		default: result_o <= 0;
	endcase
end

endmodule





                    
                    