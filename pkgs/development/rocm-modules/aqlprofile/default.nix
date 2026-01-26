{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "aqlprofile";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aqlprofile";
    tag = "rocm-7.1.1";
    hash = "sha256-MAZUHo52gb0aZSFnKugMlXxcDkmMwhy1AFF1RDRgRVk=";
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
