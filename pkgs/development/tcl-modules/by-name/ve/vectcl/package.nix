{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  tcl,
}:

mkTclDerivation rec {
  pname = "vectcl";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "auriocus";
    repo = "VecTcl";
    tag = "v${version}";
    hash = "sha256-h+v0CnxS4Br/px9FDd59t/ijAdAS4XhFBlYjaTgQ26k=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -std=gnu17";

  meta = {
    homepage = "https://auriocus.github.io/VecTcl/";
    description = "Numeric array and linear algebra extension for Tcl";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.tcltk;
    broken = tcl.isTcl9;
  };
}
