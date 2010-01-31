{ stdenv, fetchurl, ncurses, coreutils }:

let

  version = "4.3.10";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "f53d5c434fdb26fc79755279175514507eb1d11cf793ac57270d053ee61f37f9";
  };
  
in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "63fdc0273eadbb42d164f38b0b79922c0b3df0e97084e746a318276d935a4f7c";
  };
  
  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  postInstall = ''
    ensureDir $out/share/
    tar xf ${documentation} -C $out/share
  '';

  buildInputs = [ncurses coreutils];
}
