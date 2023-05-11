module cnt_once
  #(
     parameter  N  =  8 ,
     parameter MAX =  8'hff ,
     parameter MIN =  8'b0
   )(
     input  clk ,
     input  rstn ,
     input  en   ,
     output reg [N-1 : 0 ] cnt = MIN
   );

  always @(posedge clk )
  begin
    if(!rstn)
    begin
      cnt <= MIN;
    end

    else if(en)
    begin
      if(cnt == MAX)
      begin
        cnt <= cnt ;
      end
      else
      begin
        cnt <= cnt + 1'b1;
      end
    end

    else
    begin
      cnt <= MIN;
    end
  end
endmodule
