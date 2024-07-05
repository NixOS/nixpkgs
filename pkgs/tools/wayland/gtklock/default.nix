{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, scdoc
, pkg-config
, wrapGAppsHook3
, gtk3
, pam
, gtk-session-lock
}:

stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock";
    rev = "v${version}";
    hash = "sha256-B6pySjiwPBRFb4avE9NHsS1KkWMPW81DAqYro/wtrmQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    scdoc
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    pam
    gtk-session-lock
  ];

  strictDeps = true;

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
    ''; # Following  nixpkgs/pkgs/applications/window-managers/sway/lock.nix
    homepage = "https://github.com/jovanlanik/gtklock";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya aleksana ];
    platforms = platforms.linux;
    mainProgram = "gtklock";
  };
}
