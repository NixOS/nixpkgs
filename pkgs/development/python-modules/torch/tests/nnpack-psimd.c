/* Standalone control for the pinned NNPACK psimd 2D Fourier sources.
 * Link their 2d-fourier-{8x8,16x16}.c, NNP_INFERENCE_ONLY=0.
 * The oracle is a double-precision separable DFT, not the tested FFT.
 */
#include <complex.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef void transform_fn(const float *, float *, size_t, size_t,
                          uint32_t, uint32_t, uint32_t, uint32_t);
typedef void bias_fn(const float *, float *, const float *, size_t, size_t,
                     uint32_t, uint32_t);
#define DECLARE(N) \
  extern transform_fn nnp_fft##N##x##N##_with_offset__psimd; \
  extern transform_fn nnp_ifft##N##x##N##_with_offset__psimd; \
  extern bias_fn nnp_ifft##N##x##N##_with_bias__psimd; \
  extern bias_fn nnp_ifft##N##x##N##_with_bias_with_relu__psimd
DECLARE(8);
DECLARE(16);

static double worst_forward, worst_inverse;
static unsigned long forward_cases, inverse_cases, bias_cases;
/* Used by the optional helper-argument checks in nnpack-input-pointers.h. */
uintptr_t nnpack_input_begin, nnpack_input_end;
static const float guard = 1234567.0f;

static void check(float actual, double expected, double tolerance, double *worst) {
  double error = fabs(actual - expected);
  if (!isfinite(actual) || error > tolerance) {
    fprintf(stderr, "actual=%.9g expected=%.17g error=%.9g limit=%.9g\n",
            actual, expected, error, tolerance);
    exit(1);
  }
  if (error > *worst) *worst = error;
}

/* NNPACK keeps the two real vertical DC/Nyquist rows in a dual-real
 * horizontal representation. Other vertical frequencies use real/imaginary
 * row pairs. Each pair is then stored as consecutive SIMD4 real/imag blocks.
 */
static void oracle(int n, const float *tile, float *packed, int ts) {
  double complex roots[16][16], vertical[16][16], spectrum[16][16];
  double rows[16][16] = {{0}};
  for (int k=0;k<n;k++) for (int x=0;x<n;x++) {
    double angle = -2.0 * acos(-1.0) * k * x / n;
    roots[k][x] = cos(angle) + I*sin(angle);
  }
  for (int k=0;k<n;k++) for (int x=0;x<n;x++) {
    vertical[k][x] = 0;
    for (int y=0;y<n;y++) vertical[k][x] += tile[y*n+x]*roots[k][y];
  }
  for (int k=0;k<n;k++) for (int l=0;l<n;l++) {
    spectrum[k][l] = 0;
    for (int x=0;x<n;x++) spectrum[k][l] += vertical[k][x]*roots[l][x];
  }
  for (int l=0;l<n/2;l++) for (int s=0;s<2;s++) {
    rows[0][2*l+s] = creal(spectrum[s*n/2][l]);
    rows[1][2*l+s] = l ? cimag(spectrum[s*n/2][l])
                                     : creal(spectrum[s*n/2][n/2]);
  }
  for (int k=1;k<n/2;k++) for (int l=0;l<n;l++) {
    rows[2*k][l] = creal(spectrum[k][l]);
    rows[2*k+1][l] = cimag(spectrum[k][l]);
  }
  for (int r=0;r<n;r+=2) for (int c=0;c<n;c+=4)
    for (int s=0;s<2;s++) for (int lane=0;lane<4;lane++)
      packed[(r/2*(n/4)+c/4)*ts+s*4+lane] = rows[r+s][c+lane];
}

static void fill(float *p, size_t count) {
  for (size_t i=0;i<count;i++) p[i]=guard;
}

static void check_output(int n, float *out, int ds, int nr, int nc,
                         int ro, int co, const float *tile, float bias, int relu) {
  for (int i=0;i<n*ds+32;i++) {
    int r=(i-16)/ds, c=(i-16)%ds;
    if (i>=16 && r<nr && c<nc) {
      double expected=tile[(r+ro)*n+c+co]+(double)bias;
      if (relu && expected<0) expected=0;
      check(out[i], expected, 3e-5, &worst_inverse);
    } else if (out[i]!=guard) {
      fprintf(stderr,"output guard changed at %d, tile %d\n",i,n);
      exit(2);
    }
  }
}

