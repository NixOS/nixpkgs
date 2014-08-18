{ stdenv, fetchurl, lib, pkgconfig, alsaLib, pulseaudio ? null, jackaudio ? null }:

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.0.27";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2"
      "http://alsa.cybermirror.org/plugins/${name}.tar.bz2"
    ];
    sha256 = "0ddbycq4cn9mc8xin0vh1af0zywz2rc2xyrs6qbayyyxq8vhrg8b";
  };

  buildInputs =
    [ pkgconfig alsaLib ]
    ++ stdenv.lib.optional (pulseaudio != null) pulseaudio
    ++ stdenv.lib.optional (jackaudio != null) jackaudio;

  meta = { 
    description = "Various plugins for ALSA";
    homepage = http://alsa-project.org/;
    license = "GPL2.1";
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.linux;
  };
}
