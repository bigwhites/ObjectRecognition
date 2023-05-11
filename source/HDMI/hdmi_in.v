`include "source/parameter/p_ddr.v"

module hdmi_in(
    input rstn ,
    input ini_done ,

    //ddr写接口
    input ddr_clk,
    input wr_busy ,
    input wr_done ,
    output reg wr_req ,
    output reg [4-1:0] awlen ,
    output reg [`CTRL_ADDR_WIDTH-1:0] ddr_waddr,
    output reg [`MEM_DQ_WIDTH*8-1:0] ddr_wdata,

    //hdmi输入
    input pix_clk,
    input [8-1:0] r_in,
    input [8-1:0] g_in,
    input [8-1:0] b_in,
    input de_in ,
    input vs_in ,
    input hs_in
  );

  reg wr_en = 1'b0 ;
  reg rd_en = 1'b0 ;
  reg [`PIXS_WIDTH-1 : 0] fifo_wdata ;
  wire [`PIXS_WIDTH-1 : 0] fifo_rdata ;
  wire rd_empty;
  wire wr_full;
  wire almost_empty;
  wire almost_full;


  //视频读入数据
  reg [`PIXS_WIDTH-1 : 0] buff0 = 240'b0;
  reg [`PIXS_WIDTH-1 : 0] buff1 = 240'b0;

 reg sel_hdmi_in  = 1'b0 ; //



  PIX_BUFF buff_fifo (
             .wr_clk(pix_clk),                // input
             .wr_rst(!rstn),                // input
             .wr_en(wr_en),                  // input
             .wr_data(fifo_wdata),              // input [239:0]
             .wr_full(wr_full),              // output
             .almost_full(almost_full),      // output

             .rd_clk(ddr_clk),                // input
             .rd_rst(!rstn),                // input
             .rd_en(rd_en),                  // input
             .rd_data(fifo_rdata),              // output [239:0]
             .rd_empty(rd_empty),            // output
             .almost_empty(almost_empty)     // output
           );
endmodule
