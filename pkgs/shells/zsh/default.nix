{ stdenv, fetchurl, ncurses, coreutils }:

let

  version = "4.3.15";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "73b7ee1a737fbaf9be77cf6b55b27cca96bac39bc5ef25efa9ceb427cd1b5ad4";
  };
  
in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "8708f485823fb7e51aa696776d0dfac7d3558485182672cf9311c12a50a95486";
  };
  
  configureFlags = "--with-tcsetpgrp --enable-maildir-support --enable-multibyte";

  postInstall = ''
    ensureDir $out/share/
    tar xf ${documentation} -C $out/share
  '';

  buildInputs = [ ncurses coreutils ];

  meta = {
    description = "the Z shell";
    longDescription = "Zsh is a UNIX command interpreter (shell) usable as an interactive login shell and as a shell script command processor.  Of the standard shells, zsh most closely resembles ksh but includes many enhancements.  Zsh has command line editing, builtin spelling correction, programmable command completion, shell functions (with autoloading), a history mechanism, and a host of other features.";
    license = "MIT-like";
    homePage = "http://www.zsh.org/";
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
