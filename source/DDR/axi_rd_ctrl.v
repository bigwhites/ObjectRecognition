`include "source/parameter/p_ddr.v"

module axi_rd_ctrl(
    input  clk_100M ,
    input  rstn,
    input init_done ,

    //用户端接口
    input rd_req ,
    input [`CTRL_ADDR_WIDTH-1:0] rd_addr,
    input [3:0] arlen ,
    output reg rd_busy = 1'b0,
    output reg [`MEM_DQ_WIDTH*8-1:0] rd_data,
    output reg  rdata_valid  = 1'b0,   //读数据完成的信号

    //axi端接口
    output reg  [3:0] axi_arlen,
    output reg [`CTRL_ADDR_WIDTH-1:0] axi_araddr,
    output reg axi_arvalid,
    input [`MEM_DQ_WIDTH*8-1:0] axi_rdata ,
    input axi_arready,
    input axi_rvalid,  //读数据有效
    input axi_rlast
  );

  //状态机   IDLE空闲  SHAKE握手  READ读数据
  localparam STATE_CNT  =  3 ;
  localparam IDLE = 3'b001 ;
  localparam SHAKE = 3'b010 ;
  localparam READ = 3'b100 ;
  reg [STATE_CNT - 1 : 0] cur_state;
  reg [STATE_CNT - 1 : 0] next_state;

  reg rd_req_d=1'b0;
  wire rd_req_rise;
  reg rd_req_rise_d=1'b0;
  wire addr_shake = axi_arvalid & axi_arready ;


  assign rd_req_rise = ~rd_req_d & rd_req;

  always @(posedge clk_100M ) begin
    if(!rstn) begin
      cur_state <= IDLE;
    end
    else begin
      cur_state <= next_state;
    end
  end

  always @(posedge clk_100M ) begin
    begin
      rd_req_d <= rd_req;
      rd_req_rise_d <= rd_req_rise;
    end
  end


  always@(*) begin
    case(cur_state)

      IDLE : begin
        if(init_done & rd_req_rise_d)  //初始化完成并且req上升沿时转换到 握手状态
        begin
          next_state = SHAKE;
        end
        else begin
          next_state = IDLE ;
        end
      end

      SHAKE : begin
        if(addr_shake) begin
          next_state = READ ;
        end
        else begin
          next_state = SHAKE;
        end
      end

      READ : begin
        if(axi_rvalid) begin
          next_state = IDLE ;
        end
        else begin
          next_state = READ;
        end
      end

      default : begin
        next_state = IDLE ;
      end

    endcase
  end

  ///////////////////////第三段状态机/////////////////
  always @(posedge clk_100M ) begin
    if(!rstn | cur_state == IDLE) begin
      rd_busy <= 1'b0;
    end
    else if(rd_req_rise) begin
      rd_busy <= 1'b1;
    end
    else begin
      rd_busy <= rd_busy;
    end
  end

  //地址有效信号
  always @(posedge clk_100M ) begin
    if(!rstn) begin
      axi_arvalid <= 1'b0;
    end
    else if(addr_shake) begin
      axi_arvalid <= 1'b0;
    end
    else if(cur_state == SHAKE) begin
      axi_arvalid <= 1'b1;
    end
    else begin
      axi_arvalid <= axi_arvalid;
    end
  end

  always @(posedge clk_100M ) begin
    if(!rstn) begin
      axi_arlen <= 4'b0;
      axi_araddr <= 28'b0;
    end
    else if(rd_req_rise)  //收到上升沿开始寄存数据 延迟一拍跳转
    begin
      axi_arlen <= arlen;
      axi_araddr <= rd_addr;
    end
    else begin
      axi_arlen <= axi_arlen;
      axi_araddr <= axi_araddr;
    end
  end

  always @(posedge clk_100M ) begin
    if(!rstn) begin
      rd_data <= 256'b0;
    end
    else if(axi_rvalid) begin
      rd_data <= axi_rdata;
    end
    else begin
      rd_data <= rd_data;
    end
  end

  always @(posedge clk_100M ) begin
    if(!rstn) begin
      rdata_valid <= 1'b0;
    end
    else if(cur_state == SHAKE) begin
      rdata_valid <= 1'b0;
    end
    else if(axi_rvalid) begin
      rdata_valid <= 1'b1;
    end
    else begin
      rdata_valid <= rdata_valid ;
    end
  end

endmodule
