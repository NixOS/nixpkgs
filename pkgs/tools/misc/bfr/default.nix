{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "bfr-1.6";

  src = fetchurl {
    url = http://www.glines.org/bin/pk/bfr-1.6.tar.bz2;
    sha256 = "0fadfssvj9klj4dq9wdrzys1k2a1z2j0p6kgnfgbjv0n1bq6h4cy";
  };

  buildInputs = [ perl ];

  meta = {
    description = "general-purpose command-line pipe buffer";
    homepage = http://www.glines.org/wiki/bfr;
    license = stdenv.lib.licenses.gpl2;
  };
}
