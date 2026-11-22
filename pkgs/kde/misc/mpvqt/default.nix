{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  mpv-unwrapped,
  qtdeclarative,
  qtbase,
}:

mkKdeDerivation rec {
  pname = "mpvqt";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "mpvqt";
    tag = "v${version}";
    hash = "sha256-R9EkJPAiYwq206TJRDLpx/RcfeI0tDSXk1/KrRoASLU=";
  };

  extraBuildInputs = [ qtdeclarative ];

  extraPropagatedBuildInputs = [ mpv-unwrapped ];

  extraCmakeFlags = [ "-DQt6_DIR=${qtbase}/lib/cmake/Qt6" ];

  meta.license = with lib.licenses; [
    bsd2
    bsd3
    cc-by-sa-40
    cc0
    lgpl21Only
    lgpl3Only
    lgpl3Plus
    mit
  ];
}
