{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  clr,
  cmake,
}:

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/aqlprofile";
    hash = "sha256-Lb4VToGEvFi9UEb89GNzeTFQA4Zm3mx4zYi8EZnrZZ4=";
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
  pname = "aqlprofile";
  inherit (source) version src sourceRoot;

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  meta = {
    inherit (source) homepage;
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
