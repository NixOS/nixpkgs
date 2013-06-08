{ stdenv, fetchurl, lib, pkgconfig, alsaLib, pulseaudio ? null, jackaudio ? null }:

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.0.26";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2"
      "http://alsa.cybermirror.org/plugins/${name}.tar.bz2"
    ];
    sha256 = "07wz3kl6isabk15ddpzz820pqlgvw6q0m7knnbgv9780s8s52l83";
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
