{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  meson,
  ninja,
  boost,
  curl,
  libgcrypt,
  libmpdclient,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "mpdscribble";
  version = "0.24";

  src = fetchurl {
    url = "https://www.musicpd.org/download/mpdscribble/${version}/mpdscribble-${version}.tar.xz";
    sha256 = "sha256-9rTLp0izuH5wUnC0kjyOI+lMLgD+3VC+sUaNvi+yqOc=";
  };

  # Fix build issue on darwin; to be removed after the next release
  patches = [
    (fetchpatch {
      name = "remove-empty-static-lib.patch";
      url = "https://github.com/MusicPlayerDaemon/mpdscribble/commit/0dbcea25c81f3fdc608f71ef71a9784679fee17f.patch";
      sha256 = "sha256-3wLfQvbwx+OFrCl5vMV7Zps4e4iEYFhqPiVCo5hDqgw=";
    })
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i src/Log.cxx # gcc12
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    libmpdclient
    curl
    boost
    libgcrypt
  ] ++ lib.optional stdenv.isLinux systemd;

  meta = with lib; {
    description = "A MPD client which submits info about tracks being played to a scrobbler";
    homepage = "https://www.musicpd.org/clients/mpdscribble/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sohalt ];
    platforms = platforms.unix;
    mainProgram = "mpdscribble";
  };
}
