{
  stdenv,
  src,
  nnpackPatch,
}:

stdenv.mkDerivation {
  name = "torch-nnpack-psimd-test";
  # Test the actual vendored sources without compiling or copying all of Torch.
  srcs = [
    "${src}/third_party/NNPACK"
    "${src}/third_party/psimd"
  ];
  sourceRoot = ".";
  patches = [ nnpackPatch ];
  patchFlags = [ "-p2" ];

  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    mkdir -p results include/psimd/fft
    printf '#include "%s"\n' ${./nnpack-input-pointers.h} > include/psimd/fft/real.h
    commonFlags=(
      -std=c11 -Wall -Wextra -DNNP_INFERENCE_ONLY=0
      -Iinclude "-DNNPACK_REAL_HEADER=\"$PWD/NNPACK/src/psimd/fft/real.h\""
      -Ipsimd/include -INNPACK/include -INNPACK/src
    )
    export LC_ALL=C ASAN_OPTIONS=detect_leaks=1:halt_on_error=1
    export UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
    "$CC" --version > results/compiler.txt
    set -o pipefail
    for variant in optimized sanitized; do
      flags=(-O3)
      if [[ $variant == sanitized ]]; then
        flags=(-O2 -fsanitize=address,undefined -fno-omit-frame-pointer)
      fi
      (
        set -x
        "$CC" "''${flags[@]}" "''${commonFlags[@]}" ${./nnpack-psimd.c} \
          NNPACK/src/psimd/2d-fourier-{8x8,16x16}.c -lm -o "$variant"
      ) 2>&1 | tee "results/$variant-compile.log"
      ./"$variant" | tee "results/$variant.json"
    done
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp results/* "$out/"
    runHook postInstall
  '';
}
