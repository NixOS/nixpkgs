{ lib, stdenv, fetchurl, opensp, perl }:

stdenv.mkDerivation rec {
  pname = "openjade";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/openjade/openjade-${version}.tar.gz";
    sha256 = "1l92sfvx1f0wmkbvzv1385y1gb3hh010xksi1iyviyclrjb7jb8x";
  };

  patches = [ ./msggen.patch ];

  buildInputs = [ opensp perl ];

  configureFlags = [
    "--enable-spincludedir=${opensp}/include/OpenSP"
    "--enable-splibdir=${opensp}/lib"
  ];

  meta = {
    description = "An implementation of DSSSL, an ISO standard for formatting SGML (and XML) documents";
    mainProgram = "openjade";
    license = lib.licenses.mit;
    homepage = "https://openjade.sourceforge.net/";
    platforms = lib.platforms.linux;
  };
}
