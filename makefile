
LVM=/opt/clang/bin/clang++
GNU=/opt/rh/devtoolset-8/root/usr/bin/x86_64-redhat-linux-c++
GOO=go

all: clang gcc golang

clang: clean
	# -Rpass=loop-vectorize
	$(LVM) -fslp-vectorize -fvectorize -O3 -arch=broadwell iota.cpp -w -o iota
	./iota

gcc: clean
	$(GNU) -O3 iota.cpp -w -o iota
	./iota

# arguments
# ./iota ns np parallel
#     ns chunck/split size per go-routine
#     np number of go-routines
#     parallel true/false
#
# the total array size is ns*np

golang: clean
	$(GOO) build iota.go
	time ./iota 10000 10000 false  # single
	time ./iota 10000 10000 true   # parallel
	time ./iota 1000000 100 true   # parallel, fewer goroutines

clean:
	rm -f iota
	