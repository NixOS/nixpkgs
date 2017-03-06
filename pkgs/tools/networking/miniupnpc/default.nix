{ stdenv, fetchurl }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation rec {
      name = "miniupnpc-${version}";
      src = fetchurl {
        name = "${name}.tar.gz";
        url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
        inherit sha256;
      };

      patches = stdenv.lib.optional stdenv.isFreeBSD ./freebsd.patch;

      doCheck = !stdenv.isFreeBSD;

      installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

      meta = {
        homepage = http://miniupnp.free.fr/;
        description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
        platforms = with stdenv.lib.platforms; linux ++ freebsd;
      };
    };
in {
  miniupnpc_2 = generic {
    version = "2.0.20161216";
    sha256 = "0gpxva9jkjvqwawff5y51r6bmsmdhixl3i5bmzlqsqpwsq449q81";
  };
  miniupnpc_1 = generic {
    version = "1.9.20150430";
    sha256 = "0ivnvzla0l2pzmy8s0j8ss0fnpsii7z9scvyl4a13g9k911hgmvn";
  };
}
