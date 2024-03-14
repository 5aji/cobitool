# LEDs
set_property PACKAGE_PIN D5 [get_ports {leds[0]}]
set_property PACKAGE_PIN D6 [get_ports {leds[1]}]
set_property PACKAGE_PIN A5 [get_ports {leds[2]}]
set_property PACKAGE_PIN B5 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports leds*]

# Switches
set_property PACKAGE_PIN E4 [get_ports {switches[0]}]
set_property PACKAGE_PIN D4 [get_ports {switches[1]}]
set_property PACKAGE_PIN F5 [get_ports {switches[2]}]
set_property PACKAGE_PIN F4 [get_ports {switches[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports switches*]

# FMC
#set_property PACKAGE_PIN A11      [get_ports "FMC_LPC_LA23_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L24N_T3U_N11_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA23_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L24N_T3U_N11_68
#set_property PACKAGE_PIN B11      [get_ports "FMC_LPC_LA23_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L24P_T3U_N10_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA23_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L24P_T3U_N10_68
#set_property PACKAGE_PIN A7       [get_ports "FMC_LPC_LA27_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L23N_T3U_N9_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA27_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L23N_T3U_N9_68
#set_property PACKAGE_PIN A8       [get_ports "FMC_LPC_LA27_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L23P_T3U_N8_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA27_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L23P_T3U_N8_68
set_property PACKAGE_PIN A10      [get_ports "ROSC_EN"] ;# [get_ports "FMC_LPC_LA21_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L22N_T3U_N7_DBC_AD0N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "ROSC_EN"] ;# [get_ports "FMC_LPC_LA21_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L22N_T3U_N7_DBC_AD0N_68
set_property PACKAGE_PIN B10      [get_ports "WEIGHT_EN"] ;# [get_ports "FMC_LPC_LA21_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L22P_T3U_N6_DBC_AD0P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_EN"] ;# [get_ports "FMC_LPC_LA21_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L22P_T3U_N6_DBC_AD0P_68
set_property PACKAGE_PIN A6       [get_ports "ADDR_EN_ROW1"] ;# [get_ports "FMC_LPC_LA24_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L21N_T3L_N5_AD8N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "ADDR_EN_ROW1"] ;# [get_ports "FMC_LPC_LA24_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L21N_T3L_N5_AD8N_68
set_property PACKAGE_PIN B6       [get_ports "SCANOUT_CLK"] ;# [get_ports "FMC_LPC_LA24_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L21P_T3L_N4_AD8P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SCANOUT_CLK"] ;# [get_ports "FMC_LPC_LA24_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L21P_T3L_N4_AD8P_68
#set_property PACKAGE_PIN B8       [get_ports "FMC_LPC_LA26_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L20N_T3L_N3_AD1N_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA26_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L20N_T3L_N3_AD1N_68
#set_property PACKAGE_PIN B9       [get_ports "FMC_LPC_LA26_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L20P_T3L_N2_AD1P_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA26_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L20P_T3L_N2_AD1P_68
set_property PACKAGE_PIN C6       [get_ports "WEIGHT_PIPE2[1]"] ;# [get_ports "FMC_LPC_LA25_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L19N_T3L_N1_DBC_AD9N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[1]"] ;# [get_ports "FMC_LPC_LA25_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L19N_T3L_N1_DBC_AD9N_68
set_property PACKAGE_PIN C7       [get_ports "WEIGHT_PIPE2[2]"] ;# [get_ports "FMC_LPC_LA25_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L19P_T3L_N0_DBC_AD9P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[2]"] ;# [get_ports "FMC_LPC_LA25_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L19P_T3L_N0_DBC_AD9P_68
set_property PACKAGE_PIN C11      [get_ports "COL_ADDR[5]"] ;# [get_ports "FMC_LPC_LA19_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L18N_T2U_N11_AD2N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[5]"] ;# [get_ports "FMC_LPC_LA19_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L18N_T2U_N11_AD2N_68
set_property PACKAGE_PIN D12      [get_ports "COL_ADDR[4]"] ;# [get_ports "FMC_LPC_LA19_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L18P_T2U_N10_AD2P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[4]"] ;# [get_ports "FMC_LPC_LA19_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L18P_T2U_N10_AD2P_68
set_property PACKAGE_PIN E12      [get_ports "WEIGHT_PIPE3[4]"] ;# [get_ports "FMC_LPC_LA20_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L17N_T2U_N9_AD10N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[4]"] ;# [get_ports "FMC_LPC_LA20_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L17N_T2U_N9_AD10N_68
set_property PACKAGE_PIN F12      [get_ports "WEIGHT_PIPE3[0]"] ;# [get_ports "FMC_LPC_LA20_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L17P_T2U_N8_AD10P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[0]"] ;# [get_ports "FMC_LPC_LA20_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L17P_T2U_N8_AD10P_68
#set_property PACKAGE_PIN D10      [get_ports "FMC_LPC_LA18_CC_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L16N_T2U_N7_QBC_AD3N_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA18_CC_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L16N_T2U_N7_QBC_AD3N_68
#set_property PACKAGE_PIN D11      [get_ports "FMC_LPC_LA18_CC_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L16P_T2U_N6_QBC_AD3P_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA18_CC_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L16P_T2U_N6_QBC_AD3P_68
set_property PACKAGE_PIN H12      [get_ports "WEIGHT_PIPE2[3]"] ;# [get_ports "FMC_LPC_LA22_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L15N_T2L_N5_AD11N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[3]"] ;# [get_ports "FMC_LPC_LA22_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L15N_T2L_N5_AD11N_68
set_property PACKAGE_PIN H13      [get_ports "WEIGHT_PIPE2[5]"] ;# [get_ports "FMC_LPC_LA22_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L15P_T2L_N4_AD11P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[5]"] ;# [get_ports "FMC_LPC_LA22_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L15P_T2L_N4_AD11P_68
#set_property PACKAGE_PIN E10      [get_ports "FMC_LPC_LA17_CC_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L14N_T2L_N3_GC_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA17_CC_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L14N_T2L_N3_GC_68
#set_property PACKAGE_PIN F11      [get_ports "FMC_LPC_LA17_CC_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L14P_T2L_N2_GC_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA17_CC_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L14P_T2L_N2_GC_68
#set_property PACKAGE_PIN F10      [get_ports "FMC_LPC_CLK1_M2C_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L12N_T1U_N11_GC_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_CLK1_M2C_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L12N_T1U_N11_GC_68
#set_property PACKAGE_PIN G10      [get_ports "FMC_LPC_CLK1_M2C_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L12P_T1U_N10_GC_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_CLK1_M2C_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L12P_T1U_N10_GC_68
set_property PACKAGE_PIN D9       [get_ports "WEIGHT_PIPE1[3]"] ;# [get_ports "FMC_LPC_LA30_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L10N_T1U_N7_QBC_AD4N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[3]"] ;# [get_ports "FMC_LPC_LA30_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L10N_T1U_N7_QBC_AD4N_68
set_property PACKAGE_PIN E9       [get_ports "SCAN_CHAIN_OUT_PIPE1"] ;# [get_ports "FMC_LPC_LA30_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L10P_T1U_N6_QBC_AD4P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SCAN_CHAIN_OUT_PIPE1"] ;# [get_ports "FMC_LPC_LA30_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L10P_T1U_N6_QBC_AD4P_68
set_property PACKAGE_PIN E8       [get_ports "WEIGHT_PIPE1[4]"] ;# [get_ports "FMC_LPC_LA32_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L9N_T1L_N5_AD12N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[4]"] ;# [get_ports "FMC_LPC_LA32_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L9N_T1L_N5_AD12N_68
set_property PACKAGE_PIN F8       [get_ports "WEIGHT_PIPE1[0]"] ;# [get_ports "FMC_LPC_LA32_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L9P_T1L_N4_AD12P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[0]"] ;# [get_ports "FMC_LPC_LA32_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L9P_T1L_N4_AD12P_68
set_property PACKAGE_PIN C8       [get_ports "WEIGHT_PIPE1[1]"] ;# [get_ports "FMC_LPC_LA33_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L8N_T1L_N3_AD5N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[1]"] ;# [get_ports "FMC_LPC_LA33_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L8N_T1L_N3_AD5N_68
set_property PACKAGE_PIN C9       [get_ports "WEIGHT_PIPE1[2]"] ;# [get_ports "FMC_LPC_LA33_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L8P_T1L_N2_AD5P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[2]"] ;# [get_ports "FMC_LPC_LA33_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L8P_T1L_N2_AD5P_68
set_property PACKAGE_PIN E7       [get_ports "WEIGHT_PIPE1[5]"] ;# [get_ports "FMC_LPC_LA31_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L7N_T1L_N1_QBC_AD13N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE1[5]"] ;# [get_ports "FMC_LPC_LA31_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L7N_T1L_N1_QBC_AD13N_68
#set_property PACKAGE_PIN F7       [get_ports "FMC_LPC_LA31_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L7P_T1L_N0_QBC_AD13P_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA31_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L7P_T1L_N0_QBC_AD13P_68
set_property PACKAGE_PIN J10      [get_ports "WEIGHT_PIPE2[4]"] ;# [get_ports "FMC_LPC_LA29_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L2N_T0L_N3_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[4]"] ;# [get_ports "FMC_LPC_LA29_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L2N_T0L_N3_68
set_property PACKAGE_PIN K10      [get_ports "WEIGHT_PIPE2[0]"] ;# [get_ports "FMC_LPC_LA29_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L2P_T0L_N2_68
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE2[0]"] ;# [get_ports "FMC_LPC_LA29_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L2P_T0L_N2_68
set_property PACKAGE_PIN L13      [get_ports "SCAN_CHAIN_IN"] ;# [get_ports "FMC_LPC_LA28_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L1N_T0L_N1_DBC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SCAN_CHAIN_IN"] ;# [get_ports "FMC_LPC_LA28_N"] ;# Bank  68 VCCO - VADJ_FMC - IO_L1N_T0L_N1_DBC_68
set_property PACKAGE_PIN M13      [get_ports "SAMPLE_CLK"] ;# [get_ports "FMC_LPC_LA28_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L1P_T0L_N0_DBC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SAMPLE_CLK"] ;# [get_ports "FMC_LPC_LA28_P"] ;# Bank  68 VCCO - VADJ_FMC - IO_L1P_T0L_N0_DBC_68
set_property PACKAGE_PIN L16      [get_ports "ROW_ADDR[3]"] ;# [get_ports "FMC_LPC_LA04_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L24N_T3U_N11_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[3]"] ;# [get_ports "FMC_LPC_LA04_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L24N_T3U_N11_67
set_property PACKAGE_PIN L17      [get_ports "ROW_ADDR[2]"] ;# [get_ports "FMC_LPC_LA04_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L24P_T3U_N10_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[2]"] ;# [get_ports "FMC_LPC_LA04_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L24P_T3U_N10_67
set_property PACKAGE_PIN K18      [get_ports "WEIGHT_PIPE4[1]"] ;# [get_ports "FMC_LPC_LA03_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L23N_T3U_N9_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[1]"] ;# [get_ports "FMC_LPC_LA03_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L23N_T3U_N9_67
set_property PACKAGE_PIN K19      [get_ports "WEIGHT_PIPE4[2]"] ;# [get_ports "FMC_LPC_LA03_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L23P_T3U_N8_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[2]"] ;# [get_ports "FMC_LPC_LA03_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L23P_T3U_N8_67
#set_property PACKAGE_PIN K15      [get_ports "FMC_LPC_LA10_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA10_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property PACKAGE_PIN L15      [get_ports "FMC_LPC_LA10_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L22P_T3U_N6_DBC_AD0P_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA10_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L22P_T3U_N6_DBC_AD0P_67
set_property PACKAGE_PIN J17      [get_ports "WEIGHT_PIPE4[3]"] ;# [get_ports "FMC_LPC_LA05_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L21N_T3L_N5_AD8N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[3]"] ;# [get_ports "FMC_LPC_LA05_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L21N_T3L_N5_AD8N_67
set_property PACKAGE_PIN K17      [get_ports "WEIGHT_PIPE4[5]"] ;# [get_ports "FMC_LPC_LA05_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L21P_T3L_N4_AD8P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[5]"] ;# [get_ports "FMC_LPC_LA05_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L21P_T3L_N4_AD8P_67
set_property PACKAGE_PIN J15      [get_ports "ROW_ADDR[5]"] ;# [get_ports "FMC_LPC_LA07_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L20N_T3L_N3_AD1N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[5]"] ;# [get_ports "FMC_LPC_LA07_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L20N_T3L_N3_AD1N_67
set_property PACKAGE_PIN J16      [get_ports "ROW_ADDR[4]"] ;# [get_ports "FMC_LPC_LA07_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L20P_T3L_N2_AD1P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[4]"] ;# [get_ports "FMC_LPC_LA07_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L20P_T3L_N2_AD1P_67
set_property PACKAGE_PIN K20      [get_ports "ROW_ADDR[1]"] ;# [get_ports "FMC_LPC_LA02_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L19N_T3L_N1_DBC_AD9N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[1]"] ;# [get_ports "FMC_LPC_LA02_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L19N_T3L_N1_DBC_AD9N_67
set_property PACKAGE_PIN L20      [get_ports "ROW_ADDR[0]"] ;# [get_ports "FMC_LPC_LA02_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L19P_T3L_N0_DBC_AD9P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ROW_ADDR[0]"] ;# [get_ports "FMC_LPC_LA02_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L19P_T3L_N0_DBC_AD9P_67
set_property PACKAGE_PIN G16      [get_ports "SCAN_CHAIN_OUT_PIPE3"] ;# [get_ports "FMC_LPC_LA09_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L18N_T2U_N11_AD2N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "SCAN_CHAIN_OUT_PIPE3"] ;# [get_ports "FMC_LPC_LA09_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L18N_T2U_N11_AD2N_67
set_property PACKAGE_PIN H16      [get_ports "SCAN_CHAIN_OUT_PIPE4"] ;# [get_ports "FMC_LPC_LA09_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L18P_T2U_N10_AD2P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "SCAN_CHAIN_OUT_PIPE4"] ;# [get_ports "FMC_LPC_LA09_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L18P_T2U_N10_AD2P_67
set_property PACKAGE_PIN F18      [get_ports "WEIGHT_PIPE3[3]"] ;# [get_ports "FMC_LPC_LA12_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L17N_T2U_N9_AD10N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[3]"] ;# [get_ports "FMC_LPC_LA12_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L17N_T2U_N9_AD10N_67
set_property PACKAGE_PIN G18      [get_ports "WEIGHT_PIPE3[5]"] ;# [get_ports "FMC_LPC_LA12_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L17P_T2U_N8_AD10P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[5]"] ;# [get_ports "FMC_LPC_LA12_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L17P_T2U_N8_AD10P_67
#set_property PACKAGE_PIN H17      [get_ports "FMC_LPC_LA01_CC_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA01_CC_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property PACKAGE_PIN H18      [get_ports "FMC_LPC_LA01_CC_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA01_CC_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property PACKAGE_PIN G19      [get_ports "FMC_LPC_LA06_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L15N_T2L_N5_AD11N_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA06_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L15N_T2L_N5_AD11N_67
#set_property PACKAGE_PIN H19      [get_ports "FMC_LPC_LA06_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L15P_T2L_N4_AD11P_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA06_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L15P_T2L_N4_AD11P_67
set_property PACKAGE_PIN F15      [get_ports "ADDR_EN_ROW2"] ;# [get_ports "FMC_LPC_LA13_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L14N_T2L_N3_GC_67
set_property IOSTANDARD  LVCMOS18 [get_ports "ADDR_EN_ROW2"] ;# [get_ports "FMC_LPC_LA13_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L14N_T2L_N3_GC_67
set_property PACKAGE_PIN G15      [get_ports "SCAN_CHAIN_OUT_PIPE2"] ;# [get_ports "FMC_LPC_LA13_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L14P_T2L_N2_GC_67
set_property IOSTANDARD  LVCMOS18 [get_ports "SCAN_CHAIN_OUT_PIPE2"] ;# [get_ports "FMC_LPC_LA13_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L14P_T2L_N2_GC_67
#set_property PACKAGE_PIN F16      [get_ports "FMC_LPC_LA00_CC_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L13N_T2L_N1_GC_QBC_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA00_CC_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L13N_T2L_N1_GC_QBC_67
#set_property PACKAGE_PIN F17      [get_ports "FMC_LPC_LA00_CC_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L13P_T2L_N0_GC_QBC_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA00_CC_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L13P_T2L_N0_GC_QBC_67
#set_property PACKAGE_PIN E14      [get_ports "FMC_LPC_CLK0_M2C_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L12N_T1U_N11_GC_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_CLK0_M2C_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L12N_T1U_N11_GC_67
#set_property PACKAGE_PIN E15      [get_ports "FMC_LPC_CLK0_M2C_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L12P_T1U_N10_GC_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_CLK0_M2C_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L12P_T1U_N10_GC_67
set_property PACKAGE_PIN E17      [get_ports "WEIGHT_PIPE4[4]"] ;# [get_ports "FMC_LPC_LA08_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L9N_T1L_N5_AD12N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[4]"] ;# [get_ports "FMC_LPC_LA08_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L9N_T1L_N5_AD12N_67
set_property PACKAGE_PIN E18      [get_ports "WEIGHT_PIPE4[0]"] ;# [get_ports "FMC_LPC_LA08_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L9P_T1L_N4_AD12P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE4[0]"] ;# [get_ports "FMC_LPC_LA08_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L9P_T1L_N4_AD12P_67
set_property PACKAGE_PIN C17      [get_ports "WEIGHT_PIPE3[1]"] ;# [get_ports "FMC_LPC_LA16_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L8N_T1L_N3_AD5N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[1]"] ;# [get_ports "FMC_LPC_LA16_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L8N_T1L_N3_AD5N_67
set_property PACKAGE_PIN D17      [get_ports "WEIGHT_PIPE3[2]"] ;# [get_ports "FMC_LPC_LA16_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L8P_T1L_N2_AD5P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "WEIGHT_PIPE3[2]"] ;# [get_ports "FMC_LPC_LA16_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L8P_T1L_N2_AD5P_67
set_property PACKAGE_PIN C16      [get_ports "COL_ADDR[3]"] ;# [get_ports "FMC_LPC_LA15_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L7N_T1L_N1_QBC_AD13N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[3]"] ;# [get_ports "FMC_LPC_LA15_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L7N_T1L_N1_QBC_AD13N_67
set_property PACKAGE_PIN D16      [get_ports "COL_ADDR[2]"] ;# [get_ports "FMC_LPC_LA15_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L7P_T1L_N0_QBC_AD13P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[2]"] ;# [get_ports "FMC_LPC_LA15_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L7P_T1L_N0_QBC_AD13P_67
#set_property PACKAGE_PIN C12      [get_ports "FMC_LPC_LA14_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L6N_T0U_N11_AD6N_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA14_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L6N_T0U_N11_AD6N_67
#set_property PACKAGE_PIN C13      [get_ports "FMC_LPC_LA14_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L6P_T0U_N10_AD6P_67
#set_property IOSTANDARD  LVCMOS18 [get_ports "FMC_LPC_LA14_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L6P_T0U_N10_AD6P_67
set_property PACKAGE_PIN A12      [get_ports "COL_ADDR[1]"] ;# [get_ports "FMC_LPC_LA11_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L5N_T0U_N9_AD14N_67
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[1]"] ;# [get_ports "FMC_LPC_LA11_N"] ;# Bank  67 VCCO - VADJ_FMC - IO_L5N_T0U_N9_AD14N_67
set_property PACKAGE_PIN A13      [get_ports "COL_ADDR[0]"] ;# [get_ports "FMC_LPC_LA11_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L5P_T0U_N8_AD14P_67
set_property IOSTANDARD  LVCMOS18 [get_ports "COL_ADDR[0]"] ;# [get_ports "FMC_LPC_LA11_P"] ;# Bank  67 VCCO - VADJ_FMC - IO_L5P_T0U_N8_AD14P_67
#set_property PACKAGE_PIN P3       [get_ports "FMC_LPC_DP0_M2C_N"] ;# Bank 226 - MGTHRXN3_226
#set_property PACKAGE_PIN P4       [get_ports "FMC_LPC_DP0_M2C_P"] ;# Bank 226 - MGTHRXP3_226
#set_property PACKAGE_PIN N5       [get_ports "FMC_LPC_DP0_C2M_N"] ;# Bank 226 - MGTHTXN3_226
#set_property PACKAGE_PIN N6       [get_ports "FMC_LPC_DP0_C2M_P"] ;# Bank 226 - MGTHTXP3_226
#set_property PACKAGE_PIN V7       [get_ports "FMC_LPC_GBTCLK0_M2C_C_N"] ;# Bank 226 - MGTREFCLK0N_226
#set_property PACKAGE_PIN V8       [get_ports "FMC_LPC_GBTCLK0_M2C_C_P"] ;# Bank 226 - MGTREFCLK0P_226



# external clock
set_property PACKAGE_PIN E23      [get_ports "CLK_125_N"] ;# Bank  28 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_28
set_property IOSTANDARD  LVDS     [get_ports "CLK_125_N"] ;# Bank  28 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_28
set_property PACKAGE_PIN F23      [get_ports "CLK_125_P"] ;# Bank  28 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_28
set_property IOSTANDARD  LVDS     [get_ports "CLK_125_P"] ;# Bank  28 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_28
set_property PACKAGE_PIN AH17     [get_ports "CLK_300_N"] ;# Bank  64 VCCO - VCC1V2   - IO_L13N_T2L_N1_GC_QBC_64
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "CLK_300_N"] ;# Bank  64 VCCO - VCC1V2   - IO_L13N_T2L_N1_GC_QBC_64
set_property PACKAGE_PIN AH18     [get_ports "CLK_300_P"] ;# Bank  64 VCCO - VCC1V2   - IO_L13P_T2L_N0_GC_QBC_64
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "CLK_300_P"] ;# Bank  64 VCCO - VCC1V2   - IO_L13P_T2L_N0_GC_QBC_64