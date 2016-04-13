{ stdenv, fetchurl, lib, pkgconfig, alsaLib, libogg, libpulseaudio ? null, libjack2 ? null }:

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.1.0";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2"
      "http://alsa.cybermirror.org/plugins/${name}.tar.bz2"
    ];
    sha256 = "3b83c329953bef99f5fe25ae04ec4a455fe6514939f3b45a5321966652b2c9ee";
  };

  # ToDo: a52, etc.?
  buildInputs =
    [ pkgconfig alsaLib libogg ]
    ++ lib.optional (libpulseaudio != null) libpulseaudio
    ++ lib.optional (libjack2 != null) libjack2;

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = http://alsa-project.org/;
    license = licenses.lgpl21;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}
