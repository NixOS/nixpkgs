{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  git,
  libxml2,
  libedit,
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
  version = "6.4.3";

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
    hash = "sha256-p/gvr1Z6yZtO5N+ecSouXiCrf520jt1HMOy/tohUHfI=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    python3Packages.python
    python3Packages.tomli
  ];

  buildInputs = [
    git
    libxml2
    libedit
  ];

  propagatedBuildInputs = [
    zstd
    zlib
    ncurses
  ];

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_USE_LINKER=lld"
    "-DLLVM_ENABLE_ZSTD=FORCE_ON"
    "-DLLVM_ENABLE_ZLIB=FORCE_ON"
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DLLVM_ENABLE_TERMINFO=ON"
    "-DROCM_PATH=${clr}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    (lib.cmakeBool "BUILD_FAT_LIBROCKCOMPILER" buildRockCompiler)
  ]
  ++ lib.optionals (!buildRockCompiler) [
    "-DROCM_TEST_CHIPSET=gfx000"
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

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCm/rocMLIR";
    license = with licenses; [ asl20 ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
