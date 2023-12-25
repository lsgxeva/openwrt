/*
    Copyright 2023 Quectel Wireless Solutions Co.,Ltd

    Quectel hereby grants customers of Quectel a license to use, modify,
    distribute and publish the Software in binary form provided that
    customers shall have no right to reverse engineer, reverse assemble,
    decompile or reduce to source code form any portion of the Software. 
    Under no circumstances may customers modify, demonstrate, use, deliver 
    or disclose any portion of the Software in source code form.
*/

#ifndef SAHARA_H
#define SAHARA_H

#define Q_SAHARA_VER 2
#define Q_SAHARA_VER_SUP 4

#define Q_SAHARA_RAW_BUF_SZ (32*1024)

typedef enum
{
  Q_SAHARA_ZERO          = 0x00,
  Q_SAHARA_ONE           = 0x01,
  Q_SAHARA_TWO           = 0x02,
  Q_SAHARA_THREE         = 0x03,
  Q_SAHARA_FOUR          = 0x04,
  Q_SAHARA_FIVE          = 0x05,
  Q_SAHARA_SIX           = 0x06,
  Q_SAHARA_SEVEN         = 0x07,
  Q_SAHARA_EIGTH         = 0x08,
  Q_SAHARA_NINE          = 0x09,
  Q_SAHARA_TEN           = 0x0A,
  Q_SAHARA_ELEVEN        = 0x0B,
  Q_SAHARA_TWELEVE       = 0x0C,
  Q_SAHARA_THIRTEEN      = 0x0D,
  Q_SAHARA_FOURTEEN      = 0x0E,
  Q_SAHARA_FIFTEEN       = 0x0F,
  Q_SAHARA_SIXTEEN	     = 0x10,
  Q_SAHARA_SEVENTEEN     = 0x11,
  Q_SAHARA_EIGHTEEN		 = 0x12,
  Q_SAHARA_NINETEEN,
  Q_SAHARA_TWENTY        = 0x7FFFFFFF
} q_sahara_cmd;

typedef enum {
    Q_SAHARA_IMAGE_ZERO = 0,
    Q_SAHARA_IMAGE_ONE,
    Q_SAHARA_IMAGE_TWO = 0x7FFFFFFF
} q_sahara_image;

typedef enum
{
  Q_SAHARA_STATUS_ZERO =          0x00,
  Q_SAHARA_NAK_ONE =              0x01,
  Q_SAHARA_NAK_TWO =              0x02,
  Q_SAHARA_NAK_THREE =            0x03,
  Q_SAHARA_NAK_FOUR =             0x04,
  Q_SAHARA_NAK_FIVE =             0x05,
  Q_SAHARA_NAK_SIX =              0x06,
  Q_SAHARA_NAK_SEVEN =            0x07,
  Q_SAHARA_NAK_EIGHT =            0x08,
  Q_SAHARA_NAK_NINE =             0x09,
  Q_SAHARA_NAK_TEN =              0x0A,
  Q_SAHARA_NAK_ELEVEN =           0x0B,
  Q_SAHARA_NAK_TWELEVE =          0x0C,
  Q_SAHARA_NAK_THIRTEEN =         0x0D,
  Q_SAHARA_NAK_FOURTEEN =         0x0E,
  Q_SAHARA_NAK_FIFTEEN =          0x0F,
  Q_SAHARA_NAK_SIXTEEN =          0x10,
  Q_SAHARA_NAK_SEVENTEEN =        0x11,
  Q_SAHARA_NAK_EIGHTEEN =         0x12,
  Q_SAHARA_NAK_NINETEEN =         0x13,
  Q_SAHARA_NAK_TWENTY =           0x14,
  Q_SAHARA_NAK_TWENTY_ONE =       0x15,
  Q_SAHARA_NAK_TWENTY_TWO =       0x16,
  Q_SAHARA_NAK_TWENTY_THREE =     0x17,
  Q_SAHARA_NAK_TWENTY_FOUR =      0x18,
  Q_SAHARA_NAK_TWENTY_FIVE =      0x19,
  Q_SAHARA_NAK_TWENTY_SIX =       0x1A,
  Q_SAHARA_NAK_TWENTY_SEVEN =     0x1B,
  Q_SAHARA_NAK_TWENTY_EIGHT =     0x1C,
  Q_SAHARA_NAK_TWENTY_NINE =      0x1D,
  Q_SAHARA_NAK_THIRTY =           0x1E,
  Q_SAHARA_NAK_THIRTY_ONE =       0x1F,
  Q_SAHARA_NAK_THIRTY_TWO =       0x20,
  Q_SAHARA_NAK_THIRTY_THREE =     0x21,
  Q_SAHARA_NAK_THIRTY_FOUR =      0x22,
  Q_SAHARA_NAK_THIRTY_FIVE =      0x23,
  Q_SAHARA_NAK_THIRTY_SIX,
  Q_SAHARA_NAK_THIRTY_SEVEN = 0x7FFFFFFF
} q_sahara_status;

typedef enum
{
  Q_SAHARA_MODE_ZERO   = 0x0,
  Q_SAHARA_MODE_ONE    = 0x1,
  Q_SAHARA_MODE_TWO    = 0x2,
  Q_SAHARA_MODE_THREE  = 0x3,
  Q_SAHARA_MODE_FOUR,
  Q_SAHARA_MODE_FIVE = 0x7FFFFFFF
} q_sahara_mode;

