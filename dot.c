#ifdef __cplusplus
extern "C" {
#endif
    double dot_(  double *a, int *lena,
                  double *b, int *lenb );
#ifdef __cplusplus
    }
#endif

double  dot_( double *a, int *lena, double *b, int *lenb){
   
double temp = 0.0;
int i;

int alength = *lena;

for (i=0; i<alength; i++) {
          //temp += *(a+i) * *(b+i);
          temp += a[i] * b[i];
       }
    return temp;

}
