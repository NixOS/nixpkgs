{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "aqlprofile";
  version = "6.4.3";

  src = fetchFromGitHub {
    # TODO: Will move to rocm-systems repo and have proper tags in 7.x
    # pinned to oddly named tag for now
    owner = "ROCm";
    repo = "aqlprofile";
    tag = "rocm-42";
    hash = "sha256-avL78ZfB+rJ1TYaejSUzU6i5L9JeMawMwIxaTQINQdE=";
  };

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/aqlprofile/";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
}
