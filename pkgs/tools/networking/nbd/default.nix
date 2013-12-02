{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-3.5";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "0frnbmdcm1b0nmmpvpwjb9h1yabdpwwd2l95056mhl2zaafh8gqx";
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
