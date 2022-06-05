{ lib
, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, boost
, curl
, libgcrypt
, libmpdclient
, systemd
}:

stdenv.mkDerivation rec {
  pname = "mpdscribble";
  version = "0.24";

  src = fetchurl {
    url = "https://www.musicpd.org/download/mpdscribble/${version}/mpdscribble-${version}.tar.xz";
    sha256 = "sha256-9rTLp0izuH5wUnC0kjyOI+lMLgD+3VC+sUaNvi+yqOc=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    libmpdclient
    curl
    boost
    libgcrypt
    systemd
  ];

  meta = with lib; {
    description = "A MPD client which submits info about tracks being played to a scrobbler";
    homepage = "https://www.musicpd.org/clients/mpdscribble/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sohalt ];
    platforms = platforms.linux;
  };
}
