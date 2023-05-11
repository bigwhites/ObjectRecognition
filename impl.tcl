#Generated by Fabric Compiler ( version 2022.1 <build 99559> ) at Tue May  9 19:57:06 2023

add_simulation "F:/PDS_DEMO/ObjectRecognition/source/top.v"
remove_simulation -force "F:/PDS_DEMO/ObjectRecognition/source/top.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/top.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/axi_ctrl.v"
add_constraint "F:/PDS_DEMO/ObjectRecognition/source/a.fdc"
add_design "F:/PDS_DEMO/ObjectRecognition/source/parameter/p_ddr.v"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
add_design F:/PDS_DEMO/ObjectRecognition/ipcore/DDR_IPC/DDR_IPC.idf
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
add_design "F:/PDS_DEMO/ObjectRecognition/source/axi_rd_ctrl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/axi_wr_ctrl.v"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
synthesize -ads -selected_syn_tool_opt 2 
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module axi_ctrl
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
add_design "F:/PDS_DEMO/ObjectRecognition/source/cnt_once.v"
add_design F:/PDS_DEMO/ObjectRecognition/ipcore/PLL_top/PLL_top.idf
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
remove_design -verilog "F:/PDS_DEMO/ObjectRecognition/source/axi_ctrl.v"
remove_design -verilog "F:/PDS_DEMO/ObjectRecognition/source/axi_rd_ctrl.v"
remove_design -verilog "F:/PDS_DEMO/ObjectRecognition/source/axi_wr_ctrl.v"
remove_design -verilog "F:/PDS_DEMO/ObjectRecognition/source/cnt_once.v"
remove_constraint  -logic -fdc "F:/PDS_DEMO/ObjectRecognition/source/a.fdc"
add_design "F:/PDS_DEMO/ObjectRecognition/source/DDR/axi_ctrl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/DDR/axi_rd_ctrl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/DDR/axi_wr_ctrl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/HDMI/hv_cnt.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/HDMI/iic_dri.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/HDMI/ms7200_ctl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/HDMI/ms7210_ctl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/HDMI/ms72xx_ctl.v"
add_design "F:/PDS_DEMO/ObjectRecognition/source/utils/cnt_once.v"
add_constraint "F:/PDS_DEMO/ObjectRecognition/source/fdc/a.fdc"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
add_design "C:/FILE/ObjectRecognition/source/HDMI/hdmi_out.v"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
add_design C:/FILE/ObjectRecognition/ipcore/PIX_BUFF/PIX_BUFF.idf
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
remove_design -verilog "C:/Users/27703/Desktop/debug/ObjectRecognition/source/HDMI/hdmi_out.v"
add_design "C:/Users/27703/Desktop/debug/ObjectRecognition/source/hdmi_out.v"
remove_design -verilog "C:/Users/27703/Desktop/debug/ObjectRecognition/source/hdmi_out.v"
add_design "C:/Users/27703/Desktop/debug/ObjectRecognition/source/HDMI/hdmi_out.v"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
add_design "C:/Users/27703/Desktop/debug/ObjectRecognition/source/HDMI/hdmi_in.v"
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module top
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
