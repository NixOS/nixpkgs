{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.7";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0dv3mz4yikngmlnrnmh747mlgbbpijryw03wcs8g4jwvprb29p8n";
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
