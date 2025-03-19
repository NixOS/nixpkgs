{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocminfo,
  ninja,
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
  version = "6.0.2";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals (!buildRockCompiler) [
      "external"
    ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AypY0vL8Ij1zLycwpG2EPWWl4utp4ejXpAK0Jj/UvrA=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    ninja
    clr
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

  patches = [
    (fetchpatch {
      name = "fix-TosaToRock-missing-includes.patch";
      url = "https://github.com/ROCm/rocMLIR/commit/80b8c94a5dd6ab832733116fe0339c1d6011ab57.patch";
      hash = "sha256-przg1AQZTiVbVd/4wA+KlGXu/RISO5n11FBkmUFKRSA=";
    })
    (fetchpatch {
      name = "fix-cmake-depedency-on-transforms.patch";
      url = "https://github.com/ROCm/rocMLIR/commit/b85ca4855e0f0214c2fd695e493c884cf08a3472.patch";
      hash = "sha256-m108PnwvDAN3xWko+gZMgvCNFl4LXTvC67JHXhFHeBc=";
    })
  ];

  cmakeFlags =
    [
      "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
      "-DLLVM_ENABLE_ZSTD=ON"
      "-DLLVM_ENABLE_ZLIB=ON"
      "-DLLVM_ENABLE_TERMINFO=ON"
      "-DROCM_PATH=${clr}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optionals buildRockCompiler [
      "-DBUILD_FAT_LIBROCKCOMPILER=ON"
    ]
    ++ lib.optionals (!buildRockCompiler) [
      "-DROCM_TEST_CHIPSET=gfx000"
    ];

  postPatch = ''
    patchShebangs mlir
    patchShebangs external/llvm-project/mlir/lib/Dialect/GPU/AmdDeviceLibsIncGen.py

    # remove when no longer required
    substituteInPlace mlir/test/{e2e/generateE2ETest.py,fusion/e2e/generate-fusion-tests.py} \
      --replace-fail "\"/opt/rocm/bin" "\"${rocminfo}/bin"

    substituteInPlace mlir/utils/performance/common/CMakeLists.txt \
      --replace-fail "/opt/rocm" "${clr}"
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
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
    page = "tags?per_page=2";
    filter = ".[1].name | split(\"-\") | .[1]";
  };

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCm/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
