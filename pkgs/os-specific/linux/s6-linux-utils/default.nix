{ stdenv
, fetchurl
, skalibs
, skarnetConfCompile
}:

let

  version = "1.0.3.1";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "1s17g03z5hfpiz32g001g5wyamyvn9l36fr2csk3k7r0jkqfnl0d";
  };

  buildInputs = [ skalibs skarnetConfCompile ];

  sourceRoot = "admin/${name}";

  meta = {
    homepage = http://www.skarnet.org/software/s6-linux-utils/;
    description = "A set of minimalistic Linux-specific system utilities";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
  };

}
