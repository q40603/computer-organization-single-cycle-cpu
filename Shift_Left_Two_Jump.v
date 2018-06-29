//0516016 蘇育劭 、 0516225 蔡坤哲
//Subject:      CO project 2 - Shift_Left_Two_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Shift_Left_Two_Jump(
    data_i,
    data_o
    );


//I/O ports                    
input [25:0] data_i;
output [27:0] data_o;

//shift left 2
assign data_o = data_i << 2;
     
endmodule
