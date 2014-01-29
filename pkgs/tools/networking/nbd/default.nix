{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-3.7";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.xz";
    sha256 = "1k4bvg5rg4q6b58y4kd9qwj07sznsfbknlpc6y1bk6c48rgr3d0b";
  };

  buildInputs = [ pkgconfig glib ] ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.kernelHeaders;

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
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
