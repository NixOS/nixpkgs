{ lib, stdenv, fetchFromGitHub, pixman, libpng, libjpeg, meson, ninja, wayland, pkg-config, scdoc, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lwJn1Lysv1qLauqmrduUlzdoKUrUM5uBjv+dWSsrM6w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    pixman
    libpng
    libjpeg
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Grab images from a Wayland compositor";
    homepage = "https://github.com/emersion/grim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
