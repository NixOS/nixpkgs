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
