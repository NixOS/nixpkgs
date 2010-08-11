{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation rec {
  name = "nbd-2.9.18";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "afaaae330625b61ad67ba988721ddc4ad54bfc7e501daeb45f721c205bfb00f3";
  };

  buildInputs = [pkgconfig glib];

  # Link this package statically to generate an nbd-server binary that
  # has no dynamic dependencies and that can be used on (non-Nix) remote
  # machines that have a different setup than the local one.
  configureFlags = "LDFLAGS=-static";

  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons  ];
    platforms = stdenv.lib.platforms.all;
  };
}
