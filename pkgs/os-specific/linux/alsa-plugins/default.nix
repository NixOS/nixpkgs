{ stdenv, fetchurl, lib, pkgconfig, alsaLib, pulseaudio ? null, jackaudio ? null }:

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.0.25";

  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2";
    sha256 = "1assar5k8zb2srqdcph6a54daqfymlyygdm5fcs6isaydpyp9qx0";
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
