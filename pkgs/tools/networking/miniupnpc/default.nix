{ stdenv, fetchurl }:

let version = "1.9.20150430"; in
stdenv.mkDerivation rec {
  name = "miniupnpc-${version}";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0ivnvzla0l2pzmy8s0j8ss0fnpsii7z9scvyl4a13g9k911hgmvn";
    name = "${name}.tar.gz";
  };

  patches = stdenv.lib.optional stdenv.isFreeBSD ./freebsd.patch;

  doCheck = !stdenv.isFreeBSD;

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    inherit version;
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with stdenv.lib.platforms; linux ++ freebsd;
  };
}
