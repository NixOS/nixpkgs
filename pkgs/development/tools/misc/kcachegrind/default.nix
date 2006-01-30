{stdenv, fetchurl, kdelibs, libX11, libXext, libSM, libpng, libjpeg, qt, zlib, perl, expat}:

stdenv.mkDerivation {
  name = "kcachegrind-0.4.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/kcachegrind-0.4.6.tar.gz;
    md5 = "4ed60028dcefd6bf626635d5f2f50273";
  };

  inherit libX11 kdelibs;
  buildInputs = [kdelibs libX11 libXext libSM zlib perl qt expat libpng libjpeg];
}
