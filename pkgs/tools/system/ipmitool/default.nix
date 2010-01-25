{ fetchurl, stdenv, openssl }:

let
  pkgname = "ipmitool";
  version = "1.8.9";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "1d6bf2595d1fd0dbef206c300cc666d3d079548ba97f727077d61c4736a7e63a";
  };

  buildInputs = [ openssl ];

  meta = {
    description = ''Command-line interface to IPMI-enabled devices'';
    license = "BSD";
    homepage = "http://ipmitool.sourceforge.net";
  };
}
