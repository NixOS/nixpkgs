{ lib, stdenv, fetchFromGitHub, cairo, libjpeg, meson, ninja, wayland, pkg-config, scdoc, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-71dmYENfPX8YHcTlR2F67EheoewicePMKm9/wPbmj9A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cairo
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
