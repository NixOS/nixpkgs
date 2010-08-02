{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "nc6-1.0";

  src = fetchurl {
    url = ftp://ftp.deepspace6.net/pub/ds6/sources/nc6/nc6-1.0.tar.bz2;
    sha256 = "01l28zv1yal58ilfnz6albdzqqxzsx3a58vmc14r9gv0bahffdgb";
  };

  meta = {
    description = "A netcat implementation with IPv6 support";
    homepage = http://www.deepspace6.net/projects/netcat6.html;
  };
}
