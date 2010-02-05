{system, allPackages ? import ../../..}:

rec {

  shell = "/bin/bash";

  path = (if system == "i386-sunos" then [ "/usr/gnu" ] else []) ++
    (if system == "i686-netbsd" then [ "/usr/pkg" ] else []) ++
    ["/" "/usr" "/usr/local"];

  prehookBase = builtins.toFile "prehook-base.sh" ''
    # Disable purity tests; it's allowed (even needed) to link to
    # libraries outside the Nix store (like the C library).
    export NIX_ENFORCE_PURITY=
  '';

  prehookDarwin = builtins.toFile "prehook-darwin.sh" ''
    source ${prehookBase}
    export NIX_DONT_SET_RPATH=1
    export NIX_NO_SELF_RPATH=1
    dontFixLibtool=1
    NIX_STRIP_DEBUG=0
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s" 
  '';

  /* FreeBSD needs the following packages installed from the FreeBSD packages
   * collection (pkg_add -r ...):
   *
   * bash
   * coreutils
   * diffutils
   * findutils
   * gawk
   * gmake
   * gsed
   * gtar
   * gzip
   *
   * The aliases are derived by using the derivealiases-freebsd.sh script
   *
   * The following packages seem to be fine in the default install:
   *
   * gcc (included with FreeBSD)
   * binutils (FreeBSD uses GNU binutils)
   * bzip2 (included with FreeBSD)
   * grep (FreeBSD uses GNU grep)
   * patch (included with FreeBSD) 
   *
   * Moreover a symlink to /bin/bash is required and /bin/sh has to be a symlink to /bin/bash
   */
   
  prehookFreeBSD = builtins.toFile "prehook-freebsd.sh" ''
    source ${prehookBase}
    
    alias [='g['
    alias base64='gbase64'
    alias basename='gbasename'
    alias cat='gcat'
    alias chcon='gchcon'
    alias chgrp='gchgrp'
    alias chmod='gchmod'
    alias chown='gchown'
    alias chroot='gchroot'
    alias cksum='gcksum'
    alias comm='gcomm'
    alias cp='gcp'
    alias csplit='gcsplit'
    alias cut='gcut'
    alias date='gdate'
    alias dd='gdd'
    alias df='gdf'
    alias dir='gdir'
    alias dircolors='gdircolors'
    alias dirname='gdirname'
    alias du='gdu'
    alias echo='gecho'
    alias env='genv'
    alias expand='gexpand'
    alias expr='gexpr'
    alias factor='gfactor'
    alias false='gfalse'
    alias fmt='gfmt'
    alias fold='gfold'
    alias groups='ggroups'
    alias head='ghead'
    alias hostid='ghostid'
    alias id='gid'
    alias install='ginstall'
    alias join='gjoin'
    alias kill='gkill'
    alias link='glink'
    alias ln='gln'
    alias logname='glogname'
    alias ls='gls'
    alias md5sum='gmd5sum'
    alias mkdir='gmkdir'
    alias mkfifo='gmkfifo'
    alias mknod='gmknod'
    alias mktemp='gmktemp'
    alias mv='gmv'
    alias nice='gnice'
    alias nl='gnl'
    alias nohup='gnohup'
    alias od='god'
    alias paste='gpaste'
    alias pathchk='gpathchk'
    alias pinky='gpinky'
    alias pr='gpr'
    alias printenv='gprintenv'
    alias printf='gprintf'
    alias ptx='gptx'
    alias pwd='gpwd'
    alias readlink='greadlink'
    alias rm='grm'
    alias rmdir='grmdir'
    alias runcon='gruncon'
    alias seq='gseq'
    alias sha1sum='gsha1sum'
    alias sha224sum='gsha224sum'
    alias sha256sum='gsha256sum'
    alias sha384sum='gsha384sum'
    alias sha512sum='gsha512sum'
    alias shred='gshred'
    alias shuf='gshuf'
    alias sleep='gsleep'
    alias sort='gsort'
    alias split='gsplit'
    alias stat='gstat'
    alias stdbuf='gstdbuf'
    alias stty='gstty'
    alias sum='gsum'
    alias sync='gsync'
    alias tac='gtac'
    alias tail='gtail'
    alias tee='gtee'
    alias test='gtest'
    alias timeout='gtimeout'
    alias touch='gtouch'
    alias tr='gtr'
    alias true='gtrue'
    alias truncate='gtruncate'
    alias tsort='gtsort'
    alias tty='gtty'
    alias uname='guname'
    alias unexpand='gunexpand'
    alias uniq='guniq'
    alias unlink='gunlink'
    alias uptime='guptime'
    alias users='gusers'
    alias vdir='gvdir'
    alias wc='gwc'
    alias who='gwho'
    alias whoami='gwhoami'
    alias yes='gyes'

    alias cmp='gcmp'
    alias diff='gdiff'
    alias diff3='gdiff3'
    alias sdiff='gsdiff'

    alias find='gfind'
    alias oldfind='goldfind'
    alias locate='glocate'
    alias updatedb='gupdatedb'
    alias xargs='gxargs'

    alias make='gmake'

    alias sed='gsed'

    alias tar='gtar'

    export MAKE=gmake
    shopt -s expand_aliases

    # Filter out stupid GCC warnings (in gcc-wrapper).
    export NIX_GCC_NEEDS_GREP=1
  '';

  /* OpenBSD needs the following packages installed from the OpenBSD packages
   * collection (pkg_add -r ...):
   *
   * bash
   * fileutils (there is no coreutils package)
   * gdiff
   * findutils
   * gawk
   * ggrep
   * gmake
   * gsed
   * gtar
   *
   * The aliases are derived by using the derivealiases-openbsd.sh script
   *
   * The following packages seem to be fine in the default install:
   *
   * gcc (included with OpenBSD)
   * binutils (OpenBSD uses GNU binutils)
   * bzip2 (included with openBSD)
   * patch (included with OpenBSD) 
   * gzip (included with OpenBSD
   *
   * Moreover a symlink to /bin/bash is required and /bin/sh has to be a symlink to /bin/bash
   */

  prehookOpenBSD = builtins.toFile "prehook-openbsd.sh" ''
    source ${prehookBase}
    
    alias chgrp='gchgrp'
    alias chmod='gchmod'
    alias chown='gchown'
    alias cp='gcp'
    alias dd='gdd'
    alias df='gdf'
    alias dir='gdir'
    alias dircolors='gdircolors'
    alias du='gdu'
    alias install='ginstall'
    alias ln='gln'
    alias ls='gls'
    alias mkdir='gmkdir'
    alias mkfifo='gmkfifo'
    alias mknod='gmknod'
    alias mv='gmv'
    alias rm='grm'
    alias rmdir='grmdir'
    alias shred='gshred'
    alias sync='gsync'
    alias touch='gtouch'
    alias vdir='gvdir'

    alias find='gfind'
    alias locate='glocate'
    alias updatedb='gupdatedb'
    alias xargs='gxargs'

    alias cmp='gcmp'
    alias diff='gdiff'
    alias diff3='gdiff3'
    alias sdiff='gsdiff'

    alias egrep='gegrep'
    alias fgrep='gfgrep'
    alias grep='ggrep'

    alias make='gmake'

    alias sed='gsed'

    alias tar='gtar'
    
    export MAKE=gmake
    shopt -s expand_aliases

    # Filter out stupid GCC warnings (in gcc-wrapper).
    export NIX_GCC_NEEDS_GREP=1
  '';

  prehookNetBSD = builtins.toFile "prehook-netbsd.sh" ''
    source ${prehookBase}
    
    alias make=gmake
    alias sed=gsed
    alias tar=gtar
    export MAKE=gmake
    shopt -s expand_aliases
    
    # Filter out stupid GCC warnings (in gcc-wrapper).
    export NIX_GCC_NEEDS_GREP=1
  '';

  prehookCygwin = builtins.toFile "prehook-cygwin.sh" ''
    source ${prehookBase}
    
    if test -z "$cygwinConfigureEnableShared"; then
      export configureFlags="$configureFlags --disable-shared"
    fi

    PATH_DELIMITER=';'
  '';


  # A function that builds a "native" stdenv (one that uses tools in
  # /usr etc.).  
  makeStdenv =
    {gcc, fetchurl, extraPath ? []}:

    import ../generic {
      name = "stdenv-native";

      preHook =
        if system == "i686-darwin" || system == "powerpc-darwin" || system == "x86_64-darwin" then prehookDarwin else
        if system == "i686-freebsd" then prehookFreeBSD else
        if system == "i686-openbsd" then prehookOpenBSD else
	if system == "i686-netbsd" then prehookNetBSD else
        prehookBase;

      initialPath = extraPath ++ path;

      fetchurlBoot = fetchurl;

      inherit system shell gcc;
    };


  stdenvBoot0 = makeStdenv {
    gcc = "/no-such-path";
    fetchurl = null;
  };
  

  gcc = import ../../build-support/gcc-wrapper {
    name = "gcc-native";
    nativeTools = true;
    nativeLibc = true;
    nativePrefix = if system == "i386-sunos" then "/usr/gnu" else "/usr";
    stdenv = stdenvBoot0;
  };

    
  fetchurl = import ../../build-support/fetchurl {
    stdenv = stdenvBoot0;
    # Curl should be in /usr/bin or so.
    curl = null;
  };
  
    
  # First build a stdenv based only on tools outside the store.
  stdenvBoot1 = makeStdenv {
    inherit gcc fetchurl;
  } // {inherit fetchurl;};

  stdenvBoot1Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvBoot1;
  };


  # Using that, build a stdenv that adds the `replace' command (which
  # most systems don't have, so we mustn't rely on the native
  # environment providing it).
  stdenvBoot2 = makeStdenv {
    inherit gcc fetchurl;
    extraPath = [stdenvBoot1Pkgs.replace];
  };


  stdenv = stdenvBoot2;
}
