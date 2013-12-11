CC=gcc -m64
CCFLAGS=-Iobjs/ -O3 -Wall -std=c99
ISPC=ispc
ISPCFLAGS=-O2 --arch=x86-64 --target=sse2

default: simple

.PHONY: dirs clean
.PRECIOUS: objs/simple.h

dirs:
	/bin/mkdir -p objs/

clean:
	/bin/rm -rf objs *~ simple

simple: dirs simple.ml objs/simple_ispc.o
	ocamlfind ocamlopt -package ctypes.foreign -linkpkg simple.ml objs/simple_ispc.o -o $@ -ccopt -rdynamic

objs/%_ispc.h objs/%_ispc.o: %.ispc
	$(ISPC) $(ISPCFLAGS) $< -o objs/$*_ispc.o -h objs/$*_ispc.h
