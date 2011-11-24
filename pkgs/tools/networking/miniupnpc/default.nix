{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-1.6";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "151rh46axl44y7bbflb43pnj52gvlfnkxfgrn2jvai5gwrbbgmmv";
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
