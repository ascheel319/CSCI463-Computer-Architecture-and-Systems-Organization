#Programmer:   Andrew Scheel
#Class:        CSCI 463
#Due Date:     10/15/19
#Professor:    John Winans
#TA:           Chenyi Ni

#alu_func[1:0]
#| alu_comp_b
#| | alu_ci
#| | | reg_we
#| | | | mbr_alu
#| | | | | mar_we
#| | | | | | mem_we
#| | | | | | | mbr_out_we
#| | | | | | | | mbr_in_we
#| | | | | | | | | reg_addr_we[1:0]
#| | | | | | | | | |  alu_reg_a[1:0]
#| | | | | | | | | |  |  alu_reg_b[1:0]
#| | | | | | | | | |  |  |
#| | | | | | | | | |  |  |
#---------------------------
00 0 0 1 0 0 0 0 0 00 00 00 #1turns reg_we on
00 0 0 1 1 0 0 0 1 00 00 00 #2grabs 40 from memory
00 0 0 0 0 0 0 0 0 00 00 00 #3turns reg_we off so it writes to it reg 0

00 0 0 1 0 0 0 0 0 00 00 00 #4
00 0 0 1 1 0 0 0 0 00 00 00 #5
00 0 0 0 0 0 0 0 0 00 00 00 #6

00 0 0 1 0 0 0 0 1 01 00 00 #7grabs 80 from memory
00 0 0 0 0 0 0 0 0 01 00 00 #8puts it in reg 1

#writes to memory

#41
00 0 0 0 0 1 0 0 0 00 01 11 #9
00 0 0 0 0 0 0 0 0 00 01 11 #10

00 0 1 0 0 0 0 1 0 00 00 11 #11adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #12writing to reg0
00 0 1 0 0 0 0 0 0 00 00 11 #13

00 0 0 0 0 0 1 0 0 01 00 11 #14turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #15turns bit off so it writes


#42
00 0 1 0 0 0 0 0 0 01 01 11 #16grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #17
00 0 0 0 0 0 0 0 0 01 01 11 #18writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #19adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #20
00 0 1 0 0 0 0 0 0 00 00 11 #21writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #22turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #23turns bit off so it writes


#43
00 0 1 0 0 0 0 0 0 01 01 11 #24grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #25
00 0 0 0 0 0 0 0 0 01 01 11 #26writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #27adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #28
00 0 1 0 0 0 0 0 0 00 00 11 #29writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #30turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #31turns bit off so it writes


#44
00 0 1 0 0 0 0 0 0 01 01 11 #32grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #33
00 0 0 0 0 0 0 0 0 01 01 11 #34writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #35adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #36
00 0 1 0 0 0 0 0 0 00 00 11 #37writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #38turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #39turns bit off so it writes

#45
00 0 1 0 0 0 0 0 0 01 01 11 #40grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #41
00 0 0 0 0 0 0 0 0 01 01 11 #42writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #43adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #44
00 0 1 0 0 0 0 0 0 00 00 11 #45writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #46turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #47turns bit off so it writes


#46
00 0 1 0 0 0 0 0 0 01 01 11 #48grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #49
00 0 0 0 0 0 0 0 0 01 01 11 #50writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #51adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #52
00 0 1 0 0 0 0 0 0 00 00 11 #53writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #54turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #55turns bit off so it writes


#47
00 0 1 0 0 0 0 0 0 01 01 11 #56grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #57
00 0 0 0 0 0 0 0 0 01 01 11 #58writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #59adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #60
00 0 1 0 0 0 0 0 0 00 00 11 #61writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #62turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #63turns bit off so it writes


#48
00 0 1 0 0 0 0 0 0 01 01 11 #64grabs reg1 and adds 1 to it
00 0 1 1 0 1 0 0 0 01 01 11 #65
00 0 0 0 0 0 0 0 0 01 01 11 #66writes to it

00 0 1 0 0 0 0 1 0 00 00 11 #67adding 1 to reg0
00 0 1 1 0 0 0 0 0 00 00 11 #68
00 0 1 0 0 0 0 0 0 00 00 11 #69writing to reg0

00 0 0 0 0 0 1 0 0 01 00 11 #70turns bit on so it can be turned off to write to the memory
00 0 0 0 0 0 0 0 0 01 00 11 #71turns bit off so it writes
