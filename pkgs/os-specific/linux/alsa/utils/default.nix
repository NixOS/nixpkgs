{stdenv, fetchurl, alsaLib, ncurses, gettext}:

stdenv.mkDerivation {
  name = "alsa-utils-1.0.9a";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.9a.tar.bz2;
    md5 = "d4b77e9fe0311772293e402fdd634ad2";
  };
  buildInputs = [alsaLib ncurses gettext];
}
