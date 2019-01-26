{ stdenv, fetchFromGitHub, cairo, libjpeg, meson, ninja, wayland, pkgconfig, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "grim-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "grim";
    rev = "v${version}";
    sha256 = "1mpmxkzssgzqh9z263y8vk40dayw32kah66sb8ja7yw22rm7f4zf";
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
