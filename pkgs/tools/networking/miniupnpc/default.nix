{ stdenv, fetchurl, which, cctools }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation rec {
      name = "miniupnpc-${version}";
      src = fetchurl {
        name = "${name}.tar.gz";
        url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
        inherit sha256;
      };

      nativeBuildInputs = [] ++
        stdenv.lib.optionals stdenv.isDarwin [ which cctools ];

      patches = stdenv.lib.optional stdenv.isFreeBSD ./freebsd.patch;

      doCheck = !stdenv.isFreeBSD;

      makeFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

      meta = with stdenv.lib; {
        homepage = http://miniupnp.free.fr/;
        description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
        platforms = with platforms; linux ++ freebsd ++ darwin;
        license = licenses.bsd3;
      };
    };
in {
  miniupnpc_2 = generic {
    version = "2.0.20180203";
    sha256 = "1dr0qaf2qz49aawgsnv7l41rda5yvdk3qfz2hd5cv9iwav3sipch";
  };
  miniupnpc_1 = generic {
    version = "1.9.20160209";
    sha256 = "0vsbv6a8by67alx4rxfsrxxsnmq74rqlavvvwiy56whxrkm728ap";
  };
}
