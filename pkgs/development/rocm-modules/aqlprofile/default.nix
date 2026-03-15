{
  lib,
  stdenv,
  clr,
  cmake,
  rocmSystemsSrc,
  rocmSystemsVersion,
}:

stdenv.mkDerivation {
  pname = "aqlprofile";
  version = rocmSystemsVersion;

  src = rocmSystemsSrc;
  sourceRoot = "${rocmSystemsSrc.name}/projects/aqlprofile";

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  meta = {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/aqlprofile";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
