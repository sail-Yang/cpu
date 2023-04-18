onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/pc_reg0/pc
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_data_i
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_data_i
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/id0/ex_wd_i
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/id0/mem_wd_i
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_read_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_read_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_addr_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_addr_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_o
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/id0/wd_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/we
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/regfile1/waddr
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/wdata
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/re1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/raddr1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/rdata1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/re2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/raddr2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/rdata2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/reg1_i
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/reg2_i
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/wd_i
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/ex0/wd_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/reg2_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/shiftres
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/mem0/wd_i
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/mem0/reg2_i
add wave -noupdate -color Gold /mips_sopc_tb/mips_sopc0/mips0/mem0/wd_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {290000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 342
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {208961 ps} {369915 ps}
