{
  lib,
  stdenv,
  fetchpatch,
  cmake,
  llvm,
  python3,
  rocm-device-libs,
  zlib,
  zstd,
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
  inherit (llvm.llvm) version;
  src = llvm.llvm.monorepoSrc;
  sourceRoot = "${finalAttrs.src.name}/amd/comgr";
  strictDeps = true;

  patches = [
    # [Comgr] Extend ISA compatibility
    (fetchpatch {
      hash = "sha256-dgow0kwSWM1TnkqWOZDRQrh5nuF8p5jbYyOLCpQsH4k=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/a439e4f37ce71de48d4a979594276e3be0e6278f.patch";
      relative = "amd/comgr";
    })
    #[Comgr] Extend ISA compatibility for CCOB
    (fetchpatch {
      hash = "sha256-PCi0QHLiEQCTIYRtSSbhOjXANJ3zC3VLdMED1BEfQeg=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/fa80abb77d5ae6f8d89ab956e7ebda9c802a804f.patch";
      relative = "amd/comgr";
    })
  ];

  postPatch = ''
    substituteInPlace cmake/opencl_pch.cmake \
      --replace-fail "\''${CLANG_CMAKE_DIR}/../../../" "${llvm.clang-unwrapped.lib}"
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    llvm.llvm
    llvm.clang-unwrapped
    llvm.lld
    rocm-device-libs
    zlib
    zstd
  ];

  cmakeFlags = [
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
