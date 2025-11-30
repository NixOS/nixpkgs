{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  git,
  guile,
  curl,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "akku";
  version = "1.1.0-unstable-2025-11-08";

  src = fetchFromGitLab {
    owner = "akkuscm";
    repo = "akku";
    rev = "411b79ffb40f5ee3b50a72c5a2d5aea97f023c93";
    sha256 = "sha256-5e4W33EnKvUoLvTsmTPp3GFZsMZp0p3wDwpD9t3clCk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # akku calls curl commands
  buildInputs = [
    guile
    curl
    git
  ];

  # Use a dummy package index to bootstrap Akku
  preBuild = ''
    touch bootstrap.db
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    homepage = "https://akkuscm.org/";
    description = "Language package manager for Scheme";
    changelog = "https://gitlab.com/akkuscm/akku/-/raw/v${version}/NEWS.md";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      nagy
      konst-aa
    ];
    mainProgram = "akku";
  };
}
