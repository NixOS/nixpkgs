<<<<<<< HEAD
{ fetchFromGitLab
, installShellFiles
, lib
, python3
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvd";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = "nvd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-TmaXsyJLRkmIN9D77jOXd8fLj7kYPCBLg0AHIImAtgA=";
  };

  buildInputs = [
    python3
  ];

  nativeBuildInputs = [
    installShellFiles
  ];
=======
{ fetchFromGitLab, installShellFiles, lib, python3, stdenv }:

stdenv.mkDerivation rec {
  pname = "nvd";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "khumba";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-kOPcQP2tSym69qSOBwVc2XFO8+uy7bgYIQq4L/orS+A=";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [ installShellFiles ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin src/nvd
    installManPage src/nvd.1
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://gitlab.com/khumba/nvd";
    license = lib.licenses.asl20;
    mainProgram = "nvd";
    maintainers = with lib.maintainers; [ khumba ];
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://gitlab.com/khumba/nvd";
    license = licenses.asl20;
    maintainers = with maintainers; [ khumba ];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
