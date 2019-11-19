clear -all

# hdl files must be declared respecting dependence order
check_sec -setup \
	-spec_top Hermes_buffer \
	-spec_analyze_opts { -vhdl rtl/HeMPS_defaults.vhd rtl/Hermes_buffer_spec.vhd } \
	-spec_elaborate_opts { -vhdl } \
	-imp_top Hermes_buffer \
	-imp_analyze_opts { -vhdl rtl/HeMPS_defaults.vhd rtl/Hermes_buffer_imp.vhd } \
	-imp_elaborate_opts { -vhdl } \

#clock and reset setup
clock clock [list {clock_rx} {Hermes_buffer_imp.clock} {Hermes_buffer_imp.clock_rx}] 1 1 -both_edges
reset -expression {reset = '1' and Hermes_buffer_imp.reset = '1'}

#instruct sec to automatically map unitialized registers
check_sec -auto_map_reset_x_values on

#enable additional engines (same as for fpv)
# H is not allowed in conjunction with Ht or Hp
set_engine_mode { Hp Ht Bm J Q3 U L R B N K AB D I AD M AM G C AG G2 C2 Hps Hts Tri QT TM}

#map relevant internal signals for fev (commented out due 
#to the tool does it automatically)
#check_sec -map -spec {{Hermes_buffer_spec.credit_o}} -imp {{Hermes_buffer_imp.credit_o}}
#check_sec -map -spec {{Hermes_buffer_spec.h}} -imp {{Hermes_buffer_imp.h}}
#check_sec -map -spec {{Hermes_buffer_spec.data}} -imp {{Hermes_buffer_imp.data}}
#check_sec -map -spec {{Hermes_buffer_spec.data_av}} -imp {{Hermes_buffer_imp.data_av}}

#reset cannot be used as input signal
#check_sec -map -spec {{Hermes_buffer_spec.reset}} -imp {Hermes_buffer_imp.reset}

#assumptions?

# get designs statistics
get_design_info
sanity_check -verbose -analyze all

#update sec
check_sec -generate_verification

#checking for mapping issues
check_sec -interface

#generate verification environment
#check_sec -gen

check_sec -prove
check_sec -signoff

	
	
