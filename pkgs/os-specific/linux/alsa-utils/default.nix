{stdenv, fetchurl, alsaLib, gettext, ncurses}:

stdenv.mkDerivation {
  name = "alsa-utils-1.0.19";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.19.tar.bz2;
    sha256 = "1bcchd5nwgb2hy0z9c6jxbqlzirkh6wvxv6nldjcwmvqmvsj8j8z";
  };
  buildInputs = [ alsaLib gettext ncurses ];
  configureFlags = "--disable-xmlto";

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
