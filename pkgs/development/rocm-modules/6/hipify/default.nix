{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  llvm,
  zlib,
  zstd,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipify";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPIFY";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uj25WmGCpwouS1yzW9Oil5Vyrbyj5yRITvWF9WaGozM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    perl
    llvm.rocm-toolchain
  ];

  buildInputs = [
    llvm.llvm
    llvm.clang-unwrapped
    perl
    zlib
    zstd
  ];

  env.CXXFLAGS = "-I${lib.getInclude llvm.llvm}/include -I${lib.getInclude llvm.clang-unwrapped}/include";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${LLVM_TOOLS_BINARY_DIR}/clang" "${llvm.rocm-toolchain}/bin/clang"
    chmod +x bin/*
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  postInstall = ''
    chmod +x $out/bin/*
    chmod +x $out/libexec/*
    patchShebangs $out/bin/
    patchShebangs $out/libexec/
  '';

  meta = with lib; {
    description = "Convert CUDA to Portable C++ Code";
    homepage = "https://github.com/ROCm/HIPIFY";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
