{ stdenv, fetchurl, ncurses, coreutils }:

let

  version = "4.3.9";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "0rc19q5r8x2yln7synpqzxngm7g4g6idrpgc1i0jsawc48m7dbhm";
  };
  
in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "1aw28c5w83vl2ckbvf6ljj00s36icyrnxcm1r6q63863dmn6vpcg";
  };
  
  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  postInstall = ''
    ensureDir $out/share/
    tar xf ${documentation} -C $out/share
  '';

  buildInputs = [ncurses coreutils];
}
