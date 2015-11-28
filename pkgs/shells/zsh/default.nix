{ stdenv, fetchurl, ncurses, coreutils, pcre }:

let

  version = "5.1.1";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.gz";
    sha256 = "0p99dr7kck0a6im1w9qiiz2ai78mgy53gbbn87bam9ya2885gf05";
  };

in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.gz";
    sha256 = "11shllzhq53fg8ngy3bgbmpf09fn2czifg7hsb41nxi3410mpvcl";
  };

  buildInputs = [ ncurses coreutils pcre ];

  configureFlags = [
    "--enable-maildir-support"
    "--enable-multibyte"
    "--enable-zprofile=$out/etc/zprofile"
    "--with-tcsetpgrp"
    "--enable-pcre"
  ];

  # the zsh/zpty module is not available on hydra
  # so skip groups Y Z
  checkFlagsArray = ''
    (TESTNUM=A TESTNUM=B TESTNUM=C TESTNUM=D TESTNUM=E TESTNUM=V TESTNUM=W)
  '';

  # XXX: think/discuss about this, also with respect to nixos vs nix-on-X
  postInstall = ''
    mkdir -p $out/share/
    tar xf ${documentation} -C $out/share
    mkdir -p $out/etc/
    cat > $out/etc/zprofile <<EOF
if test -e /etc/NIXOS; then
  if test -r /etc/zprofile; then
    . /etc/zprofile
  else
    emulate bash
    alias shopt=false
    . /etc/profile
    unalias shopt
    emulate zsh
  fi
  if test -r /etc/zprofile.local; then
    . /etc/zprofile.local
  fi
else
  # on non-nixos we just source the global /etc/zprofile as if we did
  # not use the configure flag
  if test -r /etc/zprofile; then
    . /etc/zprofile
  fi
fi
EOF
    $out/bin/zsh -c "zcompile $out/etc/zprofile"
    mv $out/etc/zprofile $out/etc/zprofile_zwc_is_used
  '';
  # XXX: patch zsh to take zwc if newer _or equal_

  meta = {
    description = "The Z shell";
    longDescription = ''
      Zsh is a UNIX command interpreter (shell) usable as an interactive login
      shell and as a shell script command processor.  Of the standard shells,
      zsh most closely resembles ksh but includes many enhancements.  Zsh has
      command line editing, builtin spelling correction, programmable command
      completion, shell functions (with autoloading), a history mechanism, and
      a host of other features.
    '';
    license = "MIT-like";
    homepage = "http://www.zsh.org/";
    maintainers = with stdenv.lib.maintainers; [ chaoflow pSub ];
    platforms = stdenv.lib.platforms.unix;
  };
}
