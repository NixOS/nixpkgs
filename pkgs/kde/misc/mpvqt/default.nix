{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  mpv-unwrapped,
  qtdeclarative,
}:
mkKdeDerivation rec {
  pname = "mpvqt";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "mpvqt";
    rev = "v${version}";
    hash = "sha256-XHiCxH7dJxJamloM2SJbiFHDt8j4rVfv/M9PaBzvgM4=";
  };

  extraBuildInputs = [qtdeclarative];
  extraPropagatedBuildInputs = [mpv-unwrapped];

  meta.license = with lib.licenses; [bsd2 bsd3 cc-by-sa-40 cc0 lgpl21Only lgpl3Only lgpl3Plus mit];
}
