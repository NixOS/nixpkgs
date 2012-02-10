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

  patches = [ ./0001-properly-check-for-HAVE_FALLOC_PH-in-both-occurrence.patch ];

  buildInputs = [ pkgconfig glib ] ++ stdenv.lib.optional stdenv.isLinux stdenv.glibc.kernelHeaders;

  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';

  # The test suite doesn't succeed on Hydra.
  doCheck = false;

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
