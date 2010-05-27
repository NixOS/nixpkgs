{stdenv, fetchurl, alsaLib, gettext, ncurses}:

stdenv.mkDerivation rec {
  name = "alsa-utils-1.0.23";
  
  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2";
    sha256 = "1c7pl5k3d60wacnha8zfn2dixz7hiiaxvijis4559y15bs8mxl5p";
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
