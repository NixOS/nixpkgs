{ stdenv, fetchurl, ncurses, pcre, fetchpatch }:

let
  version = "5.7";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.xz";
    sha256 = "0pgisyi82pg5mycx1k7vfx9hwzl6zq00r5s9v91lg4gqisvlvagh";
  };

in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.xz";
    sha256 = "04ynid3ggvy6i5c26bk52mq6x5vyrdwgryid9hggmnb1nf8b41vq";
  };

  patches = [
    (fetchpatch {
      name = "vcs_info.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/vcs_info.patch?h=packages/zsh&id=1b7537ff5343819b3110a76bbdd2a1bf9ef80c4a";
      sha256 = "0rc63cdc0qzhmj2dp5jnmxgyl5c47w857s8379fq36z8g0bi3rwq";
      excludes = [ "ChangeLog" ];
    })
  ];

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
    homepage = http://www.zsh.org/;
    maintainers = with stdenv.lib.maintainers; [ chaoflow pSub ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = {
    shellPath = "/bin/zsh";
  };
}
