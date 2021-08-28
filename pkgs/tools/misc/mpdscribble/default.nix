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
  version = "0.23";

  src = fetchurl {
    url = "https://www.musicpd.org/download/mpdscribble/${version}/mpdscribble-${version}.tar.xz";
    sha256 = "0s66zqscb44p88cl3kcv5jkjcqsskcnrv7xgrjhzrchf2kcpwf53";
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
