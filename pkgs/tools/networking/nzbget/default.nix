{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-9.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "1r4ys5nmcz1ilkdjdh3r8lawaf96i8spk6hl02h823q9rppvmya0";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls libgcrypt ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lz";

  meta = {
    homepage = http://nzbget.sourceforge.net/;
    license = "GPLv2+";
    description = "A command line tool for downloading files from news servers";
  };
}
