{ lib, stdenv, fetchurl, zlib, imagemagick, libpng, glib, pkg-config, libgsf
, libxml2, bzip2 }:

stdenv.mkDerivation rec {
  pname = "wv";
  version = "1.2.9";

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "17f16lkdv1c3amaz2hagiicih59ynpp4786k1m2qa1sw68xhswsc";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib imagemagick libpng glib libgsf libxml2 bzip2 ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Converter from Microsoft Word formats to human-editable ones";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2;
  };
}
