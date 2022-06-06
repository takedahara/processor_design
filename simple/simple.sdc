## Generated SDC file "simple.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

## DATE    "Mon Jun 06 13:37:23 2022"

##
## DEVICE  "EP4CE30F23I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {clock}] -setup 0.000  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {clock}] -setup 0.000  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {clock}] -setup 0.000  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {clock}] -setup 0.000  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.000  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.000  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {clock}]  0.000  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {clock}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.000  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.000  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {clock}]  0.000  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {clock}]  0.000  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {clk}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {exec}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[0]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[1]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[2]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[3]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[4]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[5]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[6]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[7]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[8]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[9]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[10]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[11]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[12]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[13]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[14]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {in[15]}]
set_input_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {rst}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out2[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out3[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[16]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[17]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[18]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[19]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[20]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[21]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[22]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[23]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[24]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[25]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[26]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[27]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[28]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[29]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[30]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out4[31]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {out[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {phase[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {phase[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {phase[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[16]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[17]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[18]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[19]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[20]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[21]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[22]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[23]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[24]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[25]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[26]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[27]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[28]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[29]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[30]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out[31]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[0]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[1]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[2]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[3]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[4]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[5]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[6]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[7]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[8]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[9]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[10]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[11]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[12]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[13]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[14]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[15]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[16]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[17]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[18]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[19]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[20]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[21]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[22]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[23]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[24]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[25]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[26]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[27]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[28]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[29]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[30]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_out_2[31]}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_1}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_2}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_3}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_4}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_5}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_6}]
set_output_delay -add_delay  -clock [get_clocks {clock}]  0.000 [get_ports {seg_sel_7}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

