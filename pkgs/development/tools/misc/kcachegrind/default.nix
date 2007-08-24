{stdenv, fetchurl, kdelibs, libX11, libXext, libSM, libpng, libjpeg, qt, zlib, perl, expat}:

# !!! dot is a run-time dependencies

stdenv.mkDerivation {
  name = "kcachegrind-0.4.6";

  src = fetchurl {
    url = http://kcachegrind.sourceforge.net/kcachegrind-0.4.6.tar.gz;
    md5 = "4ed60028dcefd6bf626635d5f2f50273";
  };

  KDEDIR = kdelibs;

  configureFlags = "
    --without-arts
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib";
    
  buildInputs = [kdelibs libX11 libXext libSM zlib perl qt expat libpng libjpeg];

  meta = {
    description = "Interactive visualisation tool for Valgrind profiling data";
  };
}
