args: with args;
# cvs does include docs
# the cvs snapshot is updated occasionally. see bleedingEdgeRepos

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = sourceByName "zsh";
  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  preConfigure = "autoconf; autoheader";

  postInstall = ''
    ensureDir $out/share/
    cp -R Doc $out/share
  '';

  buildInputs = [ncurses coreutils autoconf yodl ];
}
