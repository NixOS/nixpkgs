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
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPIFY";
    tag = "therock-${lib.versions.majorMinor finalAttrs.version}";
    hash = "sha256-Ayw+jfXmeK9XDy1C+cmalTIDStvr6kGY2n78x5b2KYk=";
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

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

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
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
