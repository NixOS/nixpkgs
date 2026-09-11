{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  git,
  guile_3_0,
  curl,
  nix-update-script,
}:
let
  # Akku currently breaks starting with Guile 3.0.11.
  # So we pin Guile 3.0.10 for now.
  # https://hydra.nixos.org/build/319214800/nixlog/1/tail
  guile_3_0_10 = guile_3_0.overrideAttrs {
    src = fetchurl {
      url = "mirror://gnu/guile/guile-3.0.10.tar.xz";
      sha256 = "sha256-vXFoUX/VJjM0RtT3q4FlJ5JWNAlPvTcyLhfiuNjnY4g=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "akku";
  version = "1.1.0-unstable-2026-07-08";

  src = fetchFromGitLab {
    owner = "akkuscm";
    repo = "akku";
    rev = "43bc5fb8df0fc0907568a1a072ebc48b90a43933";
    sha256 = "sha256-42QQIcWK2dnYZ4zrOh7k8JJe14VgoNI89YYCywtpueo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # akku calls curl commands
  buildInputs = [
    guile_3_0_10
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

  meta = {
    homepage = "https://akkuscm.org/";
    description = "Language package manager for Scheme";
    changelog = "https://gitlab.com/akkuscm/akku/-/raw/v${version}/NEWS.md";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nagy
      konst-aa
    ];
    mainProgram = "akku";
  };
}
