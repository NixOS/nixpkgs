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
      hash = "sha256-X2VPGigK582J+a/u2Kg74w25/+CTpVWU9D3Eqgnb2PU=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/7002dc04863d38c57cfd2e6fc60a1cf5a613fd8e.patch";
      relative = "amd/comgr";
    })
    # [Comgr] Extend ISA compatibility for CCOB
    (fetchpatch {
      hash = "sha256-/50I+PqxL3oaQMqg5vR7+ibUcXO1SvfXBdw/sybRt1o=";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/2c1e44fc3eacadcafdd4ada3e3184a092b6f26c5.patch";
      relative = "amd/comgr";
    })
    # Fix: CCOB compat patch used coerced (featureless) name for output filename,
    # causing CLR's code_obj_map key to miss when looking up device ISA with features
    ./fix-ccob-compat-output-filename.patch
  ];

  postPatch =
    # Fix relative path assumption for libllvm
    ''
      substituteInPlace cmake/opencl_header.cmake \
        --replace-fail "\''${CLANG_CMAKE_DIR}/../../../" "${llvm.clang-unwrapped.lib}"
    ''
    # Bake LLVM root for cfg/includes or HIPRTC can't find C++ stdlib headers (e.g. <type_traits>).
    + ''
      substituteInPlace src/comgr-env.cpp \
        --replace-fail \
          'return EnvLLVMPath;' \
          'return EnvLLVMPath ? EnvLLVMPath : "${llvm.rocm-toolchain}";'
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

  meta = {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/ROCm/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
