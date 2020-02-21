{ stdenv, fetchurl, ncurses, pcre, buildPackages }:

let
  version = "5.8";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.xz";
    sha256 = "1i6wdzq6rfjx5yjrpzan1jf50hk2pfzy5qib9mb7cnnbjfar6klv";
  };
in

stdenv.mkDerivation {
  pname = "zsh";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.xz";
    sha256 = "09yyaadq738zlrnlh1hd3ycj1mv3q5hh4xl1ank70mjnqm6bbi6w";
  };

  buildInputs = [ ncurses pcre ];

  configureFlags = [
    "--enable-maildir-support"
    "--enable-multibyte"
    "--with-tcsetpgrp"
    "--enable-pcre"
    "--enable-zprofile=${placeholder "out"}/etc/zprofile"
  ];

  # the zsh/zpty module is not available on hydra
  # so skip groups Y Z
  checkFlags = map (T: "TESTNUM=${T}") (stdenv.lib.stringToCharacters "ABCDEVW");

  # XXX: think/discuss about this, also with respect to nixos vs nix-on-X
  postInstall = ''
    mkdir -p $out/share/info
    tar xf ${documentation} -C $out/share
    ln -s $out/share/zsh-*/Doc/zsh.info* $out/share/info/

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
    ${if stdenv.hostPlatform == stdenv.buildPlatform then ''
      $out/bin/zsh -c "zcompile $out/etc/zprofile"
    '' else ''
      ${stdenv.lib.getBin buildPackages.zsh}/bin/zsh -c "zcompile $out/etc/zprofile"
    ''}
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
    homepage = http://www.zsh.org/;
    maintainers = with stdenv.lib.maintainers; [ pSub ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = {
    shellPath = "/bin/zsh";
  };
}
