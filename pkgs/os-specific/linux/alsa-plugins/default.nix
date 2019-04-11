{ stdenv, fetchurl, lib, pkgconfig, alsaLib, libogg, libpulseaudio ? null, libjack2 ? null }:

stdenv.mkDerivation rec {
  pname = "alsa-plugins";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://alsa/plugins/${pname}-${version}.tar.bz2";
    sha256 = "152r82i6f97gfilfgiax5prxkd4xlcipciv8ha8yrk452qbxyxvz";
  };

  # ToDo: a52, etc.?
  buildInputs =
    [ pkgconfig alsaLib libogg ]
    ++ lib.optional (libpulseaudio != null) libpulseaudio
    ++ lib.optional (libjack2 != null) libjack2;

  configureFlags = [
    "--with-alsalconfdir=${placeholder "out"}/etc/alsa/conf.d"
  ];

  meta = with lib; {
    description = "Various plugins for ALSA";
    homepage = http://alsa-project.org/;
    license = licenses.lgpl21;
    maintainers = [maintainers.marcweber];
    platforms = platforms.linux;
  };
}
