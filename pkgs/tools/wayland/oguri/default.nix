{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  cairo,
  gdk-pixbuf,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "oguri";
  version = "unstable-2020-12-19";

  src = fetchFromGitHub {
    owner = "vilhalmer";
    repo = pname;
    rev = "6937fee10a9b0ef3ad8f94f606c0e0d9e7dec564";
    sha256 = "sXNvpI/YPDPd2cXQAfRO4ut21gSCXxbo1DpaZmHJDYQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    cairo
    gdk-pixbuf
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    homepage = "https://github.com/vilhalmer/oguri/";
    description = "Very nice animated wallpaper daemon for Wayland compositors";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin; # this should be enfoced by wayland platforms in the future
  };
}
