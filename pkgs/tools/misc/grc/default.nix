{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  version = "1.4";
  name    = "grc_${version}";

  src = fetchurl {
    url    = "http://korpus.juls.savba.sk/~garabik/software/grc/${name}.tar.gz";
    sha256 = "1l7lskxfjk32kkv4aaqw5qcxvh972nab3x2jzy67m1aa0zpcbzdv";
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

