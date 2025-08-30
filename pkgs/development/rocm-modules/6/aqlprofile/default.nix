{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "aqlprofile";
  version = "6.4.2";

  src = fetchFromGitHub {
    # TODO: Will move to rocm-systems repo and have proper tags in 7.x
    # pinned to arbitrary working commit for now
    owner = "ROCm";
    repo = "aqlprofile";
    rev = "b20803e95dc3e9a3ffcef1f1500c4d8dd0fa3ab2";
    hash = "sha256-kaXbojl8T71nTLWJEX+g9EikwJiM1n4kXg3NFQ+Tzro=";
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
