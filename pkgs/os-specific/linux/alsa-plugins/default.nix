{ stdenv, fetchurl, lib, pkgconfig, alsaLib, libogg, pulseaudio ? null, jack2 ? null }:

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.0.28";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2"
      "http://alsa.cybermirror.org/plugins/${name}.tar.bz2"
    ];
    sha256 = "081is33afhykb4ysll8s6gh0d6nm1cglslj9ck0disbyl3qqlvs2";
  };

  # ToDo: a52, etc.?
  buildInputs =
    [ pkgconfig alsaLib libogg ]
    ++ lib.optional (pulseaudio != null) pulseaudio
    ++ lib.optional (jack2 != null) jack2;

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = http://alsa-project.org/;
    license = licenses.lgpl21;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}
