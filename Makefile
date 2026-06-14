# Skipper Makefile

CC := gcc
CFLAGS := -O3 -fPIC
LIBS := -lm

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

utils := skipper$(EXE) tensor-gen$(EXE) bin2c$(EXE) $(LIB)

all: $(utils)

$(LIB): skipper.c biquad.c lzwlib.c skipper.h biquad.h lzwlib.h 4d-tensor.h
	$(CC) $(CFLAGS) $(LDFLAGS) skipper.c biquad.c lzwlib.c $(LIBS) -o $(LIB)

skipper$(EXE): skipper.c biquad.c lzwlib.c skipper.h biquad.h lzwlib.h 4d-tensor.h
	$(CC) $(CFLAGS) skipper.c biquad.c lzwlib.c $(LIBS) -o skipper$(EXE)

tensor-gen$(EXE): tensor-gen.c lzwlib.c skipper.h lzwlib.h
	$(CC) $(CFLAGS) tensor-gen.c lzwlib.c $(LIBS) -o tensor-gen$(EXE)

bin2c$(EXE): bin2c.c lzwlib.c
	$(CC) $(CFLAGS) bin2c.c lzwlib.c $(LIBS) -o bin2c$(EXE)

clean:
	$(RM) $(utils)

