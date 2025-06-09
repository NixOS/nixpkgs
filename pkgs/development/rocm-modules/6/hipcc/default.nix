{
  lib,
  stdenv,
  rocm-merged-llvm,
  cmake,
  lsb-release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipcc";
  # In-tree with ROCm LLVM
  inherit (rocm-merged-llvm) version;
  src = rocm-merged-llvm.llvm-src;
  sourceRoot = "${finalAttrs.src.name}/amd/hipcc";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rocm-merged-llvm ];

  patches = [
    # https://github.com/ROCm/llvm-project/pull/183
    # Fixes always-invoked UB in hipcc
    ./0001-hipcc-Remove-extra-definition-of-hipBinUtilPtr_-in-d.patch
  ];

  postPatch = ''
    substituteInPlace src/hipBin_amd.h \
      --replace-fail "/usr/bin/lsb_release" "${lsb-release}/bin/lsb_release"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];
  postInstall = ''
    rm -r $out/hip/bin
    ln -s $out/bin $out/hip/bin
  '';

  meta = with lib; {
    description = "Compiler driver utility that calls clang or nvcc";
    homepage = "https://github.com/ROCm/HIPCC";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
