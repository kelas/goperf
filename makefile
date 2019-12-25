
LVM=@/opt/clang/bin/clang++
GNU=@/opt/rh/devtoolset-8/root/usr/bin/x86_64-redhat-linux-c++
GOO=@go
RUN=@/usr/bin/time --format "all %E mem %M cpu %P" -- ./iota
OUT=>/dev/null

all: clang gcc golang

clang: clean
	# -Rpass=loop-vectorize
	$(LVM) -fslp-vectorize -fvectorize -O3 iota.cpp -w -o iota
	@echo clang
	$(RUN) $(OUT)

gcc: clean
	$(GNU) -O3 iota.cpp -w -o iota
	@echo gcc
	$(RUN) $(OUT)

# arguments
# ./iota ns np parallel
#     ns chunck/split size per go-routine
#     np number of go-routines
#     parallel true/false
#
# the total array size is ns*np

golang: clean
	$(GOO) build iota.go
	@echo golang
	$(RUN) 10000 10000 false >/dev/null
	$(RUN) 10000 10000 true  >/dev/null
	$(RUN) 1000000 100 true  >/dev/null
	$(RUN) 5000000 20  true  >/dev/null

clean:
	rm -f iota
	