`include "source/parameter/p_ddr.v"
module axi_wr_ctrl(
    input  clk_100M ,
    input  rstn,
    input init_done ,

    //用户端接口
    input wr_req ,
    input [`CTRL_ADDR_WIDTH-1:0] wr_addr,
    input  [4-1:0] awlen,
    output wire wr_done  ,
    output reg wr_busy = 1'b0,
    input [`MEM_DQ_WIDTH*8-1:0] wr_data,

    //axi端接口
    output reg  [3:0] axi_awlen,
    output reg [`CTRL_ADDR_WIDTH-1:0] axi_awaddr,
    output reg axi_awvalid,
    output reg [`MEM_DQ_WIDTH*8-1:0] axi_wdata ,
    output wire [`MEM_DQ_WIDTH*8/8-1:0]   axi_wstrb,
    input axi_awready,//写地址准备
    input axi_wready, //写数据准备
    output reg axi_wusero_last //写结束信号
  );

  localparam STATE_CNT  =  3 ;
  localparam IDLE = 'd001 ;
  localparam SHAKE = 3'b010 ;
  localparam WRITE = 3'b100 ;
  reg [STATE_CNT - 1 : 0] cur_state;
  reg [STATE_CNT - 1 : 0] next_state;


  wire addr_shake = axi_awready & axi_awvalid ;
  reg wr_req_d = 1'b0;
  wire wr_req_rise;
  reg wr_req_rise_d  = 1'b0;
  reg wr_busy_d = 1'b0;
  wire wr_busy_fail = wr_busy_d & ~wr_busy;
  assign wr_done = wr_busy_fail;

  assign wr_req_rise = ~wr_req_d & wr_req;
  assign axi_wstrb = 32'hffff_ffff;

  //delay
  always@(posedge clk_100M)
  begin
    wr_req_d <= wr_req;
    wr_req_rise_d <= wr_req_rise;
    wr_busy_d <= wr_busy;
  end

  always @(posedge clk_100M )
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

  always@(*)
  begin
    case(cur_state)

      IDLE :
      begin
        if(init_done & wr_req_rise_d)  //初始化完成并且req上升沿时转换到 握手状态
        begin
          next_state = SHAKE;
        end
        else
        begin
          next_state = IDLE ;
        end
      end

      SHAKE :
      begin
        if(addr_shake)
        begin
          next_state = WRITE ;
        end
        else
        begin
          next_state = SHAKE;
        end
      end

      WRITE :
      begin
        if(axi_wready)
        begin
          next_state = IDLE ;
        end
        else
        begin
          next_state = WRITE;
        end
      end

      default :
      begin
        next_state = IDLE ;
      end
    endcase
  end


  ///////////////////////第三段状态机/////////////////


  always @(posedge clk_100M )
  begin
    if(!rstn)
    begin
      axi_wusero_last <= 'b0;
    end
    else if(axi_wready)
    begin
      axi_wusero_last <= 'b1;
    end
    else
    begin
      axi_wusero_last <= 'b0;
    end
  end

  always @(posedge clk_100M )
  begin
    if(!rstn | cur_state == IDLE)
    begin
      wr_busy <= 1'b0;
    end
    else if(wr_req_rise)
    begin
      wr_busy <= 1'b1;
    end
    else
    begin
      wr_busy <= wr_busy;
    end
  end

  always @(posedge clk_100M )
  begin
    if(!rstn)
    begin
      axi_awvalid <= 1'b0;
    end
    else if(addr_shake)
    begin
      axi_awvalid <= 1'b0;
    end
    else if(cur_state == SHAKE)
    begin
      axi_awvalid <= 1'b1;
    end
    else
    begin
      axi_awvalid <= axi_awvalid;
    end
  end


  always @(posedge clk_100M )
  begin
    if(!rstn)
    begin
      axi_wdata <= 256'b0;
      axi_awlen <= 4'b0;
      axi_awaddr <= 28'b0;
    end
    else if(wr_req_rise) //接受数据
    begin
      axi_wdata <= wr_data;
      axi_awlen <= awlen ;
      axi_awaddr <= wr_addr;
    end
    else
    begin
      axi_wdata <= axi_wdata;
      axi_awlen <= axi_awlen ;
      axi_awaddr<= axi_awaddr;
    end
  end


endmodule
