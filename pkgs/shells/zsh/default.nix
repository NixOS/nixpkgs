{stdenv, fetchurl, coreutils, ncurses}:
stdenv.mkDerivation {
  name = "zsh-4.2.3";

  src = fetchurl {
    url = ftp://nephtys.lip6.fr/pub/unix/shells/zsh/zsh-4.3.2.tar.bz2;
    sha256 = "1lyzh68h69iarnmrrnd2gy9ssmns4w0abbr3hfz98lhik762f3na";
  };

  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  buildInputs = [ncurses coreutils];
}
