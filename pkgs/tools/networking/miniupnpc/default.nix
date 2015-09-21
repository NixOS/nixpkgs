{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.9.20150730";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0156hssql8iaziwba8ag7y39lchrgwcvlhck2d2qak1vznqzlr0x";
    name = "${name}.tar.gz";
  };

  doCheck = true;

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = stdenv.lib.platforms.linux;
  };
}
