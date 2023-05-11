`include "source/parameter/p_ddr.v"


module hdmi_out(
    input pix_clk,
    input ddr_clk,
    input rstn,
    input init_done,
    output wire [4-1:0] led,
    output reg rd_req = 1'b0,
    output reg [`CTRL_ADDR_WIDTH-1:0] ddr_rd_adr = 'b0,
    output reg [4-1:0] arlen ='b0 ,
    input  [`MEM_DQ_WIDTH*8-1:0] ddr_rdata,
    input rdata_valid ,
    input ddr_rbusy ,

    output reg [8-1 : 0]  r_out ,
    output reg [8-1 : 0]  g_out ,
    output reg [8-1 : 0]  b_out ,
    output                de_out,
    output                vs_out,
    output                hs_out

  );

  localparam STATE_CNT = 3;
  localparam IDLE    = 'b001;
  localparam DDR_RD  = 'b010;
  localparam FIFO_WR =  'b100;
  reg [STATE_CNT-1 : 0] cur_state;
  reg [STATE_CNT-1 : 0] next_state ;

  assign  led = {cur_state , rd_req};

  wire [`X_BITS-1:0] x_act ;
  wire [`Y_BITS-1:0] y_act ;
  reg wr_en ;
  reg rd_en ;
  wire almost_empty;
  wire almost_full;
  wire [`PIXS_WIDTH-1 : 0] fifo_rdata;
  reg [`PIXS_WIDTH-1 : 0] fifo_wdata ;

  reg  [`PIXS_WIDTH-1 : 0] buff0;
  reg  [`PIXS_WIDTH-1 : 0] buff1;
  reg sel_r  = 1'b0 ;//读出并交给hdmi接口 (写入到buff中的控制信号)
  wire sel_w;
  reg [4-1:0] pix_cnt = 4'b0;

  assign sel_w = ~sel_r;

  wire [3-1:0] f_wr_cnt;
  wire wr_full;

  always @(*)
  begin
    case(cur_state)
      IDLE:
      begin
        if(!init_done)
        begin
          next_state = IDLE;
        end
        else if(~ddr_rbusy & ~wr_full)
        begin
          next_state = DDR_RD;
        end
        else
        begin
          next_state = IDLE;
        end
      end

      DDR_RD:
      begin
        if(rd_req & rdata_valid)
        begin
          next_state = FIFO_WR;
        end
        else
        begin
          next_state = DDR_RD;
        end
      end

      FIFO_WR :
      begin
        if(f_wr_cnt >= 'd4)
        begin
          next_state = IDLE;
        end
        else
        begin
          next_state = FIFO_WR;
        end
      end

      default :
      begin
        next_state = IDLE;
      end
    endcase
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      //fifo_wdata <= 240'h12f4_12f4_12f4_12f4_12f4_12f4_12f4_1234_1234_1234_1234_1234_1234_1234_1234;
      fifo_wdata <= 240'b0;
    end
    else if(f_wr_cnt == 'd1)
    begin
      //fifo_wdata <= 240'h12f4_12f4_12f4_12f4_12f4_12f4_12f4_1234_1234_1234_1234_1234_1234_1234_1234;
      fifo_wdata <= ddr_rdata[239:0];
      //fifo_wdata <= 240'h102c_2c3c_cccc_cccc_fcfc_0000_0000_cc0c_cccc_cccc_cccc_cccc_cccc_c00c_1cc0;
    end
    else
    begin
      fifo_wdata <= fifo_wdata;
    end
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      wr_en <= 1'b0;
    end
    else if(f_wr_cnt == 'd2)
    begin
      wr_en <= 1'b1;
    end
    else
    begin
      wr_en <= 1'b0;
    end
  end

  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      rd_req <= 1'b0;
    end
    else if(cur_state == DDR_RD)
    begin
      rd_req <= 1'b1;
    end
    else
    begin
      rd_req <= 1'b0;
    end
  end


  always @(posedge ddr_clk )
  begin
    if(!rstn)
    begin
      ddr_rd_adr <= 28'b0;
    end
    else if(f_wr_cnt == 'd1)
    begin
      if(ddr_rd_adr == `MAX_MEM_LOC)
      begin
        ddr_rd_adr <= 28'b0;
      end
      else
      begin
        ddr_rd_adr <= ddr_rd_adr + 'd32;
      end
    end
    else
    begin
      ddr_rd_adr <= ddr_rd_adr;
    end
  end

  assign  en_cnt = cur_state == FIFO_WR ;
  cnt_once#(
            .N(3),
            .MIN(0),
            .MAX('d4)
          )cnt_fifo_wr(
            .clk(ddr_clk),
            .rstn(rstn),
            .en(en_cnt),
            .cnt(f_wr_cnt)
          );

  hv_cnt hv_cnt_inst(
           .clk(pix_clk),
           .rstn(init_done|rstn),
           .vs_out(vs_out),
           .hs_out(hs_out),
           .de_out(de_out),
           .x_act(x_act),
           .y_act(y_act)
         );

  PIX_BUFF buff_fifo (
             .wr_clk(ddr_clk),                // input
             .wr_rst(!rstn),                // input
             .wr_en(wr_en),                  // input
             .wr_data(fifo_wdata),              // input [239:0]
             .wr_full(wr_full),              // output
             .almost_full(almost_full),      // output

             .rd_clk(pix_clk),                // input
             .rd_rst(!rstn | !init_done ),                // input
             .rd_en(rd_en),                  // input
             .rd_data(fifo_rdata),              // output [239:0]
             .rd_empty(rd_empty),            // output
             .almost_empty(almost_empty)     // output
           );

  always @(posedge ddr_clk)
  begin
    if(!rstn)
    begin
      cur_state <= IDLE;
    end
    else
    begin
      cur_state <= next_state;
    end
  end

  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      pix_cnt <= 4'b0;
    end
    else if(de_out)
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

  always@(posedge pix_clk)
  begin
    if(!rstn)
    begin
      rd_en <= 1'b0;
    end
    else if(de_out & pix_cnt == 'd2) //读到第二个像素乒乓读FIFO
    begin
      rd_en <= 1'b1;
    end
    else
    begin
      rd_en <= 1'b0;
    end
  end

  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      buff0 <= 240'b0;
      //buff0 <= 240'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
      buff1 <= 240'b0;
    end
    else if(de_out & pix_cnt == 'd4)
    begin //更新buff
      if(sel_w)
      begin
        buff1 <= fifo_rdata;
        //buff1 <= 240'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
      end
      else if(~sel_w)
      begin
        buff0 <= fifo_rdata;
        //buff0 <= 240'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
      end
      else
      begin
        buff0 <= buff0;
        buff1 <= buff1;
        //buff0 <= 240'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
        //   buff1 <= 240'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
      end
    end
  end
  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      sel_r <= 1'b0;
    end
    else if(de_out & pix_cnt=='d9)
    begin
      sel_r <= ~sel_r;
    end
    else
    begin
      sel_r <= sel_r;
    end

  end

  //显示数据
  wire [`PIXS_WIDTH-1 :0] disp_buff ;
  assign disp_buff = 1 ? buff1 : buff0;

  always @(posedge pix_clk )
  begin
    if(!rstn)
    begin
      {r_out,g_out,b_out} <= 24'b0;
    end
    else if(de_out)
    begin
      case(pix_cnt)
        'd00:
        begin
          {r_out,g_out,b_out} <= disp_buff[239:216] ;
        end
        'd01:
        begin
          {r_out,g_out,b_out} <= disp_buff[215:192] ;
        end
        'd02:
        begin
          {r_out,g_out,b_out} <= disp_buff[191:168] ;
        end
        'd03:
        begin
          {r_out,g_out,b_out} <= disp_buff[167:144] ;
        end
        'd04:
        begin
          {r_out,g_out,b_out} <= disp_buff[143:120] ;
        end
        'd05:
        begin
          {r_out,g_out,b_out} <= disp_buff[119:96] ;
        end
        'd06:
        begin
          {r_out,g_out,b_out} <= disp_buff[95:72] ;
        end
        'd07:
        begin
          {r_out,g_out,b_out} <= disp_buff[71:48] ;
        end
        'd08:
        begin
          {r_out,g_out,b_out} <= disp_buff[47:24] ;
        end
        'd09:
        begin
          {r_out,g_out,b_out} <= disp_buff[23:0] ;
        end
        default :
        begin
          {r_out,g_out,b_out} <= 24'h0;
        end
      endcase
    end
    else
    begin
      {r_out,g_out,b_out} <= 24'h00_fc_0d;
    end
  end

  //显示
  /*
        startLoc 一开始为239 每次-24
       <= disp_buff[startLoc: startLoc - 24 + 1];
       每次让stratLoc -= 24 
  */

endmodule
