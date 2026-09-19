/* Interpose only the two forward helpers while compiling the real 2D sources.
 * Numerical tests cannot observe an invalid pointer that is never dereferenced.
 * Check the actual pointers passed for directly transformed partial inputs.
 */
#pragma once
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define psimd_fft8_real_f32 nnpack_fft8_real_unchecked
#define psimd_fft16_real_f32 nnpack_fft16_real_unchecked
#include NNPACK_REAL_HEADER
#undef psimd_fft8_real_f32
#undef psimd_fft16_real_f32

extern uintptr_t nnpack_input_begin, nnpack_input_end;

static inline void nnpack_check_input_pointer(const float *p) {
  if (nnpack_input_end &&
      ((uintptr_t)p < nnpack_input_begin ||
       (uintptr_t)p > nnpack_input_end - 4 * sizeof(float))) {
    fprintf(stderr, "partial-input FFT helper received an out-of-range pointer\n");
    abort();
  }
}

#define CHECKED_FFT(N)                                                     \
  static inline void psimd_fft##N##_real_f32(                             \
      const float *lo, const float *hi, size_t stride,                    \
      uint32_t offset, uint32_t count, float *output,                     \
      size_t output_stride) {                                            \
    nnpack_check_input_pointer(lo);                                      \
    nnpack_check_input_pointer(hi);                                      \
    nnpack_fft##N##_real_unchecked(lo, hi, stride, offset, count, output, \
                                  output_stride);                        \
  }
CHECKED_FFT(8)
CHECKED_FFT(16)
#undef CHECKED_FFT
