{
  lib,
  stdenv,
  fetchpatch,
  cmake,
  ninja,
  zlib,
  zstd,
  llvm,
  python3,
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
  pname = "rocm-device-libs";
  # In-tree with ROCm LLVM
  inherit (llvm.llvm) version;
  src = llvm.llvm.monorepoSrc;
  sourceRoot = "${finalAttrs.src.name}/amd/device-libs";
  strictDeps = true;
  __structuredAttrs = true;

  postPatch =
    # Use our sysrooted toolchain instead of direct clang target
    ''
      substituteInPlace cmake/OCL.cmake \
        --replace-fail '$<TARGET_FILE:clang>' "${llvm.rocm-toolchain}/bin/clang"
    '';

  patches = [
    ./cmake.patch
    (fetchpatch {
      name = "cmake-4-compat-dont-set-cmp0053.patch";
      url = "https://github.com/ROCm/llvm-project/commit/a18cc4c7cb51f94182b6018c7c73acde1b8ebddb.patch";
      hash = "sha256-kp/Ld0IhjWgRbRR9R/CKdkI9ELvPkQSAMqPsAPFxzhM=";
      relative = "amd/device-libs";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
    llvm.rocm-toolchain
  ];

  buildInputs = [
    llvm.llvm
    llvm.clang-unwrapped
    zlib
    zstd
  ];

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
  ];

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/ROCm/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
