`define  MEM_ROW_ADDR_WIDTH    15
`define  MEM_COL_ADDR_WIDTH    10
`define  MEM_BADDR_WIDTH       3
`define  MEM_DQ_WIDTH           32
`define  MEM_DM_WIDTH      `MEM_DQ_WIDTH/8
`define  MEM_DQS_WIDTH     `MEM_DQ_WIDTH/8
`define  CTRL_ADDR_WIDTH   `MEM_ROW_ADDR_WIDTH + `MEM_BADDR_WIDTH + `MEM_COL_ADDR_WIDTH  //28

//MODE_1080p
`define V_TOTAL  12'd1125
    `define V_FP  12'd4
    `define V_BP  12'd36
    `define V_SYNC  12'd5
    `define V_ACT  12'd1080
    `define H_TOTAL  12'd2200
    `define H_FP  12'd88
    `define H_BP  12'd148
    `define H_SYNC  12'd44
    `define H_ACT  12'd1920
    `define HV_OFFSET  12'd0
    `define X_BITS 'd12
    `define Y_BITS 'd12

`define   PIXS_WIDTH 'd240

`define   MAX_MEM_LOC ('d64800 - 'd1)
