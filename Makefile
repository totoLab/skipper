# Skipper Makefile

CC := gcc
CFLAGS := -O3 -fPIC
LIBS := -lm
BIN_DIR := bin

ifeq ($(OS),Windows_NT)
    EXE := .exe
    LIB := skipper.dll
    RM := del /Q
    LDFLAGS := -shared
else
    EXE :=
    LIB := libskipper.so
    RM := rm -f
    LDFLAGS := -shared
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Darwin)
        LIB := libskipper.dylib
    endif
endif

TARGETS := $(addprefix $(BIN_DIR)/,skipper$(EXE) tensor-gen$(EXE) bin2c$(EXE) $(LIB))

all: $(BIN_DIR) $(TARGETS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/$(LIB): skipper.c biquad.c lzwlib.c skipper.h biquad.h lzwlib.h 4d-tensor.h | $(BIN_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) skipper.c biquad.c lzwlib.c $(LIBS) -o $@

$(BIN_DIR)/skipper$(EXE): skipper.c biquad.c lzwlib.c skipper.h biquad.h lzwlib.h 4d-tensor.h | $(BIN_DIR)
	$(CC) $(CFLAGS) skipper.c biquad.c lzwlib.c $(LIBS) -o $@

$(BIN_DIR)/tensor-gen$(EXE): tensor-gen.c lzwlib.c skipper.h lzwlib.h | $(BIN_DIR)
	$(CC) $(CFLAGS) tensor-gen.c lzwlib.c $(LIBS) -o $@

$(BIN_DIR)/bin2c$(EXE): bin2c.c lzwlib.c | $(BIN_DIR)
	$(CC) $(CFLAGS) bin2c.c lzwlib.c $(LIBS) -o $@

clean:
	$(RM) $(TARGETS)
	rmdir $(BIN_DIR) 2>/dev/null || true
