{ stdenv, fetchurl, pkgconfig, glib }:

let
  name = "nbd-2.9.21a";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "9946dd7f4a63cf20ea8617100d0f599211d4a5fd5b6cfb8f50f8975431222bbd";
  };

  buildInputs = [pkgconfig glib];
  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';
  doCheck = true;

  # Glib calls `clock_gettime', which is in librt.  Since we're using
  # a static Glib, we need to pass it explicitly.
  NIX_LDFLAGS = "-lrt";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons  ];
    platforms = stdenv.lib.platforms.all;
  };
}
