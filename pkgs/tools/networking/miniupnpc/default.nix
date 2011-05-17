{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.5";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0mx950lfxcjpsfny8qcjx6phb74v4zw1rlj99xicd4icx5j0w3s4";
  };

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  postInstall =
    ''
      ensureDir $out/share/man/man3
      cp man3/miniupnpc.3 $out/share/man/man3/
    '';

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
  };
}
