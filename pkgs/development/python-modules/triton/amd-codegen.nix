{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python,

  # The triton source tree, which holds the codegen library sources
  tritonSrc,
  tritonVersion,
}:

# Since triton 3.9.0, AMDGPU code generation lives in a standalone shared library, linked
# statically against its own (separately pinned) LLVM so its option registry stays independent
# of the LLVM used by triton's core library.
# https://github.com/triton-lang/triton/pull/11485
stdenv.mkDerivation (finalAttrs: {
  pname = "triton-amd-codegen";
  version = tritonVersion;

  __structuredAttrs = true;
  strictDeps = true;

  # See https://github.com/triton-lang/triton/blob/v3.9.0/cmake/amd-llvm-info.json
  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "llvm-project";
    rev = "6bc4aaf6641c56ee104f6200c96a6a571bc77052";
    hash = "sha256-v07CS4VudsFksZrPIjWme6FEGim7IVC8lrKRmaPPpd8=";
  };
  llvmBuildNumber = 1;

  nativeBuildInputs = [
    cmake
    ninja
    python
  ];

  # The cmake setup hook only selects Ninja when `buildPhase` is left as-is
  env.CMAKE_GENERATOR = "Ninja";

  # Mirrors the `amd-codegen` LLVM build of upstream:
  # https://github.com/triton-lang/triton/blob/v3.9.0/.github/workflows/llvm-build.yml
  cmakeDir = "../llvm";
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "AMDGPU")
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" "")
    (lib.cmakeFeature "LLVM_DISTRIBUTION_COMPONENTS" "llvm-headers;llvm-libraries;cmake-exports")
    (lib.cmakeBool "LLVM_BUILD_TOOLS" false)
    (lib.cmakeBool "LLVM_BUILD_UTILS" false)
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    (lib.cmakeBool "LLVM_INCLUDE_BENCHMARKS" false)
    (lib.cmakeBool "LLVM_INCLUDE_EXAMPLES" false)
    (lib.cmakeBool "LLVM_ENABLE_PIC" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" false)
    (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
    # Keep the resulting library self-contained
    (lib.cmakeBool "LLVM_ENABLE_ZLIB" false)
    (lib.cmakeBool "LLVM_ENABLE_ZSTD" false)
    (lib.cmakeBool "LLVM_ENABLE_LIBXML2" false)
  ];

  # The static LLVM SDK is only needed to build the codegen library, keep it out of $out
  preConfigure = ''
    appendToVar cmakeFlags "-DCMAKE_INSTALL_PREFIX=$NIX_BUILD_TOP/llvm-sdk"
  '';

  buildPhase = ''
    runHook preBuild

    ninja -j$NIX_BUILD_CORES install-distribution

    cmake -G Ninja \
      -S ${tritonSrc}/third_party/amd/backend/codegen \
      -B codegen-build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DLLVM_DIR=$NIX_BUILD_TOP/llvm-sdk/lib/cmake/llvm \
      -DTRITON_AMD_LLVM_REVISION=${finalAttrs.src.rev}-${toString finalAttrs.llvmBuildNumber}
    ninja -C codegen-build -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ninja -C codegen-build install

    runHook postInstall
  '';

  meta = {
    description = "Standalone AMDGPU code generation library for triton";
    homepage = "https://github.com/triton-lang/triton";
    license = with lib.licenses; [
      mit
      asl20
      llvm-exception
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
