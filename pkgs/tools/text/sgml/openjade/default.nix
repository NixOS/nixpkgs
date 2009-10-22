{stdenv, fetchurl, opensp, perl}:

stdenv.mkDerivation {
  # OpenJade-1.3.2 requires gcc 3.3 to build.  
  # The next release is likely to be compatible with newer gccs.
  # If so the overrideGCC in top-level/all-packages should be removed.
  name = "OpenJade-1.3.2";

  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz";
    sha256 = "1l92sfvx1f0wmkbvzv1385y1gb3hh010xksi1iyviyclrjb7jb8x";
  };

  buildInputs = [opensp perl];

  configureFlags = [
    "--enable-spincludedir=${opensp}/include/OpenSP"
    "--enable-splibdir=${opensp}/lib"
  ]; 

  meta = {
    description = "An implementation of DSSSL, an ISO standard for formatting SGML (and XML) documents";
    license = "BSD";
    homepage = http://openjade.sourceforge.net/;
  };
}
