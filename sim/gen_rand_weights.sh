#!/usr/bin/env bash
dd if=/dev/urandom bs=1 count=24576 | xxd -ps -c 3 > rand_weights.hex
