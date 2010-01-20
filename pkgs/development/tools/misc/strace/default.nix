{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "strace-4.5.19";

  src = fetchurl {
    url = "mirror://sourceforge/strace/${name}.tar.bz2";
    sha256 = "021x06jyvpg156kf6ndbd370nz4w3xp6q06pbk20w6wpks8wx5w9";
  };

  meta = {
    homepage = http://strace.sourceforge.net/;
    description = "A system call tracer for Linux";
    license = "bsd";
  };
}