static void run_size(int n, transform_fn *forward, transform_fn *inverse,
                     bias_fn *bias_inverse, bias_fn *relu_inverse) {
  float tile[256], packed[32*12+32], actual[32*12+32];
  float out[16*19+32];
  uint32_t rng=12345;
  for (int pattern=0;pattern<4;pattern++) {
    for (int i=0;i<n*n;i++) {
      rng=rng*1664525u+1013904223u;
      tile[i]=pattern==0 ? (i==n+2 ? 1.0f:0.0f) :
              pattern==1 ? (i%2 ? -1.0f:1.0f) :
              pattern==2 ? 0.0f : ((int)(rng>>16)-32768)/16384.0f;
    }
    for (int ts=8;ts<=12;ts+=4) {
      fill(packed,sizeof packed/sizeof *packed);
      oracle(n,tile,packed+16,ts);
      for (int ds=n;ds<=n+3;ds+=3) {
        for (int ro=0;ro<n;ro++) for (int co=0;co<n;co++)
          for (int nr=1;nr<=n-ro;nr++) for (int nc=1;nc<=n-co;nc++) {
            fill(out,sizeof out/sizeof *out);
            inverse(packed+16,out+16,ts*sizeof(float),ds,nr,nc,ro,co);
            check_output(n,out,ds,nr,nc,ro,co,tile,0,0);
            inverse_cases++;
          }
        for (int nr=1;nr<=n;nr++) for (int nc=1;nc<=n;nc++)
          for (int b=0;b<3;b++) for (int relu=0;relu<2;relu++) {
            float bias=(b-1)*0.75f;
            fill(out,sizeof out/sizeof *out);
            (relu ? relu_inverse:bias_inverse)(packed+16,out+16,&bias,
                                                ts*sizeof(float),ds,nr,nc);
            check_output(n,out,ds,nr,nc,0,0,tile,bias,relu);
            bias_cases++;
          }
      }
    }
  }
  /* Every shape at each of its four extreme offsets. Unlike round trips,
   * compare the forward transform directly to independent DFT coefficients.
   */
  for (int nr=1;nr<=n;nr++) for (int nc=1;nc<=n;nc++)
    for (int edge=0;edge<4;edge++) for (int ts=8;ts<=12;ts+=4)
    for (int wide=0;wide<(nr==1 ? 2:1);wide++) {
      int ro=(edge&1) ? n-nr:0, co=(edge&2) ? n-nc:0;
      /* A one-row input never uses its row stride. A large stride exposes
       * attempts to form an unused next-row or high-half pointer. */
      size_t ds=wide ? SIZE_MAX/sizeof(float):(size_t)nc+3;
      /* An exact input extent makes ASan catch a vector read past the final
       * partial row; a full-tile scratch input would conceal that error. */
      float *input=malloc(((nr-1)*ds+nc)*sizeof(float));
      if (!input) abort();
      memset(tile,0,sizeof tile);
      for (int r=0;r<nr;r++) for (int c=0;c<nc;c++) {
        rng=rng*1664525u+1013904223u;
        input[r*ds+c]=tile[(r+ro)*n+c+co]=((int)(rng>>16)-32768)/16384.0f;
      }
      fill(packed,sizeof packed/sizeof *packed);
      fill(actual,sizeof actual/sizeof *actual);
      oracle(n,tile,packed+16,ts);
      nnpack_input_begin=(uintptr_t)input;
      nnpack_input_end=nc>=4 ? (uintptr_t)(input+(nr-1)*ds+nc) : 0;
      forward(input,actual+16,ds,ts*sizeof(float),nr,nc,ro,co);
      nnpack_input_end=0;
      for (int i=0;i<(int)(sizeof packed/sizeof *packed);i++) {
        if (packed[i]==guard && actual[i]!=guard) {
          fprintf(stderr,"transform guard changed\n"); exit(3);
        }
        check(actual[i],packed[i],2e-4,&worst_forward);
      }
      forward_cases++;
      free(input);
    }
}

int main(void) {
  run_size(8,nnp_fft8x8_with_offset__psimd,nnp_ifft8x8_with_offset__psimd,
             nnp_ifft8x8_with_bias__psimd,nnp_ifft8x8_with_bias_with_relu__psimd);
  run_size(16,nnp_fft16x16_with_offset__psimd,nnp_ifft16x16_with_offset__psimd,
              nnp_ifft16x16_with_bias__psimd,nnp_ifft16x16_with_bias_with_relu__psimd);
  printf("{\"forward_cases\":%lu,\"inverse_cases\":%lu,\"bias_relu_cases\":%lu,"
         "\"max_forward_absolute_error\":%.9g,\"max_inverse_absolute_error\":%.9g}\n",
         forward_cases,inverse_cases,bias_cases,worst_forward,worst_inverse);
  return 0;
}
