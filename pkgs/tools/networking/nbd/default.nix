{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-3.4";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "1krj185fagnqsqpcfig7zkqa3cqgyyn956241ix224wssvynsajm";
  };

  buildInputs = [ pkgconfig glib ] ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.kernelHeaders;

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp README "$out/share/doc/${name}/README"
  '';

  # The test suite doesn't succeed in chroot builds.
  doCheck = false;

  # Glib calls `clock_gettime', which is in librt. Linking that library
  # here ensures that a proper rpath is added to the executable so that
  # it can be loaded at run-time.
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lrt -lpthread";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
