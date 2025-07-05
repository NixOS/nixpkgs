{
  lib,
  stdenv,
  fetchpatch,
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

  patches = [
    # [Comgr] Extend ISA compatibility
    (fetchpatch {
      sha256 = "sha256-dgow0kwSWM1TnkqWOZDRQrh5nuF8p5jbYyOLCpQsH4k=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/a439e4f37ce71de48d4a979594276e3be0e6278f.patch";
      relative = "amd/comgr";
    })
    #[Comgr] Extend ISA compatibility for CCOB
    (fetchpatch {
      sha256 = "sha256-6Rwz12Lk4R2JK3olii3cr2Zd0ZLYe7VSpK1YRCOsJWY=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/2d8c459a4d4c0567a7a275b4b54560d88e5c6919.patch";
      relative = "amd/comgr";
    })
  ];

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
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
