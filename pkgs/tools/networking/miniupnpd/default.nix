{ stdenv, fetchurl, iptables }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "miniupnpd-1.4";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "06q5agkzv2snjxcsszpm27h8bqv41jijahs8jqnarxdrik97rfl5";
  };

  buildInputs = [ iptables ];

  NIX_CFLAGS_COMPILE = "-DIPTABLES_143";

  NIX_CFLAGS_LINK = "-liptc";
  
  makefile = "Makefile.linux";

  makeFlags = "LIBS=";

  postBuild = "cat config.h";

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  postInstall =
    ''
      ensureDir $out/share/man/man1
      cp miniupnpd.1 $out/share/man/man1/
    '';

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
  };
}
