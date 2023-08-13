{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "wl-clipboard";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${version}";
    hash = "sha256-L4k2jOZ2YtkFpDs2+LAUElYl5aNSC42QxkbMNJ2ZhWQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ];

  mesonFlags = [
    "-Dfishcompletiondir=share/fish/vendor_completions.d"
  ];

  meta = with lib; {
    homepage = "https://github.com/bugaevc/wl-clipboard";
    description = "Command-line copy/paste utilities for Wayland";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.unix;
  };
}
