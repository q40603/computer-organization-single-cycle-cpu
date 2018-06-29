#include <iostream>
#include <stdio.h>
#include <math.h>


using namespace std;


struct cache_content{
	bool v;
	unsigned int  tag[100];
	unsigned int  tagused[100];
//	unsigned int	data[16];
};
double sum;
int hit_t=0,miss_t=0;
const int K=1024;

int log2( int n )
{
    // log(n)/log(2) is log2.
 //   return log( n ) / log(double(2));
    int t=0;
    while(n/2!=0){
        n=n/2;
        t++;
    }
    return t;
}


void simulate(int cache_size, int block_size,int n){
	unsigned int tag,index,x;
	int Nway = n;
	int offset_bit = log2(block_size);
	int index_bit = log2(cache_size/(block_size*Nway));
	int line= cache_size>>(offset_bit)/Nway;
	cout<<"cache_size:"<<cache_size/K<<endl;
	cache_content *cache =new cache_content[line];
	cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++){
		cache[j].v=false;
        for(int k=0;k<Nway;k++){
            cache[j].tagused[k]=0;
        }
	}
  FILE * fp=fopen("RADIX.txt","r");					//read file
    int used=0;
	while(fscanf(fp,"%x",&x)!=EOF){
	//	cout<<hex<<x<<" ";
        used++;
        int miss=1;
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v ){
			for(int i=0;i<Nway;i++){			//hit
                if(cache[index].tag[i]==tag){
                    cache[index].tagused[i]=used;
                    hit_t++;
                    miss=0;
                    break;
                }
			}
		}
		if(miss){
            int min = used;
            int n=0;
            for(int i=0;i<Nway;i++){
                if(cache[index].tagused[i]<min){
                    min=cache[index].tagused[i];
                    n=i;
                }
            }
            cache[index].tagused[n]=used;
			cache[index].v=true;			//miss
			cache[index].tag[n]=tag;
			miss_t++;
		}
	}
	fclose(fp);

	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	int nway[]={1,2,4,8};
	for(int i=0;i<4;i++){
		cout<<nway[i]<<"-WAY"<<endl;
	    simulate(1*K, 64,nway[i]);
	    sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;
	
	   simulate(2*K, 64,nway[i]);
		sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;
	
	    simulate(4*K, 64,nway[i]);
		sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;
	
	    simulate(8*K, 64,nway[i]);
		sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;
	
	    simulate(16*K, 64,nway[i]);
		sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;
	
	    simulate(32*K, 64,nway[i]);
		sum=(double)miss_t/(double)(hit_t+miss_t);
		cout << sum << endl;
	    hit_t=0;
	    miss_t=0;		
	    cout<<"----------------------------------------------------------"<<endl;
	}
	return 0;
}
