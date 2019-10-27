{ stdenv, fetchurl, pkgconfig, fuse, glib, attr }:

stdenv.mkDerivation rec {
  name = "ciopfs-0.4";

  src = fetchurl {
    url = "http://www.brain-dump.org/projects/ciopfs/${name}.tar.gz";
    sha256 = "0sr9i9b3qfwbfvzvk00yrrg3x2xqk1njadbldkvn7hwwa4z5bm9l";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse glib attr ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    homepage = http://www.brain-dump.org/projects/ciopfs/;
    description = "A case-insensitive filesystem layered on top of any other filesystem";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
