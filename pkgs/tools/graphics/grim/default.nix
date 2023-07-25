{ lib
, stdenv
, fetchFromSourcehut
, pixman
, libpng
, libjpeg
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.4.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5csJqRLNqhyeXR4dEQtnPUSwuZ8oY+BIt6AVICkm1+o=";
  };

  mesonFlags = [
    "-Dwerror=false"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
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
