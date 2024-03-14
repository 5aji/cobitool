SRC_URI:append = " \
        file://0001-vadj.patch \
        "
  
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
  
#Add debug for FSBL(optional)
#XSCTH_BUILD_DEBUG = "1"
  
#Enable appropriate FSBL debug or compiler flags
# YAML_COMPILER_FLAGS:append = " -DXPS_BOARD_ZCU104"
