{ lib, stdenv, fetchurl, meson, ninja, pkg-config, boost, libgcrypt, systemd, mpd_clientlib, curl }:

stdenv.mkDerivation rec {
  pname = "mpdscribble";
  version = "0.23";

  src = fetchurl {
    url =
    "https://www.musicpd.org/download/mpdscribble/${version}/mpdscribble-${version}.tar.xz";
    sha256 = "0s66zqscb44p88cl3kcv5jkjcqsskcnrv7xgrjhzrchf2kcpwf53";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ mpd_clientlib curl boost libgcrypt systemd ];

  meta = with lib; {
    description = "A Music Player Daemon (MPD) client which submits information about tracks being played to a scrobbler (e.g. last.fm)";
    homepage = "https://www.musicpd.org/clients/mpdscribble/";
    license = licenses.gpl2;
    maintainers = [ maintainers.sohalt ];
    platforms = platforms.linux;
  };
}
