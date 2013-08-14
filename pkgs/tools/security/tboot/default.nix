{stdenv, fetchurl, autoconf, automake, trousers, openssl, zlib}:

stdenv.mkDerivation {
  name = "tboot-1.8.0";

  src = fetchurl {
    url = https://sourceforge.net/projects/tboot/files/tboot/tboot-1.8.0.tar.gz;
    sha256 = "04z1maryqnr714f3rcynqrpmlx76lxr6bb543xwj5rdl1yvdw2xr";
  };

  buildInputs = [ trousers openssl zlib ];

  patches = [ ./tboot-add-well-known-secret-option-to-lcp_writepol.patch ];

  configurePhase = ''
    for a in lcptools utils tb_polgen; do
      substituteInPlace $a/Makefile --replace /usr/sbin /sbin
    done
    substituteInPlace docs/Makefile --replace /usr/share /share
  '';
  installFlags = "DESTDIR=$(out)";
}
