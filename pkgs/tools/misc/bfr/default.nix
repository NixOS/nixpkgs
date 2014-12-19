{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "bfr-1.6";
  version = "1.6";

  src = fetchurl {
    url = "http://www.sourcefiles.org/Utilities/Text_Utilities/bfr-${version}.tar.bz2";
    sha256 = "0fadfssvj9klj4dq9wdrzys1k2a1z2j0p6kgnfgbjv0n1bq6h4cy";
  };

  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A general-purpose command-line pipe buffer";
    homepage = http://www.glines.org/wiki/bfr;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
