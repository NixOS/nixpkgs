{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "1.7";
  name    = "grc-${version}";

  src = fetchurl {
    url    = "http://korpus.juls.savba.sk/~garabik/software/grc/grc_${version}.orig.tar.gz";
    sha256 = "01hpvs5915ajcswm7kg4167qsa9kbg0snxxj5k3ymkz6c567dp70";
  };

  installPhase = ''
    sed -i s%/usr%% install.sh
    sed -i "s% /usr/bin/python%${python}/bin/python%" grc
    sed -i "s% /usr/bin/python%${python}/bin/python%" grc
    ./install.sh "$out"
  '';

  meta = with stdenv.lib; {
    description = "Yet another colouriser for beautifying your logfiles or output of commands";
    homepage    = http://korpus.juls.savba.sk/~garabik/software/grc.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
