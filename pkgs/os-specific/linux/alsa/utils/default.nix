{stdenv, fetchurl, alsaLib, ncurses, gettext}:

stdenv.mkDerivation {
  name = "alsa-utils-1.0.14";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.14.tar.bz2;
    sha256 = "1jx5bwa8abx7aih4lymx4bnrmyip2yb0rp1mza97wpni1q7n6z9h";
  };
  buildInputs = [alsaLib ncurses gettext];

  meta = {
	  homepage = http://www.alsa-project.org;
  };
}
