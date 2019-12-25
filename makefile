
LVM=@/opt/clang/bin/clang++
GNU=@/opt/rh/devtoolset-8/root/usr/bin/x86_64-redhat-linux-c++
ICC=/opt/intel/bin/icc -std=c++11
GOO=@go
TIME=@/usr/bin/time --format "all %E mem %M cpu %P" --
SZ=strip iota && ls -lah iota
#OUT=>/dev/null

all: clang gcc icc iccpar golang

clang: clean
	@# -Rpass=loop-vectorize
	$(LVM) -ffast-math -fslp-vectorize -fvectorize -O3 iota.cpp -w -o iota
	@echo clang:
	$(SZ)
	$(TIME) ./iota $(OUT)

gcc: clean
	$(GNU) -O3 iota.cpp -w -o iota
	@echo gcc:
	$(SZ)
	$(TIME) ./iota $(OUT)

icc: clean
	$(ICC) -O3 iota.cpp -w -o iota
	@echo icc-parallel:
	$(SZ)
	$(TIME) ./iota $(OUT)

iccpar: clean
	$(ICC) -Os -vec -noalign -parallel -ip iota.cpp -w -o iota
	@echo icc-parallel:
	$(SZ)
	$(TIME) ./iota $(OUT)

# arguments
# ./iota ns np parallel
#     ns chunck/split size per go-routine
#     np number of go-routines
#     parallel true/false
#
# the total array size is ns*np

golang: clean
	$(GOO) build -tags production iota.go
	@echo golang:
	$(SZ)
	$(TIME) ./iota 1048576 512 false $(OUT)
	$(TIME) ./iota 1048576 512 true $(OUT)
	$(TIME) ./iota 1048576 512 true $(OUT)
	$(TIME) ./iota 1048576 512 true $(OUT)
	$(TIME) ./iota 512 1048576 true $(OUT)

clean:
	rm -f iota
	