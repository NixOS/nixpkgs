{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, cairo
, glib
, libxkbcommon
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "wlr-which-key";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-DedmLWjK0a6AoGaKGRKfsmK/NIAFV2EYY8MgfiEj4+o=";
  };

  cargoHash = "sha256-ZGaQX5raMSCwt88xhctwCxGWa9HZtcNqTKM35Z8QvAc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    libxkbcommon
    pango
  ];

  meta = with lib; {
    description = "Keymap manager for wlroots-based compositors";
    homepage = "https://github.com/MaxVerevkin/wlr-which-key";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xlambein ];
    platforms = platforms.linux;
    mainProgram = "wlr-which-key";
  };
}
