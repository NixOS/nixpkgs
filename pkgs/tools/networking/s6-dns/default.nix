{ stdenv
, fetchurl
, skalibs
, skarnetConfCompile
}:

let

  version = "0.1.0.0";

in stdenv.mkDerivation rec {

  name = "s6-dns-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-dns/${name}.tar.gz";
    sha256 = "1r82l5fnz2rrwm5wq2sldqp74lk9fifr0d8hyq98xdyh24hish68";
  };

  buildInputs = [ skalibs skarnetConfCompile ];

  sourceRoot = "web/${name}";

  meta = {
    homepage = http://www.skarnet.org/software/s6-dns/;
    description = "A suite of DNS client programs and libraries for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
