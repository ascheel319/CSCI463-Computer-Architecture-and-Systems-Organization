#Andrew Scheel

# All fields are in hex format
# 
#1 address
#2 uc_addr_mux[2]    next insn addr = uc_next_addr, flags, IR opcode
#3 uc_alu_func[2]    0 = add, 1 = xor, 2 = and, 3 = or
#4 uc_alu_comp_b     1 = compliment b
#5 uc_alu_ci         1 = carry in
#6 uc_alu_flags_clk  1 = clock the flag latch
#7 uc_mar_we         1 = clock a write into MAR
#8 uc_mem_we         1 = clock a write into the RAM
#9 uc_mbr_out_we     1 = clock a write into the MBR_out latch
#A uc_mbr_in_we      1 = clock a write into the MBR_in latch
#B uc_reg_we_clk     1 = clock a write into the register file
#C uc_reg_addr_ir    0 = use reg addr from uc, 1 = use the a field address from IR 
#D uc_reg_addr[3]    the uc destination register address if writing 
#E uc_alu_reg_a_ir   0 = set alu_reg_a mux using the uc address, 1 = use the a field from the IR
#F uc_alu_reg_a[3]   uc address for alu_reg_a
#G uc_alu_reg_b_ir   0 = set alu_reg_b mux using the uc address, 1 = use the b field from the IR
#H uc_alu_reg_b[3]   uc address for alu_reg_b
#I uc_next_addr[16]  uc next instruction

# read a byte from memory and put it into the IR
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
0000 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # do nothing

#############################
# fetch an insn from PC address 
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
0001 0  0 0 0  0 1 0 0 0  0 0 5  0 4 0 7 0002   # put the PC reg value into the MAR
0002 0  0 0 0  0 0 0 0 1  0 0 5  0 4 0 7 0003   # falling edge on uc_mar_we, rising edge on uc_mbr_in_we
0003 0  0 0 0  0 0 0 0 0  0 0 5  0 4 0 7 0004   # falling edge on uc_mbr_in_we
0004 0  0 0 0  0 0 0 0 0  1 0 5  0 7 0 4 0005   # rising edge on uc_reg_we_clk w/ir as target
0005 0  0 0 0  0 0 0 0 0  0 0 5  0 7 0 4 0006   # falling edge on uc_reg_we_clk

# add 1 to PC
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
0006 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 0007   # add 1 to PC & rising edge on uc_reg_we_clk
0007 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 0010   # falling edge on uc_reg_we_clk

#############################
# instruction decode logic
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
0010 2  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 00f0   # branch based on the opcode in the IR!

00f0 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1000   # opcode 0 NOP
00f1 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1100   # opcode 1 LDI Ra,imm
00f2 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1200   # opcode 2 ST Ra,imm
00f3 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1300   # opcode 3 ADD Ra,Rb
00f4 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1400   # opcode 4 SUB Ra,Rb
00f5 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1500   # opcode 5 XOR Ra,Rb
00f6 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1600   # opcode 6 AND Ra,Rb
00f7 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1700   # opcode 7 OR Ra,Rb
00f8 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1800   # opcode 8 MOV Ra,Rb
00f9 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1900   # opcode 9 LD Ra,mem(imm)
00fa 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1a00   # opcode a B imm (absolute)
00fb 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00   # opcode b BR PC+imm
00fc 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c00   # opcode c BZ PC+imm
00fd 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d00   # opcode d BNZ PC+imm
00fe 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 ffff   # opcode e
00ff 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 ffff   # opcode f HALT

#############################
# NOP no operation
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1000 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

#############################
# LDI Ra,imm
# fetch the byte in memory that the PC is pointing to now
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1100 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1101   # MAR <- PC
1101 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1102   #
1102 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1103   # MBR_IN <- d_in
1103 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1104   #
1104 0  0 0 0  0 0 0 0 0  1 1 7  0 7 0 4 1105   # Ra <- MBR_IN
1105 0  0 0 0  0 0 0 0 0  0 1 7  0 7 0 4 1106   #
1106 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1107   # PC <- PC + 1
1107 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1108   # 
1108 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back

#############################
#ST Ra, imm
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1200 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1201   # do nothing
1201 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1202   # MAR <- PC
1201 0  0 0 0  0 0 1 0 0  0 0 7  0 4 0 7 1202   #
1202 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1203   # MBR_IN <- mem
1203 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1204   #
1204 0  0 0 0  0 1 0 0 0  0 0 7  0 7 0 7 1205   # MAR <- MBR_IN
1205 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1206   #
1206 0  0 0 0  0 0 0 1 0  0 0 7  1 7 0 7 1207   # MAR_OUT <- Ra
1207 0  0 0 0  0 0 0 0 0  0 0 7  1 7 0 7 1208   #
1208 0  0 0 0  0 0 1 0 0  0 0 7  0 7 0 7 1209   # mem(MAR) <- MAR_OUT
1209 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1210   #
1210 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1211   # PC <- PC + 1
1211 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1212   #
1212 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back


