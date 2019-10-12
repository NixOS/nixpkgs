{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "wl-clipboard";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${version}";
    sha256 = "0c4w87ipsw09aii34szj9p0xfy0m00wyjpll0gb0aqmwa60p0c5d";
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
