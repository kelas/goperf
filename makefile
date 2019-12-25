
LVM=@/opt/clang/bin/clang++
GNU=@/opt/rh/devtoolset-8/root/usr/bin/x86_64-redhat-linux-c++
ICC=/opt/intel/bin/icc -std=c++11
GOO=@go build -ldflags="-s -w" -tags production
TIME=@/usr/bin/time --format "all %E mem %M cpu %P" --
SZ=@strip iota && ls -lah iota
#OUT=>/dev/null

all: clang gcc icc icc-parallel golang golang-parallel golang-hog

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
	@echo icc:
	$(SZ)
	$(TIME) ./iota $(OUT)

icc-parallel: clean
	$(ICC) -Os -vec -noalign -parallel -ip iota.cpp -w -o iota
	@echo icc-parallel:
	$(SZ)
	$(TIME) ./iota $(OUT)

tcc:
	@tcc -O3 iota.c -o iota
	@echo tcc:
	$(SZ)
	$(TIME) ./iota $(OUT)

# arguments
# ./iota ns np parallel
#     ns chunck/split size per go-routine
#     np number of go-routines
#     parallel true/false
#
# the total array size is ns*np

golang: clean build-go
	$(TIME) ./iota 1048576 512 false $(OUT)

golang-parallel: clean build-go
	$(TIME) ./iota 1048576 512 true $(OUT)

golang-hog: clean build-go
	$(TIME) ./iota 512 1048576 true $(OUT)

build-go:
	$(GOO) iota.go
	@echo golang:
	$(SZ)

clean:
	rm -f iota
	