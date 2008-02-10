args: with args;
stdenv.mkDerivation {
  name = "zsh-4.3.4";

  src = fetchurl {
    url = mirror://sourceforge/zsh/zsh-4.3.4.tar.bz2;
    sha256 = "1inypy60h7hir8hwidid85pbajrb5w09fl222p0h4fnsn0nf583g";
  };

  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  buildInputs = [ncurses coreutils];
}
