{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;

let
  inherit (localSystem) system;

  shell =
    if system == "i686-freebsd" || system == "x86_64-freebsd" then "/usr/local/bin/bash"
    else "/bin/bash";

  path =
    (lib.optionals (system == "i686-solaris") [ "/usr/gnu" ]) ++
    (lib.optionals (system == "i686-netbsd") [ "/usr/pkg" ]) ++
    (lib.optionals (system == "x86_64-solaris") [ "/opt/local/gnu" ]) ++
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

  extraNativeBuildInputsCygwin = [
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
    { cc, fetchurl, extraPath ? [], overrides ? (self: super: { }), extraNativeBuildInputs ? [] }:

    import ../generic {
      buildPlatform = localSystem;
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

      extraNativeBuildInputs = extraNativeBuildInputs ++
        (if system == "i686-cygwin" then extraNativeBuildInputsCygwin else
        if system == "x86_64-cygwin" then extraNativeBuildInputsCygwin else
        []);

      initialPath = extraPath ++ path;

      fetchurlBoot = fetchurl;

      inherit shell cc overrides config;
    };

in

[

  ({}: rec {
    __raw = true;

    stdenv = makeStdenv {
      cc = null;
      fetchurl = null;
    };
    stdenvNoCC = stdenv;

    cc = let
      nativePrefix = { # switch
        i686-solaris = "/usr/gnu";
        x86_64-solaris = "/opt/local/gcc47";
      }.${system} or "/usr";
    in
    import ../../build-support/cc-wrapper {
      name = "cc-native";
      nativeTools = true;
      nativeLibc = true;
      inherit lib nativePrefix;
      bintools = import ../../build-support/bintools-wrapper {
        name = "bintools";
        inherit lib stdenvNoCC nativePrefix;
        nativeTools = true;
        nativeLibc = true;
      };
      inherit stdenvNoCC;
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib stdenvNoCC;
      # Curl should be in /usr/bin or so.
      curl = null;
    };

  })

  # First build a stdenv based only on tools outside the store.
  (prevStage: {
    inherit config overlays;
    stdenv = makeStdenv {
      inherit (prevStage) cc fetchurl;
      overrides = prev: final: { inherit (prevStage) fetchurl; };
    } // {
      inherit (prevStage) fetchurl;
    };
  })

  # Using that, build a stdenv that adds the ‘xz’ command (which most systems
  # don't have, so we mustn't rely on the native environment providing it).
  (prevStage: {
    inherit config overlays;
    stdenv = makeStdenv {
      inherit (prevStage.stdenv) cc fetchurl;
      extraPath = [ prevStage.xz ];
      overrides = self: super: { inherit (prevStage) fetchurl xz; };
      extraNativeBuildInputs = if localSystem.isLinux then [ prevStage.patchelf ] else [];
    };
  })

]
