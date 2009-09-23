{system, allPackages ? import ../../..}:

rec {

  shell = "/bin/bash";

  path = ["/" "/usr" "/usr/local"];


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
    export MAKE=gmake
    shopt -s expand_aliases

    # Filter out stupid GCC warnings (in gcc-wrapper).
    export NIX_GCC_NEEDS_GREP=1
  '';

  prehookOpenBSD = builtins.toFile "prehook-openbsd.sh" ''
    source ${prehookBase}
    
    alias make=gmake
    alias grep=ggrep
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
        if system == "i686-darwin" || system == "powerpc-darwin" then prehookDarwin else
        if system == "i686-freebsd" then prehookFreeBSD else
        if system == "i686-openbsd" then prehookOpenBSD else
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
    nativePrefix = "/usr";
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
