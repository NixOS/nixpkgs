{ stdenv, fetchurl, lib, pkgconfig, alsaLib, libogg, libpulseaudio ? null, libjack2 ? null }:

stdenv.mkDerivation rec {
  pname = "alsa-plugins";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://alsa/plugins/${pname}-${version}.tar.bz2";
    sha256 = "0z9k3ssbfk2ky2w13avgyf202j1drsz9sv3834bp33cj1i2hc3qw";
  };

  # ToDo: a52, etc.?
  buildInputs =
    [ pkgconfig alsaLib libogg ]
    ++ lib.optional (libpulseaudio != null) libpulseaudio
    ++ lib.optional (libjack2 != null) libjack2;

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = "http://alsa-project.org/";
    license = licenses.lgpl21;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}
