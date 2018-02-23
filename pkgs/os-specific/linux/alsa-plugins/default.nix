{ config, stdenv, fetchurl, lib, pkgconfig, alsaLib, libogg
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, jackSupport ? stdenv.isLinux, libjack2 ? null }:

assert pulseaudioSupport -> libpulseaudio != null;
assert jackSupport -> libjack2 != null;

stdenv.mkDerivation rec {
  name = "alsa-plugins-1.1.5";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/plugins/${name}.tar.bz2"
      "http://alsa.cybermirror.org/plugins/${name}.tar.bz2"
    ];
    sha256 = "073zpgvj4pldmzqq97l40wngvbqnvrkc8yw153mgny9kypwaazbr";
  };

  # ToDo: a52, etc.?
  buildInputs =
    [ pkgconfig alsaLib libogg ]
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional jackSupport libjack2;

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = http://alsa-project.org/;
    license = licenses.lgpl21;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}
