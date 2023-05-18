module init_rst(
    input clk_10M,
    input ddr_idone,
    input hdmi_idone,
    input sys_rst_n,
    input pll_lock ,

    output wire init_done ,
    output wire rstn

  );

  wire [24-1 : 0] rst_value;
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

  assign init_done = ddr_idone & hdmi_idone;
  assign rstn = (rst_value == 24'hffffff);
endmodule
