clear -all
check_sec -setup \
	-spec_top sanduba \
	-spec_analyze_opts { -vhdl ../rtl/v1/sanduba.vhd } \
	-spec_elaborate_opts { -vhdl } \
	-imp_top sanduba \
	-imp_analyze_opts { -vhdl ../rtl/v2/sanduiche.vhd } \
	-imp_elaborate_opts { -vhdl } \

#clock and reset setup
clock clock -factor 1 -phase 1
reset -expression {reset = '1'}

#instruct sec to automatically map unitialized registers
check_sec -auto_map_reset_x_values on

#map relevant internal signals for fev
check_sec -map -spec {{EA(2 DOWNTO 0)}} -imp {{sanduiche_ft_imp.EA(2 DOWNTO 0)}}
check_sec -map -spec {{grana(4 DOWNTO 0)}} -imp {{sanduiche_ft_imp.grana(4 DOWNTO 0)}}

#assumptions?

#checking for mapping issues
check_sec -interface

#generate verification environment
check_sec -gen

check_sec -prove
check_sec -signoff

	
	
