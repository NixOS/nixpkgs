let lib = import ../../../lib; in lib.makeOverridable (

{ system, name ? "stdenv", preHook ? "", initialPath, cc, shell
, allowedRequisites ? null, extraAttrs ? {}, overrides ? (pkgs: {}), config

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot

, setupScript ? ./setup.sh

, extraBuildInputs ? []
, __stdenvImpureHostDeps ? []
, __extraImpureHostDeps ? []
}:

let

  allowUnfree = config.allowUnfree or false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";

  whitelist = config.whitelistedLicenses or [];
  blacklist = config.blacklistedLicenses or [];

  ifDarwin = attrs: if system == "x86_64-darwin" then attrs else {};

  onlyLicenses = list:
    lib.lists.all (license:
      let l = lib.licenses.${license.shortName or "BROKEN"} or false; in
      if license == l then true else
        throw ''‘${showLicense license}’ is not an attribute of lib.licenses''
    ) list;

  mutuallyExclusive = a: b:
    (builtins.length a) == 0 ||
    (!(builtins.elem (builtins.head a) b) &&
     mutuallyExclusive (builtins.tail a) b);

  areLicenseListsValid =
    if mutuallyExclusive whitelist blacklist then
      assert onlyLicenses whitelist; assert onlyLicenses blacklist; true
    else
      throw "whitelistedLicenses and blacklistedLicenses are not mutually exclusive.";

  hasLicense = attrs:
    builtins.hasAttr "meta" attrs && builtins.hasAttr "license" attrs.meta;

  hasWhitelistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license whitelist;

  hasBlacklistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license blacklist;

  allowBroken = config.allowBroken or false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

  isUnfree = licenses: lib.lists.any (l:
    !l.free or true || l == "unfree" || l == "unfree-redistributable") licenses;

  # Alow granular checks to allow only some unfree packages
  # Example:
  # {pkgs, ...}:
  # {
  #   allowUnfree = false;
  #   allowUnfreePredicate = (x: pkgs.lib.hasPrefix "flashplayer-" x.name);
  # }
  allowUnfreePredicate = config.allowUnfreePredicate or (x: false);

  # Check whether unfree packages are allowed and if not, whether the
  # package has an unfree license and is not explicitely allowed by the
  # `allowUNfreePredicate` function.
  hasDeniedUnfreeLicense = attrs:
    !allowUnfree &&
    hasLicense attrs &&
    isUnfree (lib.lists.toList attrs.meta.license) &&
    !allowUnfreePredicate attrs;

  showLicense = license: license.shortName or "unknown";

  defaultNativeBuildInputs = extraBuildInputs ++
    [ ../../build-support/setup-hooks/move-docs.sh
      ../../build-support/setup-hooks/compress-man-pages.sh
      ../../build-support/setup-hooks/strip.sh
      ../../build-support/setup-hooks/patch-shebangs.sh
      ../../build-support/setup-hooks/move-sbin.sh
      ../../build-support/setup-hooks/move-lib64.sh
      cc
    ];

  # Add a utility function to produce derivations that use this
  # stdenv and its shell.
  mkDerivation =
    { buildInputs ? []
    , nativeBuildInputs ? []
    , propagatedBuildInputs ? []
    , propagatedNativeBuildInputs ? []
    , crossConfig ? null
    , meta ? {}
    , passthru ? {}
    , pos ? null # position used in error messages and for meta.position
    , ... } @ attrs:
    let
      pos' =
        if pos != null then
          pos
        else if attrs.meta.description or null != null then
          builtins.unsafeGetAttrPos "description" attrs.meta
        else
          builtins.unsafeGetAttrPos "name" attrs;
      pos'' = if pos' != null then "‘" + pos'.file + ":" + toString pos'.line + "’" else "«unknown-file»";

      throwEvalHelp = unfreeOrBroken: whatIsWrong:
        assert builtins.elem unfreeOrBroken ["Unfree" "Broken" "blacklisted"];

        throw ("Package ‘${attrs.name or "«name-missing»"}’ in ${pos''} ${whatIsWrong}, refusing to evaluate."
        + (lib.strings.optionalString (unfreeOrBroken != "blacklisted") ''

          For `nixos-rebuild` you can set
            { nixpkgs.config.allow${unfreeOrBroken} = true; }
          in configuration.nix to override this.
          For `nix-env` you can add
            { allow${unfreeOrBroken} = true; }
          to ~/.nixpkgs/config.nix.
        ''));

      licenseAllowed = attrs:
        if hasDeniedUnfreeLicense attrs && !(hasWhitelistedLicense attrs) then
          throwEvalHelp "Unfree" "has an unfree license (‘${showLicense attrs.meta.license}’)"
        else if hasBlacklistedLicense attrs then
          throwEvalHelp "blacklisted" "has a blacklisted license (‘${showLicense attrs.meta.license}’)"
        else if !allowBroken && attrs.meta.broken or false then
          throwEvalHelp "Broken" "is marked as broken"
        else if !allowBroken && attrs.meta.platforms or null != null && !lib.lists.elem result.system attrs.meta.platforms then
          throwEvalHelp "Broken" "is not supported on ‘${result.system}’"
        else true;

    in
      assert licenseAllowed attrs;

      lib.addPassthru (derivation (
        (removeAttrs attrs
          ["meta" "passthru" "crossAttrs" "pos"
           "__impureHostDeps" "__propagatedImpureHostDeps"])
        // (let
          buildInputs = attrs.buildInputs or [];
          nativeBuildInputs = attrs.nativeBuildInputs or [];
          propagatedBuildInputs = attrs.propagatedBuildInputs or [];
          propagatedNativeBuildInputs = attrs.propagatedNativeBuildInputs or [];
          crossConfig = attrs.crossConfig or null;

          __impureHostDeps = attrs.__impureHostDeps or [];
          __propagatedImpureHostDeps = attrs.__propagatedImpureHostDeps or [];

          # TODO: remove lib.unique once nix has a list canonicalization primitive
          computedImpureHostDeps           = lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (extraBuildInputs ++ buildInputs ++ nativeBuildInputs));
          computedPropagatedImpureHostDeps = lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (propagatedBuildInputs ++ propagatedNativeBuildInputs));
        in
        {
          builder = attrs.realBuilder or shell;
          args = attrs.args or ["-e" (attrs.builder or ./default-builder.sh)];
          stdenv = result;
          system = result.system;
          userHook = config.stdenv.userHook or null;
          __ignoreNulls = true;

          # Inputs built by the cross compiler.
          buildInputs = if crossConfig != null then buildInputs else [];
          propagatedBuildInputs = if crossConfig != null then propagatedBuildInputs else [];
          # Inputs built by the usual native compiler.
          nativeBuildInputs = nativeBuildInputs ++ (if crossConfig == null then buildInputs else []);
          propagatedNativeBuildInputs = propagatedNativeBuildInputs ++
            (if crossConfig == null then propagatedBuildInputs else []);
        } // ifDarwin {
          __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ __extraImpureHostDeps ++ [
            "/dev/zero"
            "/dev/random"
            "/dev/urandom"
            "/bin/sh"
          ];
          __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
        }))) (
      {
        # The meta attribute is passed in the resulting attribute set,
        # but it's not part of the actual derivation, i.e., it's not
        # passed to the builder and is not a dependency.  But since we
        # include it in the result, it *is* available to nix-env for
        # queries.  We also a meta.position attribute here to
        # identify the source location of the package.
        meta = meta // (if pos' != null then {
          position = pos'.file + ":" + toString pos'.line;
        } else {});
        inherit passthru;
      } //
      # Pass through extra attributes that are not inputs, but
      # should be made available to Nix expressions using the
      # derivation (e.g., in assertions).
      passthru);

  # The stdenv that we are producing.
  result =
    derivation (
    (if isNull allowedRequisites then {} else { allowedRequisites = allowedRequisites ++ defaultNativeBuildInputs; }) //
    {
      inherit system name;

      builder = shell;

      args = ["-e" ./builder.sh];

      setup = setupScript;

      inherit preHook initialPath shell defaultNativeBuildInputs;
    }
    // ifDarwin {
      __impureHostDeps = __stdenvImpureHostDeps;
    })

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
      isi686 = system == "i686-linux"
            || system == "i686-gnu"
            || system == "i686-freebsd"
            || system == "i686-openbsd"
            || system == "i686-cygwin"
            || system == "i386-sunos";
      isx86_64 = system == "x86_64-linux"
              || system == "x86_64-darwin"
              || system == "x86_64-freebsd"
              || system == "x86_64-openbsd"
              || system == "x86_64-cygwin"
              || system == "x86_64-solaris";
      is64bit = system == "x86_64-linux"
             || system == "x86_64-darwin"
             || system == "x86_64-freebsd"
             || system == "x86_64-openbsd"
             || system == "x86_64-cygwin"
             || system == "x86_64-solaris"
             || system == "mips64el-linux";
      isMips = system == "mips-linux"
            || system == "mips64el-linux";
      isArm = system == "armv5tel-linux"
           || system == "armv6l-linux"
           || system == "armv7l-linux";
      isBigEndian = system == "powerpc-linux";

      # Whether we should run paxctl to pax-mark binaries.
      needsPax = isLinux;

      inherit mkDerivation;

      # For convenience, bring in the library functions in lib/ so
      # packages don't have to do that themselves.
      inherit lib;

      inherit fetchurlBoot;

      inherit overrides;

      inherit cc;
    }

    # Propagate any extra attributes.  For instance, we use this to
    # "lift" packages like curl from the final stdenv for Linux to
    # all-packages.nix for that platform (meaning that it has a line
    # like curl = if stdenv ? curl then stdenv.curl else ...).
    // extraAttrs;

in result)
