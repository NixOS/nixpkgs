`torch.tests.nnpackPSIMD` compiles the actual vendored NNPACK/psimd source with
the package's array-contract patch. It does not build Torch. The test runs on
the build platform, including when selected through a cross Torch package.

The independent double-precision DFT oracle checks 316,672 inverse cases,
30,720 bias/ReLU cases, and 2,752 forward cases for the 8x8 and 16x16 transforms.
Cases include every nonempty inverse rectangle/offset, tight/padded strides,
partial input allocations, in-place partial-column transforms, and one-row
inputs with a large unused stride. An optional helper interposer checks the
actual partial-input pointers, including pointers the helper never dereferences.
The original source fails this check even though its numerical controls pass.

The passthru runs optimized and ASan/UBSan variants with the build compiler.
To run separately with GCC and Clang, first apply the production patch to the
pinned Torch source, then use:

```sh
python3 nnpack-psimd.py --source-root /path/to/patched-torch/third_party \
  --output /tmp/nnpack-psimd --cc /path/to/gcc --cc /path/to/clang \
  --check-input-pointers
```

The script records compiler commands, source hashes, diagnostics, and numerical
results. This tests the psimd FFT routines, not full NNPACK convolution, other
SIMD implementations, or exceptional floating-point inputs. Sanitizers alone
do not prove C array provenance or detect every invalid `restrict` contract.

The patch preserves the existing public 2D transform contract that source,
destination, and bias storage are disjoint. Its local read-only row aliases do
not modify input storage. Mutable tile aliases are unqualified because clearing,
copying, and transforming the tile access it through independent views.

The forward real helpers read every input into separate local vectors through
the AoS helpers before writing the possibly overlapping output. Their pointers
therefore permit overlap; the AoS read-only inputs and distinct vector outputs
can retain their qualifiers. Inverse helpers take input vectors by value and
write disjoint low/high halves. Their largest tile indices are 63 and 255,
including the four SIMD lanes, and the nested output pointers remain based on
the corresponding parent half.

For nonempty partial inputs, the high-half base is computed only when that half
contains a row. Otherwise it is a valid unused alias of the input base. Integer
row/transform cursors become pointers only at accesses, avoiding a final unused
stride past the allocation. Four-lane column groups always start between zero
and tile-width minus four, including the overlapping final partial group. This
review covers these four patched files and their direct real/AoS helper calls;
it does not establish alias correctness of every NNPACK backend.
