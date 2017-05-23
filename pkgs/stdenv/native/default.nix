{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;

let
  inherit (localSystem) system platform;

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
    export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
  '';

  prehookFreeBSD = ''
    ${prehookBase}

    alias make=gmake
    alias tar=gtar
    alias sed=gsed
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
    { cc, fetchurl, extraPath ? [], overrides ? (self: super: { }) }:

    import ../generic {
      hostPlatform = localSystem;
      targetPlatform = localSystem;

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

in

[

  ({}: rec {
    __raw = true;

    stdenv = makeStdenv {
      cc = null;
      fetchurl = null;
    };

    cc = import ../../build-support/cc-wrapper {
      name = "cc-native";
      nativeTools = true;
      nativeLibc = true;
      nativePrefix = { # switch
        "i686-solaris" = "/usr/gnu";
        "x86_64-solaris" = "/opt/local/gcc47";
      }.${system} or "/usr";
      inherit stdenv;
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit stdenv;
      # Curl should be in /usr/bin or so.
      curl = null;
    };

  })

  # First build a stdenv based only on tools outside the store.
  (prevStage: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = localSystem;
    inherit config overlays;
    stdenv = makeStdenv {
      inherit (prevStage) cc fetchurl;
    } // { inherit (prevStage) fetchurl; };
  })

  # Using that, build a stdenv that adds the ‘xz’ command (which most systems
  # don't have, so we mustn't rely on the native environment providing it).
  (prevStage: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = localSystem;
    inherit config overlays;
    stdenv = makeStdenv {
      inherit (prevStage.stdenv) cc fetchurl;
      extraPath = [ prevStage.xz ];
      overrides = self: super: { inherit (prevStage) xz; };
    };
  })

]
