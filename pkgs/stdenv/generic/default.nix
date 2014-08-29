let lib = import ../../../lib; in lib.makeOverridable (

{ system, name ? "stdenv", preHook ? "", initialPath, gcc, shell
, extraAttrs ? {}, overrides ? (pkgs: {}), config

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot

, setupScripts ? [
    # Original huge setup.sh was split into pieces grouped by purpose:

    ./default-builder/util-hook-handling.sh
    ./default-builder/util-paths.sh
    ./default-builder/util-substitute.sh
    ./default-builder/pretty-print.sh

    ./default-builder/add-build-inputs.sh
    ./default-builder/unpack+patch.sh
    ./default-builder/configure+build.sh
    ./default-builder/check-phases.sh

    ./default-builder/install+fixup.sh
    ./default-builder/move-docs.sh
    ./default-builder/compress-man-pages.sh
    ./default-builder/strip.sh
    ./default-builder/patch-shebangs.sh

    ./default-builder/dist-phase.sh
    ./default-builder/exit-handler.sh

    ./default-builder/setup.sh
  ]

, extraBuildInputs ? []
}:

let

  allowUnfree = config.allowUnfree or false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";

  # Alow granular checks to allow only some unfree packages
  # Example:
  # {pkgs, ...}:
  # {
  #   allowUnfree = false;
  #   allowUnfreePredicate = (x: pkgs.lib.hasPrefix "flashplayer-" x.name);
  # }
  allowUnfreePredicate = config.allowUnfreePredicate or (x: false);

  allowBroken = config.allowBroken or false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

  forceEvalHelp = unfreeOrBroken:
    assert (unfreeOrBroken == "Unfree" || unfreeOrBroken == "Broken");
    ''
      You can set
        { nixpkgs.config.allow${unfreeOrBroken} = true; }
      in configuration.nix to override this. If you use Nix standalone, you can add
        { allow${unfreeOrBroken} = true; }
      to ~/.nixpkgs/config.nix.
    '';

  unsafeGetAttrPos = builtins.unsafeGetAttrPos or (n: as: null);

  extraBuildInputs' = extraBuildInputs ++ [ gcc ];

  # Add a utility function to produce derivations that use this
  # stdenv and its shell.
  mkDerivation = attrs:
    let
      pos =
        if attrs.meta.description or null != null then
          unsafeGetAttrPos "description" attrs.meta
        else
          unsafeGetAttrPos "name" attrs;
      pos' = if pos != null then "‘" + pos.file + ":" + toString pos.line + "’" else "«unknown-file»";
    in
    if !allowUnfree
       && (let l = lib.lists.toList attrs.meta.license or []; in lib.lists.elem "unfree" l || lib.lists.elem "unfree-redistributable" l)
       && !allowUnfreePredicate attrs then
      throw ''
        Package ‘${attrs.name}’ in ${pos'} has an unfree license, refusing to evaluate. You can set
          { nixpkgs.config.allowUnfree = true; }
        in configuration.nix to override this. If you use Nix standalone, you can add
          { allowUnfree = true; }
        to ~/.nixpkgs/config.nix.''
    else if !allowBroken && attrs.meta.broken or false then
      throw ''
        Package ‘${attrs.name}’ in ${pos'} is marked as broken, refusing to evaluate. You can set
          { nixpkgs.config.allowBroken = true; }
        in configuration.nix to override this. If you use Nix standalone, you can add
          { allowBroken = true; }
        to ~/.nixpkgs/config.nix.''
    else if !allowBroken && attrs.meta.platforms or null != null && !lib.lists.elem result.system attrs.meta.platforms then
      throw ''
        Package ‘${attrs.name}’ in ${pos'} is not supported on ‘${result.system}’, refusing to evaluate. You can set
          { nixpkgs.config.allowBroken = true; }
        in configuration.nix to override this. If you use Nix standalone, you can add
          { allowBroken = true; }
        to ~/.nixpkgs/config.nix.''
    else
      lib.addPassthru (derivation (
        (removeAttrs attrs ["meta" "passthru" "crossAttrs"])
        // (let
          buildInputs = attrs.buildInputs or [];
          nativeBuildInputs = attrs.nativeBuildInputs or [];
          propagatedBuildInputs = attrs.propagatedBuildInputs or [];
          propagatedNativeBuildInputs = attrs.propagatedNativeBuildInputs or [];
          crossConfig = attrs.crossConfig or null;
        in
        {
          builder = attrs.realBuilder or shell;
          args = attrs.args or ["-e" (attrs.builder or ./default-builder/builder.sh)];
          stdenv = result;
          system = result.system;
          userHook = config.stdenv.userHook or null;
          __ignoreNulls = true;

          # Inputs built by the cross compiler.
          buildInputs = lib.optionals (crossConfig != null) (buildInputs ++ extraBuildInputs');
          propagatedBuildInputs = lib.optionals (crossConfig != null) propagatedBuildInputs;
          # Inputs built by the usual native compiler.
          nativeBuildInputs = nativeBuildInputs ++ lib.optionals (crossConfig == null) (buildInputs ++ extraBuildInputs');
          propagatedNativeBuildInputs = propagatedNativeBuildInputs ++
            lib.optionals (crossConfig == null) propagatedBuildInputs;
      }))) (
      {
        # The meta attribute is passed in the resulting attribute set,
        # but it's not part of the actual derivation, i.e., it's not
        # passed to the builder and is not a dependency.  But since we
        # include it in the result, it *is* available to nix-env for
        # queries.  We also a meta.position attribute here to
        # identify the source location of the package.
        meta = attrs.meta or {} // (if pos != null then {
          position = pos.file + ":" + (toString pos.line);
        } else {});
        passthru = attrs.passthru or {};
      } //
      # Pass through extra attributes that are not inputs, but
      # should be made available to Nix expressions using the
      # derivation (e.g., in assertions).
      (attrs.passthru or {}));

  # The stdenv that we are producing.
  result =

    derivation {
      inherit system name;

      builder = shell;

      args = ["-e" ./builder.sh];

      inherit setupScripts preHook initialPath shell;

      propagatedUserEnvPkgs = [gcc] ++
        lib.filter lib.isDerivation initialPath;
    }

    // rec {

      meta.description = "The default build environment for Unix packages in Nixpkgs";

      # Utility flags to test the type of platform.
      isDarwin = system == "x86_64-darwin";
      isLinux = system == "i686-linux"
             || system == "x86_64-linux"
             || system == "powerpc-linux"
             || system == "armv5tel-linux"
             || system == "armv6l-linux"
             || system == "armv7l-linux"
             || system == "mips64el-linux";
      isGNU = system == "i686-gnu"; # GNU/Hurd
      isGlibc = isGNU # useful for `stdenvNative'
             || isLinux
             || system == "x86_64-kfreebsd-gnu";
      isSunOS = system == "i686-solaris"
             || system == "x86_64-solaris";
      isCygwin = system == "i686-cygwin"
              || system == "x86_64-cygwin";
      isFreeBSD = system == "i686-freebsd"
              || system == "x86_64-freebsd";
      isOpenBSD = system == "i686-openbsd"
              || system == "x86_64-openbsd";
      isBSD = system == "i686-freebsd"
           || system == "x86_64-freebsd"
           || system == "i686-openbsd"
           || system == "x86_64-openbsd";
      isi686 = system == "i686-linux"
            || system == "i686-gnu"
            || system == "i686-freebsd"
            || system == "i686-openbsd"
            || system == "i386-sunos";
      isx86_64 = system == "x86_64-linux"
              || system == "x86_64-darwin"
              || system == "x86_64-freebsd"
              || system == "x86_64-openbsd"
              || system == "x86_64-solaris";
      is64bit = system == "x86_64-linux"
             || system == "x86_64-darwin"
             || system == "x86_64-freebsd"
             || system == "x86_64-openbsd"
             || system == "x86_64-solaris";
      isMips = system == "mips-linux"
            || system == "mips64el-linux";
      isArm = system == "armv5tel-linux"
           || system == "armv6l-linux"
           || system == "armv7l-linux";

      # Whether we should run paxctl to pax-mark binaries.
      needsPax = isLinux;

      inherit mkDerivation;

      # For convenience, bring in the library functions in lib/ so
      # packages don't have to do that themselves.
      inherit lib;

      inherit fetchurlBoot;

      inherit overrides;

      inherit gcc;
    }

    # Propagate any extra attributes.  For instance, we use this to
    # "lift" packages like curl from the final stdenv for Linux to
    # all-packages.nix for that platform (meaning that it has a line
    # like curl = if stdenv ? curl then stdenv.curl else ...).
    // extraAttrs;

in result)
