
#pragma once

#include <stdint.h>

int read_file_to_bram(int pipe, char* fname, volatile uint32_t* dest);