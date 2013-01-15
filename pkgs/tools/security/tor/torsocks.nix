{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "torsocks";
  name = "${pname}-${version}";
  version = "1.2";
  
  src = fetchurl {
    url = "http://${pname}.googlecode.com/files/${name}.tar.gz";
    sha256 = "1m0is5q24sf7jjlkl0icfkdc0m53nbkg0q72s57p48yp4hv7v9dy";
  };

  preConfigure = ''
      export configureFlags="$configureFlags --libdir=$out/lib"
  '';

  meta = {
    description = "use socks-friendly applications with Tor";
    homepage = http://code.google.com/p/torsocks/;
    license = "GPLv2";
  };
}
