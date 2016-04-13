{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "nbd-3.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.xz";
    sha256 = "1pkkid657zgjymwxv3fm32cxnq9llfz29rl15vp6mn42vnzbj1di";
  };

  buildInputs =
    [ pkgconfig glib ]
    ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.linuxHeaders;

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp README.md "$out/share/doc/${name}/"
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
