{ lib, stdenv, fetchurl, pkg-config, fuse, glib, attr }:

stdenv.mkDerivation rec {
  pname = "ciopfs";
  version = "0.4";

  src = fetchurl {
    url = "http://www.brain-dump.org/projects/ciopfs/ciopfs-${version}.tar.gz";
    sha256 = "0sr9i9b3qfwbfvzvk00yrrg3x2xqk1njadbldkvn7hwwa4z5bm9l";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse glib attr ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    homepage = "https://www.brain-dump.org/projects/ciopfs/";
    description = "A case-insensitive filesystem layered on top of any other filesystem";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
