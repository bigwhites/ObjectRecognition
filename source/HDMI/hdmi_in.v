`include "source/parameter/p_ddr.v"

module hdmi_in(
    input rstn ,
    input init_done ,
    output [4-1:0] debug,

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

  reg sel_hdmi_in  = 1'b0 ; //选择缓存的控制信号

  reg [4-1:0]pix_cnt = 4'b0;


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



  ////////////////////写ddr//////////////////////////////////////

  localparam STATE_CNT = 4 ;
  localparam IDLE = 'b0001;
  localparam FIFO_RD = 'b0010;
  localparam DDR_WR = 'b0100;
  localparam ADR_INC = 'b1000;
  reg [STATE_CNT-1 : 0] cur_state;
  reg [STATE_CNT-1 : 0] next_state;
  wire[3-1:0] cnt_value;

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      cur_state <= IDLE ;
    end
    else
    begin
      cur_state <= next_state;
    end
  end

  always @(*)
  begin
    case(cur_state)
      IDLE :
      begin
        if(init_done & ~rd_empty)
        begin
          next_state = FIFO_RD ;
        end
        else
        begin
          next_state = IDLE;
        end
      end

      FIFO_RD :
      begin
        if(cnt_value == 'd4 & ~wr_busy)
        begin
          next_state = DDR_WR;
        end
        else
        begin
          next_state = FIFO_RD;
        end
      end

      DDR_WR :
      begin
        if(wr_done)
        begin
          next_state = ADR_INC;
        end
        else
        begin
          next_state = DDR_WR;
        end
      end

      ADR_INC :
      begin
        if(cnt_value > 'd3)
        begin
          next_state = IDLE;
        end
        else
        begin
          next_state = ADR_INC;
        end
      end


      default :
      begin
        next_state = IDLE ;
      end

    endcase
  end

  cnt_once#(
            .N(3),
            .MIN(0),
            .MAX('d4)
          )cnt_ddr_wr(
            .clk(ddr_clk),
            .rstn(rstn),
            .en((cur_state==FIFO_RD) || (cur_state == DDR_WR)),
            .cnt(cnt_value)
          );

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      rd_en <= 1'b0;
    end
    else if(cnt_value == 'd1 & cur_state == FIFO_RD)
    begin
      rd_en <= 'b1;
    end
    else
    begin
      rd_en <= 'b0;
    end
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      ddr_wdata <= 'b0;
    end
    else if(cur_state == FIFO_RD)
    begin
      ddr_wdata <= {16'b0,fifo_rdata};
    end
    else
    begin
      ddr_wdata <= 'b0;
    end
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      wr_req <= 'b0;
    end
    else if(cur_state == DDR_WR)
    begin
      wr_req <= 'b1;
    end
    else
    begin
      wr_req <= 'b0;
    end
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      ddr_waddr <= 'b0;
    end
    else if(cur_state==ADR_INC && cnt_value == 'd1 )
    begin
      if(ddr_waddr == `MAX_MEM_LOC)
      begin
        ddr_waddr <= 'b0;
      end
      else
      begin
        ddr_waddr <= ddr_waddr + 'd32;
      end
    end
  end



  /////////////////////读取///////////////////////////////////
  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      pix_cnt <= 4'b0;
    end
    else if(de_in)
    begin
      if(pix_cnt == 'd9)
      begin
        pix_cnt <= 'b0;
      end
      else
      begin
        pix_cnt <= pix_cnt + 1'b1;
      end
    end
    else
    begin
      pix_cnt <= pix_cnt;
    end
  end

  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      sel_hdmi_in <= 1'b0;  //先写入0
    end
    else if(de_in & pix_cnt == 'd9)
    begin
      sel_hdmi_in <= ~sel_hdmi_in;
    end
  end


  //写入FIFO
  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      wr_en <= 1'b0;
    end
    else if(de_in & pix_cnt == 'd2)
    begin
      wr_en <= 'b1;
    end
    else
    begin
      wr_en <= 'b0;
    end
  end

  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      fifo_wdata <= 'b0;
    end
    else if( pix_cnt == 'd1)
    begin
      fifo_wdata <= sel_hdmi_in==1'b1 ?buff0:buff1;
    end
    else
    begin
      fifo_wdata <= fifo_wdata;
    end
  end


  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      buff0 <= 240'b0;
      buff1 <= 240'b0;
    end
    else if(de_in)
    begin
      if(!sel_hdmi_in)
      begin
        case(pix_cnt)
          'd00:
          begin
            buff0[239:216] <= {r_in,g_in,b_in};
          end
          'd01:
          begin
            buff0[215:192] <= {r_in,g_in,b_in};
          end
          'd02:
          begin
            buff0[191:168] <= {r_in,g_in,b_in};
          end
          'd03:
          begin
            buff0[167:144] <= {r_in,g_in,b_in};
          end
          'd04:
          begin
            buff0[143:120] <= {r_in,g_in,b_in};
          end
          'd05:
          begin
            buff0[119:96] <= {r_in,g_in,b_in};
          end
          'd06:
          begin
            buff0[95:72] <= {r_in,g_in,b_in};
          end
          'd07:
          begin
            buff0[71:48] <= {r_in,g_in,b_in};
          end
          'd08:
          begin
            buff0[47:24] <= {r_in,g_in,b_in};
          end
          'd09:
          begin
            buff0[23:0] <= {r_in,g_in,b_in};
          end
        endcase
      end

      else
      begin
        case(pix_cnt)
          'd00:
          begin
            buff1[239:216] <= {r_in,g_in,b_in};
          end
          'd01:
          begin
            buff1[215:192] <= {r_in,g_in,b_in};
          end
          'd02:
          begin
            buff1[191:168] <= {r_in,g_in,b_in};
          end
          'd03:
          begin
            buff1[167:144] <= {r_in,g_in,b_in};
          end
          'd04:
          begin
            buff1[143:120] <= {r_in,g_in,b_in};
          end
          'd05:
          begin
            buff1[119:96] <= {r_in,g_in,b_in};
          end
          'd06:
          begin
            buff1[95:72] <= {r_in,g_in,b_in};
          end
          'd07:
          begin
            buff1[71:48] <= {r_in,g_in,b_in};
          end
          'd08:
          begin
            buff1[47:24] <= {r_in,g_in,b_in};
          end
          'd09:
          begin
            buff1[23:0] <= {r_in,g_in,b_in};
          end
        endcase
      end
    end
    else
    begin
      buff0 <= buff0;
      buff1 <= buff1;
    end
  end

  reg br = 1'b0;
  reg [24-1:0] a;
  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      br <= 'b0;
      a <= 'b0;
    end
    else if(a == 24'hffff_fe)
    begin
      a <= 'b0;
      br <= ~br;
    end
    else
    begin
      a <= a+'b1;
      br <= br;
    end
  end
  assign  debug = {!rd_empty, br, wr_busy ,de_in};
endmodule
