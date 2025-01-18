{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
}:
mkKdeDerivation {
  pname = "alpaka";
  version = "unstable-2024-02-27";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "alpaka";
    rev = "64ef70f062920e2d62b5a9337485ccbf0eb86b97";
    hash = "sha256-YDn86+byjvCK525EQsGTCKf88Ovhvii848nTJHGP1bg=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    gpl2Only
    gpl2Plus
    gpl3Only
  ];
  meta.mainProgram = "alpaka";
}
