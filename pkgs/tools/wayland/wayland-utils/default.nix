{ lib, stdenv, fetchurl
, meson, pkg-config, ninja, wayland-scanner
, wayland, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wayland-utils";
  version = "1.0.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1h38l850ww6hxjb1l8iwa33nkbz8q88bw6lh0aryjyp8b16crzk4";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson pkg-config ninja wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Wayland utilities (wayland-info)";
    longDescription = ''
      A collection of Wayland related utilities:
      - wayland-info: A utility for displaying information about the Wayland
        protocols supported by a Wayland compositor.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/wayland-utils";
    license = licenses.mit; # Expat version
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
