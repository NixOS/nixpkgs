{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "nbd-2.9.20";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "98f0de421f0b2f683d46dff3eb679a3409a41f08e6fad7c2f71f60c5d409939c";
  };

  buildInputs = [pkgconfig glib];
  postInstall = ''install -D -m 444 README "$out/share/doc/nbd/README"'';
  
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
