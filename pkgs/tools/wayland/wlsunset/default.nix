{ lib, stdenv, fetchurl, meson, pkg-config, ninja, wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wlsunset";
  version = "0.1.0";

  src = fetchurl {
    url = "https://git.sr.ht/~kennylevinsen/wlsunset/archive/${version}.tar.gz";
    sha256 = "0g7mk14hlbwbhq6nqr84452sbgcja3hdxsqf0vws4njhfjgqiv3q";
  };

  nativeBuildInputs = [ meson pkg-config ninja wayland ];
  buildInputs = [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Day/night gamma adjustments for Wayland";
    longDescription = ''
      Day/night gamma adjustments for Wayland compositors supporting
      wlr-gamma-control-unstable-v1.
    '';
    homepage = "https://sr.ht/~kennylevinsen/wlsunset/";
    changelog = "https://git.sr.ht/~kennylevinsen/wlsunset/refs/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
