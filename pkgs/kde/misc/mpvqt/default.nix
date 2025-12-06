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
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "mpvqt";
    tag = "v${version}";
    hash = "sha256-qscubUiej/OqQI+V9gxQb7eVa3L2FJ5koqgXFoBw8tU=";
  };

  extraBuildInputs = [ qtdeclarative ];

  extraPropagatedBuildInputs = [ mpv-unwrapped ];

  extraCmakeFlags = [ "-DQt6_DIR=${qtbase}/lib/cmake/Qt6" ];

  meta = {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    license = with lib.licenses; [
      bsd2
      bsd3
      cc-by-sa-40
      cc0
      lgpl21Only
      lgpl3Only
      lgpl3Plus
      mit
    ];
  };
}
