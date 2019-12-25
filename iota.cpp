#include <iostream>
#include <chrono>

#define RND 8
//#define SZ 1024*1024*512
#define SZ 10000*10000
#define T long long
#define J unsigned long long
#define I int

#define NOW chrono::high_resolution_clock::now()
#define CLK start=NOW;acc=0;
#define LAP cout << chrono::duration_cast<chrono::milliseconds>(NOW-start).count() << "ms";
#define IOTA N(SZ,t[i]=i)
#define W while
#define N(n,a...) {unsigned int _n=(n),i=0;W(i<_n){a;++i;}}           //!< while(i<n){a}
#define R return 0;

using namespace std;

I main(){
    T*t=new T[SZ];T acc;auto CLK
    IOTA //warmup
    
    N(RND,
      CLK
      IOTA
      LAP
      N(SZ,acc+=t[i])
      cout << " " << acc << endl
    )
}

//:~
