{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "wl-clipboard";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${version}";
    sha256 = "03h6ajcc30w6928bkd4h6xfj4iy2359ww6hdlybq8mr1zwmb2h0q";
  };

  nativeBuildInputs = [ meson ninja pkgconfig wayland-protocols ];
  buildInputs = [ wayland ];

  meta = with stdenv.lib; {
    description = "Command-line copy/paste utilities for Wayland";
    homepage = https://github.com/bugaevc/wl-clipboard;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
