//0516016 蘇育劭 、 0516225 蔡坤哲
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:  0516016 蘇育劭 、 0516225 蔡坤哲    
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module  Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_o_tmp;
wire [32-1:0] instr_o_tmp;
wire [32-1:0] sum_1_tmp;
wire [32-1:0] sum_2_tmp;
wire [5-1:0]  write_reg_tmp;
wire [2-1:0]  RegDst_o_tmp;
wire          RegWrite_o_tmp;
wire [32-1:0] instr_o_sign_tmp;
wire [32-1:0] result_o_tmp;
wire          zero_o_tmp;
wire [3-1:0]  ALU_op_o_tmp;
wire          ALUSrc_o_tmp;
wire          Branch_o_tmp;
wire [4-1:0]  ALUCtrl_o_tmp;
wire [32-1:0] RSdata_o_tmp;
wire [32-1:0] RTdata_o_tmp;
wire [32-1:0] data_o_tmp;
wire [32-1:0] data_o2_tmp;
wire [32-1:0] instr_o_sign_sh_tmp;
wire          select_i_tmp;
wire [2-1:0]  MemToReg_o_tmp;
wire          MemRead_o_tmp;
wire          MemWrite_o_tmp;
wire [2-1:0]  BranchType_o_tmp;
wire [2-1:0]  Jump_o_tmp;
wire [32-1:0] ReadData_o_tmp;
wire [32-1:0] Reg_WriteData_o_tmp;
wire [28-1:0] jump_shift_o_tmp;
wire [32-1:0] jump_addr_tmp;
wire [32-1:0] pc_in_i_tmp;
wire          Branch_data2_i_tmp;
wire          Mux_PC_Source_s;
wire          Neg_zero_o_tmp;
wire          Neg_result_o_tmp_31;

//Greate componentes


ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in_i_tmp) ,   
	    .pc_out_o(pc_o_tmp) 
	    );
	
Adder Adder1(
        .src1_i(pc_o_tmp),     
	    .src2_i(32'd4),     
	    .sum_o(sum_1_tmp)    
	    );

assign jump_shift_o_tmp = instr_o_tmp[25:0] << 2;
//new for Jump
/*Shift_Left_Two_Jump ShiftForJump(
        .data_i(instr_o_tmp[25:0]),
        .data_o(jump_shift_o_tmp)
        );
*/
assign jump_addr_tmp = {pc_o_tmp[31:28] , jump_shift_o_tmp};

MUX_3to1 #(.size(32)) Jump(
        .data0_i(data_o2_tmp),
        .data1_i(jump_addr_tmp),
        .data2_i(RSdata_o_tmp),
        .select_i(Jump_o_tmp),
        .data_o(pc_in_i_tmp)
        );



Instruction_Memory IM(
        .addr_i(pc_o_tmp),  
	    .instr_o(instr_o_tmp)    
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o_tmp[20:16]),
        .data1_i(instr_o_tmp[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst_o_tmp),
        .data_o(write_reg_tmp)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr_o_tmp[25:21]) ,  
        .RTaddr_i(instr_o_tmp[20:16]) ,  
        .RDaddr_i(write_reg_tmp) ,  
        .RDdata_i(Reg_WriteData_o_tmp), 
        .RegWrite_i (RegWrite_o_tmp),
        .RSdata_o(RSdata_o_tmp) ,  
        .RTdata_o(RTdata_o_tmp)   
        );
	
Decoder Decoder(                                //要改
        .instr_op_i(instr_o_tmp[31:26]), 
        .func_code_i(instr_o_tmp[5:0]),
	    .RegWrite_o(RegWrite_o_tmp), 
	    .ALU_op_o(ALU_op_o_tmp),   
	    .ALUSrc_o(ALUSrc_o_tmp),   
	    .RegDst_o(RegDst_o_tmp),   
	    .Branch_o(Branch_o_tmp),
            //新增
            .MemToReg_o(MemToReg_o_tmp),
            .BranchType_o(BranchType_o_tmp),
            .Jump_o(Jump_o_tmp),
            .MemRead_o(MemRead_o_tmp),
            .MemWrite_o(MemWrite_o_tmp)
	    );

ALU_Ctrl AC(
        .funct_i(instr_o_tmp[5:0]),   
        .ALUOp_i(ALU_op_o_tmp),   
        .ALUCtrl_o(ALUCtrl_o_tmp) 
        );
	
Sign_Extend SE(
        .data_i(instr_o_tmp[15:0]),
        .data_o(instr_o_sign_tmp)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o_tmp),
        .data1_i(instr_o_sign_tmp),
        .select_i(ALUSrc_o_tmp),
        .data_o(data_o_tmp)
        );	
		
ALU ALU(
        .src1_i(RSdata_o_tmp),
	    .src2_i(data_o_tmp),
	    .ctrl_i(ALUCtrl_o_tmp),
        .shamt_i(instr_o_tmp[10:6]),
	    .result_o(result_o_tmp),
	    .zero_o(zero_o_tmp)
	    );



//new
MUX_3to1 #(.size(1)) Branch(
        .data0_i(zero_o_tmp),
        .data1_i(zero_o_tmp | result_o_tmp[31]),
        .data2_i(result_o_tmp[31]),
        .select_i(BranchType_o_tmp),
        .data_o(Mux_PC_Source_s)
        );


		
Adder Adder2(
        .src1_i(sum_1_tmp),     
	    .src2_i(instr_o_sign_sh_tmp),     
	    .sum_o(sum_2_tmp)      
	    );
		
Shift_Left_Two #(.size(32)) Shifter(
        .data_i(instr_o_sign_tmp),
        .data_o(instr_o_sign_sh_tmp)
        ); 		
	

assign select_i_tmp = Mux_PC_Source_s & Branch_o_tmp;        
//要改	
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_1_tmp),
        .data1_i(sum_2_tmp),
        .select_i(select_i_tmp),
        .data_o(data_o2_tmp)
        );

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(result_o_tmp),
        .data_i(RTdata_o_tmp),
        .MemRead_i(MemRead_o_tmp),
        .MemWrite_i(MemWrite_o_tmp),
        .data_o(ReadData_o_tmp)
        );

MUX_4to1 #(.size(32)) MUX_Reg_WriteData(
        .data0_i(result_o_tmp),                 
        .data1_i(ReadData_o_tmp),
        .data2_i(instr_o_sign_tmp),
        .data3_i(sum_1_tmp),
        .select_i(MemToReg_o_tmp),
        .data_o(Reg_WriteData_o_tmp)
        );


endmodule
		  


