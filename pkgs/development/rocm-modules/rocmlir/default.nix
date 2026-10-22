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
  version = "10.1";

  outputs = [
    "out"
  ]
  ++ lib.optionals (!buildRockCompiler) [
    "external"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    # ROCm 10.1's AMDMIGraphX requirements.txt pins
    # `ROCm/rocmlirTriton@release/rocm-rel-10.1` (-DBUILD_FAT_LIBROCKCOMPILER=On
    # -DLLVM_INCLUDE_TESTS=Off ...), which replaces the old ROCm/rocMLIR repo. It
    # has no ROCm 10.x tag, so track that branch's head commit; `version` above
    # is the ROCm-set version. passthru.updateScript (page = "tags") cannot bump
    # this until rocmlirTriton publishes a rocm-10.x tag.
    repo = "rocmlirTriton";
    rev = "f347064fea12aa0ab325e1244b65766652a2530c";
    hash = "sha256-w/eGFiXDfmY9Yog+U037mIG7wEQ9nD/m8z/2sErSuE8=";
  };

  nativeBuildInputs = [
    clr
    cmake
    rocm-cmake
    python3Packages.python
    python3Packages.tomli
    # mlir/lib/Dialect/Rock/utility/Bindings/CMakeLists.txt does find_package(pybind11);
    # without this the (buildRockCompiler) configure fails.
    python3Packages.pybind11
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
    # The rock-compiler build must build the native (host) target too, not only
    # AMDGPU: rocmlirTriton's librockcompiler_deps.cmake bundles the host codegen
    # members (LLVMX86AsmParser/CodeGen/Desc/Disassembler/Info; Triton does host
    # JIT) into the librockCompiler fat archive, so with LLVM_TARGETS_TO_BUILD=AMDGPU
    # only the archive step fails with `No rule to make target '.../LLVMX86AsmParser'`.
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "AMDGPU;${llvmNativeTarget}")
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
    # mlir/test declares the `check-rocmlir` lit suite with a DEPENDS on
    # `ci-performance-scripts`, a target only created by mlir/utils/performance,
    # which is gated behind MLIR_ENABLE_ROCM_RUNNER (= !buildRockCompiler, i.e. OFF
    # here). With MLIR tests left ON, CMake's Generate step fails with `The
    # dependency target "ci-performance-scripts" ... does not exist`. The
    # rock-compiler build only needs librockCompiler, so turn MLIR tests off
    # (LLVM_INCLUDE_TESTS above governs a different variable).
    (lib.cmakeBool "MLIR_INCLUDE_TESTS" false)
  ]
  ++ lib.optionals (!buildRockCompiler) [
    (lib.cmakeFeature "ROCM_TEST_CHIPSET" "gfx900")
  ];

  postPatch = ''
    patchShebangs mlir
    patchShebangs external/llvm-project/mlir

    substituteInPlace mlir/utils/performance/common/CMakeLists.txt \
      --replace-fail " PATHS /opt/rocm" ""
  '';

  # The source bundles Triton, whose external/triton/python/build_helpers.py
  # symlinks the pinned in-tree LLVM into $TRITON_CACHE_PATH (= $HOME/.triton) at
  # configure time. The sandbox HOME is the read-only /homeless-shelter, so give
  # the build a writable HOME (and point TRITON_CACHE_PATH at it explicitly).
  preConfigure = ''
    export HOME="$(mktemp -d)"
    export TRITON_CACHE_PATH="$HOME/.triton"
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
    lib.optionalString (!buildRockCompiler) ''
      mkdir -p $external/lib
      cp -a external/llvm-project/llvm/lib/{*.a*,*.so*} $external/lib
      patchelf --set-rpath $external/lib:$out/lib:${libPath} $external/lib/*.so*
      patchelf --set-rpath $out/lib:$external/lib:${libPath} $out/{bin/*,lib/*.so*}
    '';

  passthru.updateScript = rocmUpdateScript {
    inherit finalAttrs;
    page = "tags";
  };

  meta = {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCm/rocMLIR";
    license = lib.licenses.asl20;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
