{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  qtwebsockets,
  kdeclarative,
  kpackage,
}:
mkKdeDerivation {
  pname = "kunifiedpush";
  version = "unstable-2024-02-19";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kunifiedpush";
    rev = "b89a31fb4f333a4e5d6c475a030147c8bdcffec6";
    hash = "sha256-bhlsEP7cLuA6Rj6nrpp5iC3uolc02twNMLsWl+d/BXo=";
  };

  extraBuildInputs = [qtwebsockets kdeclarative kpackage];

  meta.license = with lib.licenses; [bsd2 bsd3 cc0 lgpl2Plus];
  meta.mainProgram = "kunifiedpush-distributor";
}
