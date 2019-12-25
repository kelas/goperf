#include <stdlib.h> //malloc
#include <stdio.h> //printf
#include <time.h> //clock

#define RND 8
#define SZ 1048576*512
#define T long long
#define J unsigned long long
#define I int
#define U unsigned int

#define CLK start = clock();acc=0;
#define DIFF(e,s) (J)((e - s) * 1E3 / CLOCKS_PER_SEC)
#define LAP printf("%lldms ", DIFF(start,clock()));
#define IOTA N(SZ,t[i]=i)
#define W while
#define N(n,a...) {U _n=(n),i=0;W(i<_n){a;++i;}}           //!< while(i<n){a}
#define R return
#define O printf

I main(){
    T*t=malloc(SZ*sizeof(T));T acc;clock_t start,end;
    IOTA //warmup
    
    N(RND,
      CLK
      IOTA
      LAP
      N(SZ,acc+=t[i])
      O("%lld\n",acc)
    )
    free(t);
}

//:~
