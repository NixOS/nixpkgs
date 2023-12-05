{ lib, stdenv, fetchurl, libdvdread, libdvdcss }:

stdenv.mkDerivation rec {
  pname = "vobcopy";
  version = "1.2.0";

  src = fetchurl {
    url = "http://www.vobcopy.org/download/vobcopy-${version}.tar.bz2";
    sha256 = "01l1yihbd73srzghzzx5dgfg3yfb5kml5dix52mq0snhjp8h89c9";
  };

  buildInputs = [libdvdread libdvdcss];
  makeFlags   = [ "DESTDIR=$(out)" "PREFIX=/" ];

  meta = {
    description = "Copies DVD .vob files to harddisk, decrypting them on the way";
    homepage = "http://vobcopy.org/projects/c/c.shtml";
    license = lib.licenses.gpl2;

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
    mainProgram = "vobcopy";
  };
}
