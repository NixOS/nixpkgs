{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "aqlprofile";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aqlprofile";
    tag = "rocm-7.0.2";
    hash = "sha256-A17SAkEUf3yAGwvZUWSdL7Tn5YAXB0YlD3T1DLTjDSg=";
  };

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  meta = {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/aqlprofile/";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
