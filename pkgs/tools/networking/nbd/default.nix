{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-2.9.25";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "179548406aa2bcb0c6bff3aa0484dbb04136ec055aa385c84fefbe3c9ea96ba4";
  };

  buildInputs = [ pkgconfig glib ] ++ stdenv.lib.optional stdenv.isLinux stdenv.glibc.kernelHeaders;
  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';

  patches = [ ./0001-properly-check-for-HAVE_FALLOC_PH-in-both-occurrence.patch ];

  # The test suite doesn't succeed on Hydra (NixOS), because it assumes
  # that certain global configuration files available.
  doCheck = false;

  # Glib calls `clock_gettime', which is in librt.  Since we're using
  # a static Glib, we need to pass it explicitly.
  NIX_LDFLAGS = "-lrt";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
