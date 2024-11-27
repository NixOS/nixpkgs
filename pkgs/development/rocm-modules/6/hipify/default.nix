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
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPIFY";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-4tM64z4mDVg9O3MP4bZmk0meOZ8HoQ92l/s+xsjDo5s=";
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

  postInstall = ''
    patchShebangs $out/bin
  '';

  meta = with lib; {
    description = "Convert CUDA to Portable C++ Code";
    homepage = "https://github.com/ROCm/HIPIFY";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
