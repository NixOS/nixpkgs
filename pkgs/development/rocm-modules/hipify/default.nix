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
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPIFY";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-NbFFHAAvMGpvIryhEbktN5w03Cpay9lEqelqkUT9dpQ=";
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
    rm $out/bin/hipify-perl
    chmod +x $out/bin/*
    chmod +x $out/libexec/*
    patchShebangs $out/bin/
    patchShebangs $out/libexec/
    ln -s $out/{libexec/hipify,bin}/hipify-perl
  '';

  meta = {
    description = "Convert CUDA to Portable C++ Code";
    homepage = "https://github.com/ROCm/HIPIFY";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
