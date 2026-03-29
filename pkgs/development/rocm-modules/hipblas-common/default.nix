{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  rocm-cmake,
}:
let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/hipblas-common";
    hash = "sha256-hZqgZz9sDHXSNFCRZQ242YLZChR82c0KpBx51oflV7o=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "hipblas-common";
  inherit (source) version src sourceRoot;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rocm-cmake
  ];

  strictDeps = true;

  meta = {
    inherit (source) homepage;
    description = "Common files shared by hipBLAS and hipBLASLt";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
