{ stdenv, fetchurl, ncurses, coreutils, pcre }:

let

  version = "5.0.8";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "0h4y6f0fjb1lf83j4cixl0h5jgyy5q7y1iw7w33flp7s8y60ir8f";
  };

in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "08vxw74v8cx6hcynz0cdf7s2z5p6nqmxfsxmhhpz5vwbrc4cyyc0";
  };

  buildInputs = [ ncurses coreutils pcre ];

  preConfigure = ''
    configureFlags="--enable-maildir-support --enable-multibyte --enable-zprofile=$out/etc/zprofile --with-tcsetpgrp --enable-pcre"
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
