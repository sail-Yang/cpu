onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/pc_reg0/clk
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/pc_reg0/pc
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/if_id0/id_inst
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_read_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_read_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_addr_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_addr_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/aluop_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/alusel_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg1_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/reg2_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/wd_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/id0/wreg_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/waddr
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/wdata
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/re1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/raddr1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/rdata1
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/re2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/raddr2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/regfile1/rdata2
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/wd_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/wreg_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/wdata_o
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/logicout
add wave -noupdate /mips_sopc_tb/mips_sopc0/mips0/ex0/shiftres
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {202247 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 329
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
WaveRestoreZoom {139136 ps} {459387 ps}
