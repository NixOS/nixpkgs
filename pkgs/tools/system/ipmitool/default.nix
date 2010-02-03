{ fetchurl, stdenv, openssl, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.11";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "5612f4835d89a6f2cede588eef978a05d63435cf2646256300d9785d8020a13e";
  };

  buildInputs = [ openssl ];
  dontDisableStatic = static;
  configureFlags = if static then "LDFLAGS=-static --enable-static --disable-shared" else "--enable-shared";
  makeFlags = if static then "AM_LDFLAGS=-all-static" else "";

  meta = {
    description = ''Command-line interface to IPMI-enabled devices'';
    license = "BSD";
    homepage = "http://ipmitool.sourceforge.net";
  };
}
