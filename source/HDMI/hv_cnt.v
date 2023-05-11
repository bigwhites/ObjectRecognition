`include "source/parameter/p_ddr.v"
module hv_cnt #
  (

  )(
    input                   clk,
    input                   rstn,
    output reg              vs_out,
    output reg              hs_out,
    output reg              de_out,
    output reg [`X_BITS-1:0] x_act,  //x像素位置
    output reg [`Y_BITS-1:0] y_act  // y像素位置
  );
  //    parameter               HV_OFFSET = 12'd0 ;
  reg [`X_BITS-1:0]        h_count = 'd0;
  reg [`Y_BITS-1:0]        v_count = 'd0;

  /* horizontal counter */
  always @(posedge clk)
  begin
    if (!rstn)
      h_count <=  0;
    else
    begin
      if (h_count < `H_TOTAL - 1)
        h_count <=  h_count + 1;
      else
        h_count <=  0;
    end
  end

  /* vertical counter */
  always @(posedge clk)
  begin
    if (!rstn)
      v_count <=  0;
    else
      if (h_count == `H_TOTAL - 1)
      begin
        if (v_count == `V_TOTAL - 1)
          v_count <=  0;
        else
          v_count <=  v_count + 1;
      end
  end

  always @(posedge clk)
  begin
    if (!rstn)
      hs_out <=  4'b0;
    else
      hs_out <=  ((h_count < `H_SYNC));
  end

  always @(posedge clk)
  begin
    if (!rstn)
      vs_out <=  4'b0;
    else
    begin
      if (v_count == 0)
        vs_out <=  1'b1;
      else if (v_count == `V_SYNC)
        vs_out <=  1'b0;
      else
        vs_out <=  vs_out;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn)
      de_out <=  4'b0;
    else
      de_out <= (((v_count >= `V_SYNC + `V_BP) && (v_count <= `V_TOTAL - `V_FP - 1)) &&
                 ((h_count >= `H_SYNC + `H_BP) && (h_count <= `H_TOTAL - `H_FP - 1)));
  end

  // active pixels counter output
  always @(posedge clk)
  begin
    if (!rstn)
      x_act <=  'd0;
    else
    begin
      /* X coords ¨C for a backend pattern generator */
      if(h_count > (`H_SYNC + `H_BP - 1'b1))
        x_act <=  (h_count - (`H_SYNC + `H_BP));
      else
        x_act <=  'd0;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn)
      y_act <=  'd0;
    else
    begin
      /* Y coords ¨C for a backend pattern generator */
      if(v_count > (`V_SYNC + `V_BP - 1'b1))
        y_act <=  (v_count - (`V_SYNC + `V_BP));
      else
        y_act <=  'd0;
    end
  end

endmodule
