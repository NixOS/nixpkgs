{ stdenv, fetchFromGitHub, cairo, libjpeg, meson, ninja, wayland, pkgconfig, scdoc, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0brljl4zfbn5mh9hkfrfkvd27c5y9vdkgap9r1hrfy9r1x20sskn";
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
    homepage = https://github.com/emersion/grim;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
