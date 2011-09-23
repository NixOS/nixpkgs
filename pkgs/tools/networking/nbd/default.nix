{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-2.9.23";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "0ab44fe9e80c3f41bb1025ecda351a874affd46bf56ba4033ea03700c3b83803";
  };

  buildInputs = [pkgconfig glib];
  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';

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
