{ lib
, stdenvNoCC
, fetchFromGitHub
<<<<<<< HEAD
, unstableGitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
<<<<<<< HEAD
  version = "unstable-2023-08-24";
=======
  version = "unstable-2023-04-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
<<<<<<< HEAD
    rev = "45c051dad0e243a63608c8274b7fddd5f0b74941";
    hash = "sha256-kpE+vgobYsQuh8sS3gK/yg68nQykquwteeuecjLtIrE=";
=======
    rev = "724f89c330dc5b93a2fde29f732cbd5b8d73785c";
    hash = "sha256-aCLFbxVE8/hWsPNPLt2Qn8CaBkYJJLSDgpl6LYvFVYc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

    runHook postInstall
  '';

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "A place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