#############################
#ADD Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1300 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1301   # Do nothing
1301 0  0 0 0  1 0 0 0 0  0 0 0  1 0 1 0 1302   # flags
1302 0  0 0 0  0 0 0 0 0  0 0 0  1 0 1 0 1303   #
1303 0  0 0 0  0 0 0 0 0  1 1 0  1 0 1 0 1304   # ra + rb
1304 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1305   #
1305 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back

#############################
#SUB Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1400 0  0 0 0  0 0 0 0 0  0 0 0  1 0 1 0 1401   # Do nothing
1401 0  0 1 1  0 0 0 0 0  0 0 0  1 0 1 0 1402   #
1402 0  0 1 1  1 0 0 0 0  1 1 0  1 0 1 0 1403   # ra - rb
1403 0  0 1 1  0 0 0 0 0  0 0 0  1 0 1 0 1404   #
1404 0  0 0 0  0 0 0 0 0  0 0 0  1 0 1 0 1405   #FLAGS <- ALU_status
1405 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   #go to insn fetch

#############################
#XOR Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1500 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1501   # Do nothing
1501 0  1 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1502   # Ra <- Ra xor Rb
1502 0  1 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1503   #
1503 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back

#############################
#AND Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1600 0  2 0 0  1 0 0 0 0  0 0 0  0 0 0 0 1601   # Do nothing
1601 0  2 0 0  0 0 0 0 0  1 1 7  1 7 1 7 1602   # Ra <- Ra AND Rb
1602 0  2 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1603   #
1603 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back

#############################
#OR Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1700 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1701   # Do nothing
1701 0  3 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1702   # Ra <- Ra OR Rb
1702 0  0 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1703   #
1703 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back

#############################
#MOV Ra,Rb
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1800 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1801   # Do nothing
1801 0  0 0 0  0 0 0 0 0  1 1 0  0 7 1 0 1802
1802 0  0 0 0  0 0 0 0 0  0 1 0  0 7 1 0 1803
1803 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back


#############################
#LD Ra,mem(imm)
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1900 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1901
1901 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1902   # MAR <- PC
1902 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1903   #
1903 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1904   # MBR_IN <- d_in
1904 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1905   #
1905 0  0 0 0  0 1 0 0 0  0 0 7  0 7 0 7 1906   # MAR <- MBR_IN
1906 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1907   #
1907 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1908   # MBR_IN <- d_in
1908 0  0 0 0  0 0 0 0 0  1 1 7  0 7 0 4 1909   # Ra <- MBR_IN
1909 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1910   # PC <- PC+1
1910 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001

#############################
#B imm
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1a00 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1a01   # Do nothing
1a01 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1a02   # MAR <- PC
1a02 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1a03   #
1a03 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1a04   # MBR_IN <- mem
1a04 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1a05   #
1a05 0  0 0 0  0 0 0 0 1  1 0 4  0 7 0 4 1a06   # PC <- MBR_IN
1a06 0  0 0 0  0 0 0 0 0  0 0 4  0 4 0 7 1a07   #
1a07 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back


#############################
#BR imm
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1b00 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1b01   # Do nothing
1b01 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1b02   # MAR <- PC
1b02 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1b03   #
1b03 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1b04   # MBR_IN <- mem
1b04 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1b05   #
1b05 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1b06   # PC <- PC + 1
1b06 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1b07   #
1b07 0  0 0 0  0 0 0 0 0  1 0 4  0 4 0 4 1b08   # PC <- PC + MBR_IN
1b08 0  0 0 0  0 0 0 0 0  0 0 4  0 4 0 4 1b09   #
1b09 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # Go back


#############################
#BZ PC + imm
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1c00 1  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1c10 # Turn on the decorder thing
1c10 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1c20 #
1c11 0  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1c20 #
1c12 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c13 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c14 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c15 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c16 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c17 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c18 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c19 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c1a 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c1b 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c1c 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c1d 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #Z
1c1e 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #
1c1f 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c20 #

1c20 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1c21 # PC + 1
1c21 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001 # Go back


#############################
#BNZ PC + imm
# 1  2  3 4 5  6 7 8 9 A  B C D  E F G H I
1d00 1  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d10 # Turn on the decoder thing
1d10 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d11 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d12 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d13 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d14 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d15 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d16 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d17 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d18 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d19 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d1a 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d1b 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d1c 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d1d 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d20 #Z
1d1e 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #
1d1f 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00 #

1d20 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1d21 # PC + 1
1d21 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001 # Go back
