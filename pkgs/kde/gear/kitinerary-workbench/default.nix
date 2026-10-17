{
  fetchFromGitLab,
  lib,
  mkKdeDerivation,
}:

mkKdeDerivation {
  pname = "kitinerary-workbench";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "pim";
    repo = "kitinerary-workbench";
    rev = "d6b87d36c8de216cc64c9dd756532657bd4d2818";
    hash = "sha256-JPf783CbwRigZCU7IEQbQbOSj3ue2592O8GDKohp4ug=";
  };

  meta.mainProgram = "kitinerary-workbench";
}
