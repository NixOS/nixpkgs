{ stdenv
, execline
, fetchurl
, s6Dns
, skalibs
, skarnetConfCompile
}:

let

  version = "0.1.0.0";

in stdenv.mkDerivation rec {

  name = "s6-networking-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-networking/${name}.tar.gz";
    sha256 = "1np9m2j1i2450mbcjvpbb56kv3wc2fbyvmv2a039q61j2lk6vjz7";
  };

  buildInputs = [ skalibs s6Dns execline skarnetConfCompile ];

  sourceRoot = "net/${name}";

  meta = {
    homepage = http://www.skarnet.org/software/s6-networking/;
    description = "A suite of small networking utilities for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
