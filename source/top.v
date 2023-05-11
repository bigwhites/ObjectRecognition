`include "parameter/p_ddr.v"

module top(
    input sys_clk,
    input sys_rst_n,
    output init_done ,
    //mem 通道
    output                                 mem_rst_n       ,
    output                                 mem_ck          ,
    output                                 mem_ck_n        ,
    output                                 mem_cke         ,
    output                                 mem_cs_n        ,
    output                                 mem_ras_n       ,
    output                                 mem_cas_n       ,
    output                                 mem_we_n        ,
    output                                 mem_odt         ,
    output     [`MEM_ROW_ADDR_WIDTH-1:0]    mem_a           ,
    output     [`MEM_BADDR_WIDTH-1:0]       mem_ba          ,
    inout      [`MEM_DQS_WIDTH-1:0]         mem_dqs         ,
    inout      [`MEM_DQS_WIDTH-1:0]         mem_dqs_n       ,
    inout      [`MEM_DQ_WIDTH-1:0]          mem_dq          ,
    output     [`MEM_DM_WIDTH-1:0]          mem_dm          ,

    //HDMI out
    output            iic_tx_scl,
    inout             iic_tx_sda ,
    output            pixclk_out,
    output            vs_out,
    output            hs_out,
    output            de_out,
    output     [8-1:0]  r_out,
    output     [8-1:0]  g_out,
    output     [8-1:0]  b_out,

    //HDMI in
    output            iic_scl,
    inout             iic_sda,
    input             pixclk_in,
    input             vs_in,
    input             hs_in,
    input             de_in,
    input     [7:0]   r_in,
    input     [7:0]   g_in,
    input     [7:0]   b_in,


    //debug
    output wire [4-1:0] led
  );


  wire rd_req ;
  wire  [`CTRL_ADDR_WIDTH-1:0]  rd_addr ;
  wire [4-1:0] arlen ;
  wire rd_busy ;
  wire [`MEM_DQ_WIDTH*8-1:0] rd_data;
  wire rdata_valid ;
  wire ddr_init_done;
  wire rstn ;
  wire clk_10M ;
  wire [24-1 : 0] rst_value ;

  reg wr_req                         ;
  reg [`CTRL_ADDR_WIDTH-1:0]wr_addr  ;
  reg [`MEM_DQ_WIDTH*8-1:0] wr_data  ;
  reg [4-1:0]awlen        = 4'b0             ;
  wire      wr_done             ;
  wire      wr_busy             ;
  wire      ddr_clk_100M        ;
  wire _72xx_init_done ;

  assign  init_done = ddr_init_done & _72xx_init_done;

  assign  led = {wr_busy,rd_busy,rd_req,wr_req};

  cnt_once#(
            .N(24),
            .MIN(0),
            .MAX(24'hffffff)
          )cnt_rst(
            .clk(clk_10M),
            .rstn(sys_rst_n),
            .en(pll_lock),
            .cnt(rst_value)
          );

  assign rstn = (rst_value == 24'hffffff);


  ms72xx_ctl ms72xx_ctl(   //hdmi 转换芯片配置
               .clk         (  clk_10M    ), //input       clk,
               .rst_n       (  rstn   ), //input       rstn,

               .init_over   ( _72xx_init_done  ), //output      init_over,
               .iic_tx_scl  (  iic_tx_scl ), //output      iic_scl,
               .iic_tx_sda  (  iic_tx_sda ), //inout       iic_sda
               .iic_scl     (  iic_scl    ), //output      iic_scl,
               .iic_sda     (  iic_sda    )  //inout       iic_sda
             );

  hdmi_out hdmi_out_inst(
             //.led(led),
             .pix_clk(pixclk_out),
             .ddr_clk(ddr_clk_100M),
             .rstn(rstn),
             .init_done(init_done),

             .rd_req (rd_req),
             .ddr_rd_adr(rd_addr),
             .arlen(arlen),
             .ddr_rdata(rd_data),
             .rdata_valid(rdata_valid),
             .ddr_rbusy(rd_busy),
             .r_out(r_out),
             .g_out(g_out),
             .b_out(b_out),
             .de_out(de_out),
             .vs_out(vs_out),
             .hs_out(hs_out)
           );

  hdmi_in hdmi_in_inst(
            .rstn(rstn),
            .ini_done(init_done),

            //ddr写接口
            .ddr_clk(ddr_clk_100M),
            .wr_busy(wr_busy),
            .wr_done(wr_done),
            .wr_req(),
            .awlen(),
            .ddr_waddr(),
            .ddr_wdata(),

            //hdmi输入
            .pix_clk(pixclk_in),
            .r_in(r_in),
            .g_in(g_in),
            .b_in(b_in),
            .de_in(de_in),
            .vs_in(vs_in),
            .hs_in(hs_in)
          );

  axi_ctrl axi_ctrl_inst(
             .sys_clk(sys_clk),
             .ddr_clk_100M(ddr_clk_100M),
             .rstn(rstn),
             .ddr_init_done(ddr_init_done),

             //mem 通道
             .mem_rst_n(mem_rst_n),
             .mem_ck(mem_ck),
             .mem_ck_n(mem_ck_n),
             .mem_cke(mem_cke),
             .mem_cs_n(mem_cs_n ),
             .mem_ras_n(mem_ras_n),
             .mem_cas_n(mem_cas_n),
             .mem_we_n(mem_we_n),
             .mem_odt(mem_odt),
             .mem_a(mem_a),
             .mem_ba(mem_ba),
             .mem_dqs(mem_dqs),
             .mem_dqs_n(mem_dqs_n),
             .mem_dq(mem_dq),
             .mem_dm(mem_dm),

             //读
             .rd_req(rd_req),
             .rd_addr(rd_addr),
             .arlen(arlen),
             .rd_busy(rd_busy),
             .rd_data(rd_data),
             .rdata_valid(rdata_valid),

             //写
             .wr_req(wr_req),
             .wr_addr(wr_addr),
             .wr_data(wr_data),
             .awlen(awlen),
             .wr_done(wr_done),
             .wr_busy(wr_busy)
           );

  PLL_top pll_top_inst (
            .clkin1(sys_clk),        // input 50M
            .pll_lock(pll_lock),    // output
            .clkout0(clk_10M),      // output 10M
            .clkout1(pixclk_out)       // output 148.5M
          );

  //assign pixclk_out = pixclk_in;


  reg wr_busy_d = 1'b0;
  always @(posedge ddr_clk_100M )
  begin
    wr_busy_d <= wr_busy;
  end
  always @(posedge ddr_clk_100M )
  begin
    if(!rstn | !init_done)
    begin
      wr_req <= 'b0;
      wr_data <= 'h0000_144475_144475_144475_144475_144475_144475_144475_144475_144475_144475;
    end
    else if(!wr_busy_d)
    begin
      wr_data <= 'h0000_144475_144475_144475_144475_144475_144475_144475_144475_144475_144475;
      wr_req <= 1'b1;
    end
    else
    begin
      wr_data <= wr_data;
      wr_req <= 1'b0;
    end
  end


  always @(posedge ddr_clk_100M )
  begin
    if(!rstn)
    begin
      wr_addr <=28'b0;
    end
    else if(wr_done)
    begin
      if(wr_addr == `MAX_MEM_LOC)
      begin
        wr_addr <= 28'b0;
      end
      else
      begin
        wr_addr <= wr_addr + 'd32;
      end
    end
    else
    begin
      wr_addr <= wr_addr;
    end
  end
endmodule
