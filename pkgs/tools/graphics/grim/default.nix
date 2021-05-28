{ stdenv, fetchFromGitHub, cairo, libjpeg, meson, ninja, wayland, pkgconfig, scdoc, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fjmjq0ws9rlblkcqxxw2lv7zvvyi618jqzlnz5z9zb477jwdfib";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    scdoc
  ];

  buildInputs = [
    cairo
    libjpeg
    wayland
    wayland-protocols
  ];

  meta = with stdenv.lib; {
    description = "Grab images from a Wayland compositor";
    homepage = "https://github.com/emersion/grim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
