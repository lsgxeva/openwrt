cmake_minimum_required(VERSION 2.4) 

project(qlog) 
add_definitions(-Wall -Wextra -Werror -O1)

set( qlog_srcs
     main.c asr.c mdm.c tty2tcp.c sahara.c tftp.c ymodem.c unisoc.c usb_linux.c ftp.c mtk.c sony.c eigen.c
     )

add_executable(qlog ${qlog_srcs})
target_link_libraries(qlog PUBLIC pthread) 
#install (TARGETS qlog DESTINATION bin)
