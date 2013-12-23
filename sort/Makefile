ISPC_SRC=sort.ispc
ISPC_IA_TARGETS=sse2,sse4-x2,avx

default: sort

include ../common.mk

sort: dirs sort.ml objs/sort_ispc.h $(OBJS) objs/timing.o
	ocamlfind ocamlopt -pp camlp4o -package ctypes.foreign -linkpkg \
	sort.ml $(OBJS) objs/timing.o \
	-o $@ -ccopt -rdynamic -cclib -lstdc++ -thread

objs/timing.o: ../timing.cpp
	$(CXX) $(CXXFLAGS) -c -I`ocamlc -where` $< -o $@


