{ system, allPackages ? import ../../.. }:

rec {

  shell = 
    if system == "i686-freebsd" || system == "x86_64-freebsd" 
    then "/usr/local/bin/bash"
    else "/bin/bash";

  path = 
    (if system == "i386-sunos" then [ "/usr/gnu" ] else []) ++
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

  prehookFreeBSD = builtins.toFile "prehook-freebsd.sh" ''
    source ${prehookBase}
    
    alias make=gmake
    alias tar=gtar
    alias sed=gsed
    export MAKE=gmake
    shopt -s expand_aliases

    # Filter out stupid GCC warnings (in gcc-wrapper).
    export NIX_GCC_NEEDS_GREP=1
  '';

  prehookOpenBSD = builtins.toFile "prehook-openbsd.sh" ''
    source ${prehookBase}
    
    alias make=gmake
    alias grep=ggrep
    alias mv=gmv
    alias ln=gln
    alias sed=gsed
    alias tar=gtar
    
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
        if system == "x86_64-freebsd" then prehookFreeBSD else
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
