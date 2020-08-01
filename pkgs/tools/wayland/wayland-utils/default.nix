{ stdenv, lib, fetchurl, pkg-config, meson, ninja, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "wayland-utils";
  version = "1.0.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1h38l850ww6hxjb1l8iwa33nkbz8q88bw6lh0aryjyp8b16crzk4";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ wayland wayland-protocols ];

  meta = {
    description = "Display supported protocols by a Wayland compositor";
    homepage = "https://gitlab.freedesktop.org/wayland/wayland-utils";
    license = lib.licenses.mit; # Expat version
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wkral ];
  };
}
