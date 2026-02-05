{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  libxml2,
  libedit,
  rocm-comgr,
  rocm-device-libs,
  rocm-runtime,
  zstd,
  zlib,
  ncurses,
  python3Packages,
  buildRockCompiler ? false,
  buildTests ? false, # `argument of type 'NoneType' is not iterable`
}:

# FIXME: rocmlir has an entire separate LLVM build in a subdirectory this is silly
# It seems to be forked from AMD's own LLVM
# If possible reusing the rocmPackages.llvm build would be better
# Would have to confirm it is compatible with ROCm's tagged LLVM.
# Fairly likely it's not given AMD's track record with forking their own software in incompatible ways
# in subdirs

# Theoretically, we could have our MLIR have an output
# with the source and built objects so that we can just
# use it as the external LLVM repo for this
let
  suffix = if buildRockCompiler then "-rock" else "";

  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Unsupported ROCm LLVM platform";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocmlir${suffix}";
  version = "7.1.1";

  outputs = [
    "out"
  ]
  ++ lib.optionals (!buildRockCompiler) [
    "external"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-A9vUvsEZrZlNEW4cscF66L48rJQ1zJYmIzwXQ2QzJ3s=";
  };

  nativeBuildInputs = [
    clr
    cmake
    rocm-cmake
    python3Packages.python
    python3Packages.tomli
  ];

  buildInputs = [
    libxml2
    libedit
    rocm-comgr
    rocm-runtime
    rocm-device-libs
  ];

  propagatedBuildInputs = [
    zstd
    zlib
    ncurses
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "AMDGPU${
      lib.optionalString (!buildRockCompiler) ";${llvmNativeTarget}"
    }")
    (lib.cmakeFeature "LLVM_USE_LINKER" "lld")
    (lib.cmakeFeature "LLVM_ENABLE_ZSTD" "FORCE_ON")
    (lib.cmakeFeature "LLVM_ENABLE_ZLIB" "FORCE_ON")
    (lib.cmakeBool "LLVM_ENABLE_LIBCXX" true)
    (lib.cmakeBool "LLVM_ENABLE_TERMINFO" true)
    (lib.cmakeFeature "ROCM_PATH" "${clr}")
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeBool "MLIR_ENABLE_ROCM_RUNNER" (!buildRockCompiler))
    (lib.cmakeBool "BUILD_FAT_LIBROCKCOMPILER" buildRockCompiler)
  ]
  ++ lib.optionals buildRockCompiler [
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
  ]
  ++ lib.optionals (!buildRockCompiler) [
    (lib.cmakeFeature "ROCM_TEST_CHIPSET" "gfx900")
  ];

  postPatch = ''
    patchShebangs mlir
    patchShebangs external/llvm-project/mlir/lib/Dialect/GPU/AmdDeviceLibsIncGen.py

    # Fixes mlir/lib/Analysis/BufferDependencyAnalysis.cpp:41:19: error: redefinition of 'read'
    substituteInPlace mlir/lib/Analysis/BufferDependencyAnalysis.cpp \
      --replace-fail "enum EffectType { read, write, unknown };" "enum class EffectType { read, write, unknown };"

    substituteInPlace mlir/utils/performance/common/CMakeLists.txt \
      --replace-fail " PATHS /opt/rocm" ""
  '';

  dontBuild = true;
  doCheck = true;

  # Certain libs aren't being generated, try enabling tests next update
  checkTarget =
    if buildRockCompiler then
      "librockCompiler"
    else if buildTests then
      "check-rocmlir"
    else
      "check-rocmlir-build-only";

  postInstall =
    let
      libPath = lib.makeLibraryPath [
        zstd
        zlib
        ncurses
        clr
        stdenv.cc.cc
      ];
    in
    lib.optionals (!buildRockCompiler) ''
      mkdir -p $external/lib
      cp -a external/llvm-project/llvm/lib/{*.a*,*.so*} $external/lib
      patchelf --set-rpath $external/lib:$out/lib:${libPath} $external/lib/*.so*
      patchelf --set-rpath $out/lib:$external/lib:${libPath} $out/{bin/*,lib/*.so*}
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
    page = "tags?per_page=4";
  };

  meta = {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCm/rocMLIR";
    license = with lib.licenses; [ asl20 ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
