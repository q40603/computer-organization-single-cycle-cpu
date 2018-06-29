#include <iostream>
#include <stdio.h>
#include <math.h>
#include<fstream> 
using namespace std;


struct cache_content{
	bool v;
	unsigned int  tag;
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


void simulate(int cache_size, int block_size){
	unsigned int tag,index,x;
	int offset_bit = log2(block_size);
	int index_bit = log2(cache_size/block_size);
	int line= cache_size>>(offset_bit);

	cache_content *cache =new cache_content[line];
	cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
		cache[j].v=false;

  FILE * fp=fopen("ICACHE.txt","r");					//read file
	while(fscanf(fp,"%x",&x)!=EOF){
	//	cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v && cache[index].tag==tag){
			cache[index].v=true; 			//hit
			hit_t++;
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
			miss_t++;
		}
	}
	fclose(fp);

	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	//ofstream myfile;
    //myfile.open ("direct_mapped_cache-i.csv");	
	int block_size[5]={16,32,64,128,256};
	int cache_size[4]={4,16,64,256};
	for(int i=0 ;i<4 ; i++){
		for(int j=0 ;j<5 ;j++){
		    simulate(cache_size[i]*K, block_size[j]);
		    sum=(double)miss_t/(double)(hit_t+miss_t);
			cout <<cache_size[i]<<","<<block_size[j]<<","<< sum << ","<<endl<<endl;
		    hit_t=0;
		    miss_t=0;
			//myfile <<cache_size[i]<<","<<block_size[j]<<","<< sum << ","<<endl;			
		}
		//myfile<<endl;
	}
	//myfile.close();
	return 0;
}
