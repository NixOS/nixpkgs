{ stdenv, fetchurl, zlib, libtiff, libxml2, SDL, xproto, libX11
, libXi, inputproto, libXmu, libXext, xextproto, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "stardust-${version}";
  version = "0.1.13";

  src = fetchurl {
    url = "http://iwar.free.fr/IMG/gz/${name}.tar.gz";
    sha256 = "19rs9lz5y5g2yiq1cw0j05b11digw40gar6rw8iqc7bk3s8355xp";
  };

  buildInputs = [
    zlib libtiff libxml2 SDL xproto libX11 libXi inputproto
    libXmu libXext xextproto libGLU_combined
  ];

  installFlags = [ "bindir=\${out}/bin" ];

  hardeningDisable = [ "format" ];

  postConfigure = ''
    substituteInPlace config.h \
      --replace '#define PACKAGE ""' '#define PACKAGE "stardust"'
  '';

  meta = with stdenv.lib; {
    description = "Space flight simulator";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
