{stdenv, fetchurl, coreutils, ncurses}:
stdenv.mkDerivation {
  name = "zsh-4.2.3";

  src = fetchurl {
    url = ftp://nephtys.lip6.fr/pub/unix/shells/zsh/zsh-4.2.3.tar.bz2;
    md5 = "ae19a74ae7e84cf4dbd8e35f52c8ec74";
  };

  configureFlags = "--with-tcsetpgrp";

  buildInputs = [ncurses coreutils ];
}
