CC=gcc -m64
CCFLAGS=-Iobjs/ -O3 -Wall -std=c99
ISPC=ispc
ISPCFLAGS=-O2 --arch=x86-64 --target=sse2

default: simple simple.so

.PHONY: dirs clean
.PRECIOUS: objs/simple.h

dirs:
	/bin/mkdir -p objs/

clean:
	/bin/rm -rf objs *~ simple

simple.so: dirs objs/simple_ispc.o
	$(CC) $(CCFLAGS) -shared -o $@ objs/simple_ispc.o

simple: dirs simple.ml
	ocamlfind ocamlopt -package ctypes.foreign -linkpkg simple.ml -o $@

objs/%_ispc.h objs/%_ispc.o: %.ispc
	$(ISPC) $(ISPCFLAGS) $< -o objs/$*_ispc.o -h objs/$*_ispc.h
