{ stdenv, fetchFromGitHub, cairo, meson, ninja, wayland, pkgconfig, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "slurp-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "03igv8r8n772xb0y7whhs1pa298l3d94jbnknaxpwp2n4fi04syb";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    wayland
    wayland-protocols
  ];

  meta = with stdenv.lib; {
    description = "Grab images from a Wayland compositor";
    homepage = https://github.com/emersion/slurp;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
