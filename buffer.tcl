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
clock clock -factor 1 -phase 1
reset -expression {reset = '1'}

#instruct sec to automatically map unitialized registers
check_sec -auto_map_reset_x_values on

#map relevant internal signals for fev (commented out due 
#to the tool does it automatically)
#check_sec -map -spec {{Hermes_buffer_spec.credit_o}} -imp {{Hermes_buffer_imp.credit_o}}
#check_sec -map -spec {{Hermes_buffer_spec.h}} -imp {{Hermes_buffer_imp.h}}
#check_sec -map -spec {{Hermes_buffer_spec.data}} -imp {{Hermes_buffer_imp.data}}
#check_sec -map -spec {{Hermes_buffer_spec.data_av}} -imp {{Hermes_buffer_imp.data_av}}

#assumptions?

#update sec
check_sec -generate_verification

#checking for mapping issues
check_sec -interface

#generate verification environment
#check_sec -gen

check_sec -prove
check_sec -signoff

	
	
