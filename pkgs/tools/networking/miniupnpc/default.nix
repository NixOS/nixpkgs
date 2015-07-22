{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.9.20150430";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0ivnvzla0l2pzmy8s0j8ss0fnpsii7z9scvyl4a13g9k911hgmvn";
    name = "${name}.tar.gz";
  };

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  postInstall =
    ''
      mkdir -p $out/share/man/man3
      cp man3/miniupnpc.3 $out/share/man/man3/
    '';

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = stdenv.lib.platforms.linux;
  };
}
