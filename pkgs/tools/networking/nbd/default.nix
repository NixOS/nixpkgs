{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-3.0";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "f7210edfa858f5ae69bdbf76f5467ac9dcaa97074d945e55e2a683e7aa228b93";
  };

  buildInputs = [ pkgconfig glib ] ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.kernelHeaders;

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp README "$out/share/doc/${name}/README"
  '';

  # The test suite doesn't succeed on Hydra.
  doCheck = false;

  # Glib calls `clock_gettime', which is in librt. Linking that library
  # here ensures that a proper rpath is added to the executable so that
  # it can be loaded at run-time.
  NIX_LDFLAGS = "-lrt -lpthread";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
