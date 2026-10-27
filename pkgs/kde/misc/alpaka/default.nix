{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
}:
mkKdeDerivation {
  pname = "alpaka";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "alpaka";
    rev = "443f7f923e9512a3aa765d68bbe7da04d25adb47";
    hash = "sha256-ovKP/yMZPmZ1YCQHwQwNqded0o0z67Ub+1RrPnd99XU=";
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
