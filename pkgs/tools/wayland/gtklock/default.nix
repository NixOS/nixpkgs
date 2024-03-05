{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, pam
, scdoc
, gtk3
, pkg-config
, gtk-layer-shell
, glib
, librsvg
, wayland
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jh+BmtKGaLgAcTXc44ydV83dp/W4wzByehUWyeyBoFI=";
  };

  nativeBuildInputs = [
    scdoc
    pkg-config
    wayland-scanner
    glib
    wrapGAppsHook
  ];

  buildInputs = [
    wayland
    gtk3
    pam
    gtk-layer-shell
    librsvg
  ];

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
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "gtklock";
  };
}
