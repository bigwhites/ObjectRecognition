`include "source/parameter/p_ddr.v"
module axi_ctrl(
    input  sys_clk,
    input rstn,
    output wire ddr_clk_100M ,
    output  wire ddr_init_done ,

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

    //用户端
    input rd_req                         ,
    input [`CTRL_ADDR_WIDTH-1:0]rd_addr  ,
    input [3:0]arlen                     ,
    output rd_busy                       ,
    output [`MEM_DQ_WIDTH*8-1:0] rd_data   ,
    output rdata_valid                   ,

    input wr_req                         ,
    input [`CTRL_ADDR_WIDTH-1:0]wr_addr  ,
    input [`MEM_DQ_WIDTH*8-1:0] wr_data  ,
    input [3:0]awlen                     ,
    output wire      wr_done             ,
    output wire      wr_busy
  );


  wire                              clk;
  wire [`CTRL_ADDR_WIDTH-1:0]       axi_awaddr                ;
  wire                             axi_awuser_ap             ;
  wire                             axi_wusero_last           ;
  wire [3:0]                       axi_awuser_id             ;
  wire [3:0]                       axi_awlen                 ;
  wire                             axi_awready               ;
  wire                             axi_awvalid               ;
  wire [`MEM_DQ_WIDTH*8-1:0]        axi_wdata                 ;
  wire [`MEM_DQ_WIDTH*8/8-1:0]      axi_wstrb                 ;   //写数据strobes ==》数据有效信号（write data strobe）标志哪些信号有效
  wire                             axi_wready                ;
  wire [`CTRL_ADDR_WIDTH-1:0]       axi_araddr                ;
  wire                             axi_aruser_ap             ;
  wire [3:0]                       axi_aruser_id             ;
  wire [3:0]                       axi_arlen                 ;
  wire                             axi_arready               ;
  wire                             axi_arvalid               ;
  wire [`MEM_DQ_WIDTH*8-1:0]        axi_rdata                ;
  wire                             axi_rvalid                ;
  wire                             axi_rlast                 ;

  assign ddr_clk_100M = clk;


  //读模块控制
  axi_rd_ctrl axi_rdctrl_inst
              (
                ////////////////用户端//////////////
                // input
                .clk_100M(ddr_clk_100M),
                .rstn(rstn),

                .init_done(ddr_init_done),
                .rd_req(rd_req),
                .rd_addr(rd_addr),
                .arlen(arlen),

                // output
                .rd_busy(rd_busy),
                .rd_data(rd_data),
                .rdata_valid(rdata_valid),


                /////////////////axi端////////////////
                //output
                .axi_arlen(axi_arlen),
                .axi_araddr(axi_araddr),
                .axi_arvalid(axi_arvalid),


                //input
                .axi_rdata(axi_rdata),
                .axi_arready(axi_arready),
                .axi_rvalid(axi_rvalid),
                .axi_rlast(axi_rlast)
              );

  axi_wr_ctrl axi_wr_ctrl_inst
              (
                ////////////////用户端//////////////
                .clk_100M (clk),  //100MHZ
                .rstn(rstn),
                .init_done(ddr_init_done),

                .wr_req (wr_req),
                .wr_addr(wr_addr),
                .awlen(awlen),
                .wr_done (wr_done),
                .wr_busy (wr_busy),
                .wr_data(wr_data),

                /////////////////axi端////////////////
                .axi_awlen(axi_awlen),
                .axi_awaddr(axi_awaddr),
                .axi_awvalid(axi_awvalid),
                .axi_wdata (axi_wdata),
                .axi_wstrb (axi_wstrb),
                .axi_awready(axi_awready),
                .axi_wready(axi_wready), //写数据准备
                .axi_wusero_last(axi_wusero_last) //写结束信号
              );

  /////  DDR IP 核例化
  DDR_IPC  #
    (
      //***************************************************************************
      // The following parameters are Memory Feature
      //***************************************************************************
      .MEM_ROW_WIDTH          (`MEM_ROW_ADDR_WIDTH),
      .MEM_COLUMN_WIDTH       (`MEM_COL_ADDR_WIDTH),
      .MEM_BANK_WIDTH         (`MEM_BADDR_WIDTH   ),
      .MEM_DQ_WIDTH           (`MEM_DQ_WIDTH      ),
      .MEM_DM_WIDTH           (`MEM_DM_WIDTH      ),
      .MEM_DQS_WIDTH          (`MEM_DQS_WIDTH     ),
      .CTRL_ADDR_WIDTH        (`CTRL_ADDR_WIDTH   )
    )
    HMIC_S_inst(
      .ref_clk                (sys_clk                ),
      .resetn                 (rstn         ),
      .ddr_init_done          (ddr_init_done          ),  //out ddr初始化完成
      .ddrphy_clkin           (clk             ),   //100Mhz
      .pll_lock               (pll_lock_ddr               ),


      .axi_awaddr             (axi_awaddr             ),
      .axi_awuser_ap          (axi_awuser_ap          ),
      .axi_awuser_id          (axi_awuser_id          ),
      .axi_awlen              (axi_awlen              ),   //4'b0
      .axi_awready            (axi_awready            ), //写地址准备
      .axi_awvalid            (axi_awvalid            ),  //写地址有效  (输入)

      .axi_wdata              (axi_wdata              ),
      .axi_wstrb              (axi_wstrb              ),
      .axi_wready             (axi_wready             ),   //写准备信号
      //.axi_wusero_id          (                       ),
      .axi_wusero_last        (    axi_wusero_last    ),

      .axi_araddr             (axi_araddr             ),
      .axi_aruser_ap          (axi_aruser_ap          ),
      .axi_aruser_id          (axi_aruser_id          ),
      .axi_arlen              (axi_arlen              ),  //4'b0
      .axi_arready            (axi_arready            ), //读地址准备  （输出）
      .axi_arvalid            (axi_arvalid            ), //读地址有效  axi_read_adress_valid  (输入)

      .axi_rdata              (axi_rdata              ),
      //.axi_rid                (                     ),
      .axi_rlast              (axi_rlast              ),
      .axi_rvalid             (axi_rvalid             ),   //读数据准备（输出）

      //////////apb
      /*
         可使 DDR3 SDRAM
      在 Power Down、Self-Refresh、MRS 和 Normal 各状态间互相切换。通过读取对应的寄
      存器，可以查询 DDR3 当前状态。
      */
      .apb_clk                (1'b0                   ),
      .apb_rst_n              (1'b0                   ),
      .apb_sel                (1'b0                   ),
      .apb_enable             (1'b0                   ),
      .apb_addr               (8'd0                   ),
      .apb_write              (1'b0                   ),
      .apb_ready              (                       ),
      .apb_wdata              (16'd0                  ),
      .apb_rdata              (                       ),
      .apb_int                (                       ),
      /////////////////////////////////////

      .ck_dly_set_bin         (ck_dly_set_bin         ),
      .force_ck_dly_en        (1'b0       ),
      .force_ck_dly_set_bin   (8'h05  ),
      //.dll_step               (dll_step               ),
      //.dll_lock               (dll_lock               ),
      .init_read_clk_ctrl     (2'b0     ),
      .init_slip_step         (4'b0        ),
      .force_read_clk_ctrl    (1'b0    ),
      .ddrphy_gate_update_en  (1'b0  ),
      //.update_com_val_err_flag (update_com_val_err_flag),
      .rd_fake_stop           (1'b0         ),

      //////////////////////////////mem接口////////////////////////
      .mem_rst_n              (mem_rst_n              ),
      .mem_ck                 (mem_ck                 ),
      .mem_ck_n               (mem_ck_n               ),
      .mem_cke                (mem_cke                ),

      .mem_cs_n               (mem_cs_n               ),

      .mem_ras_n              (mem_ras_n              ),
      .mem_cas_n              (mem_cas_n              ),
      .mem_we_n               (mem_we_n               ),
      .mem_odt                (mem_odt                ),
      .mem_a                  (mem_a                  ),
      .mem_ba                 (mem_ba                 ),
      .mem_dqs                (mem_dqs                ),
      .mem_dqs_n              (mem_dqs_n              ),
      .mem_dq                 (mem_dq                 ),
      .mem_dm                 (mem_dm                 )
      /////////////////////////////////////////////////
    );

endmodule
