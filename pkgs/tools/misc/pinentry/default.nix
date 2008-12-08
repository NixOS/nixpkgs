{ fetchurl, stdenv, glib, pkgconfig, gtk, ncurses }:

stdenv.mkDerivation rec {
  name = "pinentry-0.7.5";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.gz";
    sha256 = "cb269ac058793b2df343a12a65e3402abc4b68503e105b12e4ca903d8d8e3172";
  };

  patches = [ ./duplicate-glib-defs.patch ];

  buildInputs = [ glib pkgconfig gtk ncurses ];

  meta = { 
    description = "GnuPG's interface to passphrase input";

    longDescription = ''
      Pinentry provides a console and a GTK+ GUI that allows users to
      enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';

    homepage = http://gnupg.org/aegypten2/;
    license = "GPLv2+";
  };
}