typedef enum
{
  Q_SAHARA_EXEC_ZERO     = 0x00,
  Q_SAHARA_EXEC_ONE      = 0x01,
  Q_SAHARA_EXEC_TWO      = 0x02,
  Q_SAHARA_EXEC_THREE    = 0x03,
  Q_SAHARA_EXEC_FOUR     = 0x04,
  Q_SAHARA_EXEC_FIVE     = 0x05,
  Q_SAHARA_EXEC_SIX      = 0x06,
  Q_SAHARA_EXEC_SEVEN,
  Q_SAHARA_EXEC_EIGHT = 0x7FFFFFFF
} q_sahara_exec;

typedef enum {
    Q_SAHARA_WAIT_ONE,
    Q_SAHARA_WAIT_TWO,
    Q_SAHARA_WAIT_THREE,
    Q_SAHARA_WAIT_FOUR,
    Q_SAHARA_WAIT_FIVE,
    Q_SAHARA_WAIT_SIX,
    Q_SAHARA_WAIT_SEVEN,
    Q_SAHARA_WAIT_EIGHT
} q_sahara_state;

typedef struct
{
  uint32_t q_cmd;
  uint32_t q_len;
} q_sahara_pkt_h;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_ver;
  uint32_t q_ver_sup;
  uint32_t q_cmd_pkt_len;
  uint32_t q_mode;
  uint32_t q_reserve1;
  uint32_t q_reserve2;
  uint32_t q_reserve3;
  uint32_t q_reserve4;
  uint32_t q_reserve5;
  uint32_t q_reserve6;
} q_sahara_hello_pkt;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_ver;
  uint32_t q_ver_sup;
  uint32_t q_status;
  uint32_t q_mode;
  uint32_t q_reserve1;
  uint32_t q_reserve2;
  uint32_t q_reserve3;
  uint32_t q_reserve4;
  uint32_t q_reserve5;
  uint32_t q_reserve6;
} q_sahara_hello_pkt_response;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_image_id;
  uint32_t q_data_offset;
  uint32_t q_data_length;
} q_sahara_read_pkt_data;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint64_t q_image_id;
  uint64_t q_data_offset;
  uint64_t q_data_length;
} q_sahara_read_pkt_data_64bit;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_image_id;
  uint32_t q_status;
} q_sahara_end_pkt_image_tx;

typedef struct
{
  q_sahara_pkt_h q_header;
} q_sahara_done_pkt;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_image_tx_status;
} q_sahara_done_pkt_response;

typedef struct
{
  q_sahara_pkt_h q_header;
} q_sahara_reset_pkt;

typedef struct
{
  q_sahara_pkt_h q_header;
} q_sahara_reset_pkt_response;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_memory_table_addr;
  uint32_t q_memory_table_length;
} q_sahara_memory_pkt_debug;
typedef struct
{
  q_sahara_pkt_h q_header;
  uint64_t q_memory_table_addr;
  uint64_t q_memory_table_length;
} q_sahara_memory_pkt_debug_64bit;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_memory_addr;
  uint32_t q_memory_length;
} q_sahara_pkt_memory_read;
typedef struct
{
  q_sahara_pkt_h q_header;
  uint64_t q_memory_addr;
  uint64_t q_memory_length;
} q_sahara_pkt_memory_read_64bit;

typedef struct
{
  q_sahara_pkt_h q_header;
} q_sahara_cmd_pkt_ready;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_mode;
} q_sahara_cmd_pkt_switch_mode;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_cli_cmd;
} q_sahara_cmd_pkt_exec;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_cli_cmd;
  uint32_t q_resp_len;
} q_sahara_cmd_pkt_exec_response;

typedef struct
{
  q_sahara_pkt_h q_header;
  uint32_t q_cli_cmd;
} q_sahara_cmd_pkt_exec_data;

#define DLOAD_DEBUG_STRLEN_BYTES 20
typedef struct
{
  uint32_t q_save_pref;
  uint32_t  q_mem_base;
  uint32_t  q_len;
  char          q_desc[DLOAD_DEBUG_STRLEN_BYTES];
  char          q_filename[DLOAD_DEBUG_STRLEN_BYTES];
} q_dload_debug_type;

typedef struct
{
  uint64_t q_save_pref;
  uint64_t q_mem_base;
  uint64_t q_len;
  char q_desc[DLOAD_DEBUG_STRLEN_BYTES];
  char q_filename[DLOAD_DEBUG_STRLEN_BYTES];
} q_dload_debug_type_64bit;

typedef struct {
    void* q_rx_buf;
    void* q_tx_buf;
    void* q_misc_buf;
    q_sahara_state q_state;
    size_t q_timed_data_size;
	int q_fd;
    int q_ram_dump_image;
    int q_max_ram_dump_retries;
    uint32_t q_max_ram_dump_read;
    q_sahara_mode q_mode;
    q_sahara_mode q_prev_mode;
	unsigned int q_cmd;
	bool q_ram_dump_64bit;
} q_sahara_data_t;
#endif
