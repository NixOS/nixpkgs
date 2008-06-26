args: with args;
let documentation = fetchurl {
    url = mirror://sourceforge/zsh/zsh-4.3.5-doc.tar.bz2;
    sha256 = "0jf35xibp8wfka7rdk9q8spkwprlhjx1sp7vp6img8wks12cvlkx";
  };
in
stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = mirror://sourceforge/zsh/zsh-4.3.5.tar.bz2;
    sha256 = "0191j3liflkjrj39i2yrs3ab9jcx4zd93rirx3j17dymfgqlvrzb";
  };
  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  postInstall = ''
    ensureDir $out/share/
    tar xf ${documentation} -C $out/share
  '';

  buildInputs = [ncurses coreutils];
}
