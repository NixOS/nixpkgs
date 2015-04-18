{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "1.9";
  name    = "grc-${version}";

  src = fetchurl {
    url    = "http://korpus.juls.savba.sk/~garabik/software/grc/grc_${version}.orig.tar.gz";
    sha256 = "0nsgqpijhpinnzscmpnhcjahv8yivz0g65h8zsly2md23ibnwqj1";
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
    maintainers = with maintainers; [ lovek323 AndersonTorres ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
