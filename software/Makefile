
SRC_DIR := src/
INC_DIR := inc/

CFLAGS += -I$(INC_DIR) -MMD -O2

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
.PHONY: all clean
all: bin/ bin/cobitool

bin/:
	mkdir -p bin
bin/cobitool: $(SRC_FILES:.c=.o)
	${CC} ${CFLAGS} -o $@ $^ -lgpiod

clean: $(SRC_FILES:.c=.d) $(SRC_FILES:.c=.o)
	rm $^

-include $(SRC_FILES:.c=.d)
