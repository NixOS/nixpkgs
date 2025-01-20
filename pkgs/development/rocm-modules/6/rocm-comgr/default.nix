{
  lib,
  stdenv,
  cmake,
  python3,
  rocm-merged-llvm,
  rocm-device-libs,
  zlib,
  zstd,
  libxml2,
}:

let
  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Unsupported ROCm LLVM platform";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-comgr";
  # In-tree with ROCm LLVM
  inherit (rocm-merged-llvm) version;
  src = rocm-merged-llvm.llvm-src;

  sourceRoot = "${finalAttrs.src.name}/amd/comgr";

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    rocm-device-libs
    libxml2
    zlib
    zstd
    rocm-merged-llvm
  ];

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
  ];

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/ROCm/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
