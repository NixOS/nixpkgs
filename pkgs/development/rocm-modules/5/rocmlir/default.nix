{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, ninja
, clr
, git
, libxml2
, libedit
, zstd
, zlib
, ncurses
, python3Packages
, buildRockCompiler ? false
, buildTests ? false # `argument of type 'NoneType' is not iterable`
}:

# Theoretically, we could have our MLIR have an output
# with the source and built objects so that we can just
# use it as the external LLVM repo for this
let
  suffix =
    if buildRockCompiler
    then "-rock"
    else "";

  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocmlir${suffix}";
  version = "5.7.0";

  outputs = [
    "out"
  ] ++ lib.optionals (!buildRockCompiler) [
    "external"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-vPi4UVljohVAfnwDVQqeOVaJPa6v8aV5uBOtqLddTtc=";
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

  cmakeFlags = [
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
  ] ++ lib.optionals buildRockCompiler [
    "-DBUILD_FAT_LIBROCKCOMPILER=ON"
  ] ++ lib.optionals (!buildRockCompiler) [
    "-DROCM_TEST_CHIPSET=gfx000"
  ];

  postPatch = ''
    patchShebangs mlir

    substituteInPlace mlir/utils/performance/common/CMakeLists.txt \
      --replace "/opt/rocm" "${clr}"
  '';

  dontBuild = true;
  doCheck = true;

  # Certain libs aren't being generated, try enabling tests next update
  checkTarget = if buildRockCompiler
                then "librockCompiler"
                else if buildTests
                then "check-rocmlir"
                else "check-rocmlir-build-only";

  postInstall = let
    libPath = lib.makeLibraryPath [ zstd zlib ncurses clr stdenv.cc.cc ];
  in lib.optionals (!buildRockCompiler) ''
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
    homepage = "https://github.com/ROCmSoftwarePlatform/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
