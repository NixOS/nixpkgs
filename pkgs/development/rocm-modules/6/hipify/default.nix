{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  clang,
  libxml2,
  rocm-merged-llvm,
  zlib,
  zstd,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipify";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPIFY";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-o/1LNsNtAyQcSug1gf7ujGNRRbvC33kwldrJKZi2LA0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libxml2
    rocm-merged-llvm
    zlib
    zstd
    perl
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LLVM_TOOLS_BINARY_DIR}/clang" "${clang}/bin/clang"
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
