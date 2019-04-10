{ stdenv, fetchFromGitHub, cairo, libjpeg, meson, ninja, wayland, pkgconfig, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "grim-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "grim";
    rev = "v${version}";
    sha256 = "1bcvkggqszcwy6hg8g4mch3yr25ic0baafbd90af5s5mrhrjxxxz";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    libjpeg
    wayland
    wayland-protocols
  ];

  meta = with stdenv.lib; {
    description = "Grab images from a Wayland compositor";
    homepage = https://github.com/emersion/grim;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
