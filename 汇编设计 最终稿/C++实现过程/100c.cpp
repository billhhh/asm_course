#include "stdio.h"
#include "cstdlib"

void Calculate()
{
	int i=2;
	int divNum;
	while(1)
	{
		if(i>100)
			break;

		divNum=1;
		while(1)
		{
			++divNum;
			if(divNum>=i)
				break;
			if(i%divNum==0)
				break;
		}
		if(divNum>=i)
			printf("%d ",i);
		++i;
	}
	printf("\n\n");
}


int main()
{
	printf("The Primes Within 100 Are :\n");

	Calculate();

	system("pause");

	return 0;
}