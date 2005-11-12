# todo: make libXext a propaged build input in kdelibs?

{stdenv, fetchurl, kdelibs, libX11, libXext, qt, zlib, perl}:

stdenv.mkDerivation {
  name = "kcachegrind-0.4.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://kcachegrind.sourceforge.net/kcachegrind-0.4.6.tar.gz;
    md5 = "4ed60028dcefd6bf626635d5f2f50273";
  };

  inherit libX11 kdelibs;
  buildInputs = [kdelibs libX11 libXext zlib perl qt];
}
