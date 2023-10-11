{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, clang
, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipify";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "HIPIFY";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-lCQ2VTUGmFC90Xu70/tvoeDhFaInGqLT3vC2A1UojNI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libxml2 ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LLVM_TOOLS_BINARY_DIR}/clang" "${clang}/bin/clang"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  # Fixup bad symlinks
  postInstall = ''
    rm -r $out/hip/bin
    ln -s $out/bin $out/hip/bin
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "Convert CUDA to Portable C++ Code";
    homepage = "https://github.com/ROCm-Developer-Tools/HIPIFY";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
