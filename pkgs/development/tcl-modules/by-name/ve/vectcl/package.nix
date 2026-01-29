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

  makeFlags = [
    "CFLAGS=-Wno-implicit-function-declaration"
  ];

  meta = {
    homepage = "https://auriocus.github.io/VecTcl/";
    description = "Numeric array and linear algebra extension for Tcl";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.tcltk;
  };
}
