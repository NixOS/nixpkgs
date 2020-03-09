{ stdenv, fetchurl, which, cctools }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation rec {
      pname = "miniupnpc";
      inherit version;
      src = fetchurl {
        name = "${pname}-${version}.tar.gz";
        url = "http://miniupnp.free.fr/files/download.php?file=${pname}-${version}.tar.gz";
        inherit sha256;
      };

      nativeBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ which cctools ];

      patches = stdenv.lib.optional stdenv.isFreeBSD ./freebsd.patch;

      doCheck = !stdenv.isFreeBSD;

      makeFlags = [ "PREFIX=$(out)" "INSTALLPREFIX=$(out)" ];

      meta = with stdenv.lib; {
        homepage = http://miniupnp.free.fr/;
        description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
        platforms = with platforms; linux ++ freebsd ++ darwin;
        license = licenses.bsd3;
      };
    };
in {
  miniupnpc_2 = generic {
    version = "2.1.20190625";
    sha256 = "1yqp0d8x5ldjfma5x2vhpg1aaafdg0470ismccixww3rzpbza8w7";
  };
  miniupnpc_1 = generic {
    version = "1.9.20160209";
    sha256 = "0vsbv6a8by67alx4rxfsrxxsnmq74rqlavvvwiy56whxrkm728ap";
  };
}
