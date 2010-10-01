{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "torsocks";
  name = "${pname}-${version}";
  version = "1.0-epsilon";
  
  src = fetchurl {
    url = "http://${pname}.googlecode.com/files/${name}.tar.gz";
    sha256 = "0508i4q9gm0rrav018z1jn4as5if3qrfdng6dmmzgs324hvdgap5";
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
