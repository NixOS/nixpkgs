{ system, allPackages ? import ../../.., config }:

rec {

  shell =
    if system == "i686-freebsd" || system == "x86_64-freebsd" then "/usr/local/bin/bash"
    else "/bin/bash";

  path =
    (if system == "i686-solaris" then [ "/usr/gnu" ] else []) ++
    (if system == "i686-netbsd" then [ "/usr/pkg" ] else []) ++
    (if system == "x86_64-solaris" then [ "/opt/local/gnu" ] else []) ++
    ["/" "/usr" "/usr/local"];

  prehookBase = ''
    # Disable purity tests; it's allowed (even needed) to link to
    # libraries outside the Nix store (like the C library).
    export NIX_ENFORCE_PURITY=
  '';

  prehookFreeBSD = ''
    ${prehookBase}

    alias make=gmake
    alias tar=gtar
    alias sed=gsed

    alias patch=gpatch # pcre relied on this for patching binary files

    alias cc=clang37

    # we need GNU cp for --reflink, need to alias all of coreutils
    alias basename=gbasename
    alias cat=gcat
    alias chgrp=gchgrp
    alias chmod=gchmod
    alias chown=gchown
    alias chroot=gchroot
    alias cksum=gcksum
    alias comm=gcomm
    alias cp=gcp
    alias csplit=gcsplit
    alias cut=gcut
    alias date=gdate
    alias dd=gdd
    alias df=gdf
    alias dir=gdir
    alias dircolors=gdircolors
    alias dirname=gdirname
    alias du=gdu
    alias echo=gecho
    alias env=genv
    alias expand=gexpand
    alias expr=gexpr
    alias factor=gfactor
    alias false=gfalse
    alias fmt=gfmt
    alias fold=gfold
    alias groups=ggroups
    alias head=ghead
    alias hostid=ghostid
    alias hostname=ghostname
    alias id=gid
    alias install=ginstall
    alias join=gjoin
    alias kill=gkill
    alias link=glink
    alias ln=gln
    alias logname=glogname
    alias ls=gls
    alias md5sum=gmd5sum
    alias mkdir=gmkdir
    alias mkfifo=gmkfifo
    alias mknod=gmknod
    alias mv=gmv
    alias nice=gnice
    alias nl=gnl
    alias nohup=gnohup
    alias od=god
    alias paste=gpaste
    alias pathchk=gpathchk
    alias pinky=gpinky
    alias pr=gpr
    alias printenv=gprintenv
    alias printf=gprintf
    alias ptx=gptx
    alias pwd=gpwd
    alias readlink=greadlink
    alias rm=grm
    alias rmdir=grmdir
    alias seq=gseq
    alias sha1sum=gsha1sum
    alias shred=gshred
    alias sleep=gsleep
    alias sort=gsort
    alias split=gsplit
    alias stat=gstat
    alias stty=gstty
    alias su=gsu
    alias sum=gsum
    alias sync=gsync
    alias tac=gtac
    #alias tail=gtail # this breaks xz XXX
    alias tee=gtee
    alias test=gtest
    alias touch=gtouch
    alias tr=gtr
    alias true=gtrue
    alias tsort=gtsort
    alias tty=gtty
    alias uname=guname
    alias unexpand=gunexpand
    alias uniq=guniq
    alias unlink=gunlink
    alias uptime=guptime
    alias users=gusers
    alias vdir=gvdir
    alias wc=gwc
    alias who=gwho
    alias whoami=gwhoami
    alias yes=gyes

    export MAKE=gmake
    shopt -s expand_aliases
  '';

  prehookOpenBSD = ''
    ${prehookBase}

    alias make=gmake
    alias grep=ggrep
    alias mv=gmv
    alias ln=gln
    alias sed=gsed
    alias tar=gtar

    export MAKE=gmake
    shopt -s expand_aliases
  '';

  prehookNetBSD = ''
    ${prehookBase}

    alias make=gmake
    alias sed=gsed
    alias tar=gtar
    export MAKE=gmake
    shopt -s expand_aliases
  '';

  # prevent libtool from failing to find dynamic libraries
  prehookCygwin = ''
    ${prehookBase}

    shopt -s expand_aliases
    export lt_cv_deplibs_check_method=pass_all
  '';

  extraBuildInputsCygwin = [
    ../cygwin/all-buildinputs-as-runtimedep.sh
    ../cygwin/wrap-exes-to-find-dlls.sh
  ] ++ (if system == "i686-cygwin" then [
    ../cygwin/rebase-i686.sh
  ] else if system == "x86_64-cygwin" then [
    ../cygwin/rebase-x86_64.sh
  ] else []);

  # A function that builds a "native" stdenv (one that uses tools in
  # /usr etc.).
  makeStdenv =
    { cc, fetchurl, extraPath ? [], overrides ? (pkgs: { }) }:

    import ../generic {
      preHook =
        if system == "i686-freebsd" then prehookFreeBSD else
        if system == "x86_64-freebsd" then prehookFreeBSD else
        if system == "i686-openbsd" then prehookOpenBSD else
        if system == "i686-netbsd" then prehookNetBSD else
        if system == "i686-cygwin" then prehookCygwin else
        if system == "x86_64-cygwin" then prehookCygwin else
        prehookBase;

      extraBuildInputs =
        if system == "i686-cygwin" then extraBuildInputsCygwin else
        if system == "x86_64-cygwin" then extraBuildInputsCygwin else
        [];

      initialPath = extraPath ++ path;

      fetchurlBoot = fetchurl;

      inherit system shell cc overrides config;
    };


  stdenvBoot0 = makeStdenv {
    cc = null;
    fetchurl = null;
  };


  cc = import ../../build-support/cc-wrapper {
    name = "cc-native";
    nativeTools = true;
    nativeLibc = true;
    nativePrefix = if system == "i686-solaris" then "/usr/gnu" else if system == "x86_64-solaris" then "/opt/local/gcc47" else "/usr";
    stdenv = stdenvBoot0;
  };


  fetchurl = import ../../build-support/fetchurl {
    stdenv = stdenvBoot0;
    # Curl should be in /usr/bin or so.
    curl = null;
  };


  # First build a stdenv based only on tools outside the store.
  stdenvBoot1 = makeStdenv {
    inherit cc fetchurl;
  } // {inherit fetchurl;};

  stdenvBoot1Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvBoot1;
  };


  # Using that, build a stdenv that adds the ‘xz’ command (which most
  # systems don't have, so we mustn't rely on the native environment
  # providing it).
  stdenvBoot2 = makeStdenv {
    inherit cc fetchurl;
    extraPath = [ stdenvBoot1Pkgs.xz ];
    overrides = pkgs: { inherit (stdenvBoot1Pkgs) xz; };
  };


  stdenv = stdenvBoot2;
}
