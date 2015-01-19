{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.9";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/${name}.tar.gz";
    sha256 = "0r24jdqcyf839n30ppimdna0hvybscyziaad7ng99fw0x19y88r9";
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
  };
}
