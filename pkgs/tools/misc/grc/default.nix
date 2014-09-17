{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "1.5";
  name    = "grc-${version}";

  src = fetchurl {
    url    = "http://korpus.juls.savba.sk/~garabik/software/grc/grc_${version}.tar.gz";
    sha256 = "1p6xffp5mmnaw9llvrd4rc7zd4l7b1m62dlmn3c8p1ina831yn52";
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
