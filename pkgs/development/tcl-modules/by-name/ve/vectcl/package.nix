{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
}:

mkTclDerivation rec {
  pname = "vectcl";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "auriocus";
    repo = "VecTcl";
    tag = "v${version}";
    hash = "sha256-nPs16Jy6KMEdupWJNhgYqosuW5Dlpb/dxxTrLpRbYf0=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -std=gnu17";

  meta = {
    homepage = "https://auriocus.github.io/VecTcl/";
    description = "Numeric array and linear algebra extension for Tcl";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.tcltk;
  };
}
