{ lib, stdenv, fetchurl, zlib, imagemagick, libpng, glib, pkg-config, libgsf
, libxml2, bzip2
, autoreconfHook
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "wv";
  version = "1.2.9";

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "17f16lkdv1c3amaz2hagiicih59ynpp4786k1m2qa1sw68xhswsc";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ zlib imagemagick libpng glib libgsf libxml2 bzip2 ];

  configureFlags = [
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  # autoreconfHook fails hard if these two files do not exist
  postPatch = ''
    touch AUTHORS ChangeLog
  '';

  meta = {
    description = "Converter from Microsoft Word formats to human-editable ones";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2;
  };
}
