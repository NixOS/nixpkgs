{stdenv, fetchurl, alsaLib, ncurses, gettext}:

stdenv.mkDerivation {
  name = "alsa-utils-1.0.13";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.13.tar.bz2;
    sha256 = "1w2hq2b4p3kvrl1a8nb6klrkkll20rx97hgvi4f36x5wjmwqmznp";
  };
  buildInputs = [alsaLib ncurses gettext];
}
