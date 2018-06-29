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

      meta = {
        homepage = http://miniupnp.free.fr/;
        description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
        platforms = with stdenv.lib.platforms; linux ++ freebsd ++ darwin;
      };
    };
in {
  miniupnpc_2 = generic {
    version = "2.0.20180222";
    sha256 = "0xavcrifk8v8gwig3mj0kjkm7rvw1kbsxcs4jxrrzl39cil48yaq";
  };
  miniupnpc_1 = generic {
    version = "1.9.20160209";
    sha256 = "0vsbv6a8by67alx4rxfsrxxsnmq74rqlavvvwiy56whxrkm728ap";
  };
}
