let lib = import ../../../lib; in lib.makeOverridable (

{ name ? "stdenv", preHook ? "", initialPath, cc, shell
, allowedRequisites ? null, extraAttrs ? {}, overrides ? (self: super: {}), config

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot

, setupScript ? ./setup.sh

, extraBuildInputs ? []
, __stdenvImpureHostDeps ? []
, __extraImpureHostDeps ? []
, stdenvSandboxProfile ? ""
, extraSandboxProfile ? ""

, # The platforms here do *not* correspond to the stage the stdenv is
  # used in, but rather the previous one, in which it was built. We
  # use the latter two platforms, like a cross compiler, because the
  # stand environment is a build tool if you squint at it, and because
  # neither of these are used when building stdenv so we know the
  # build platform is irrelevant.
  hostPlatform, targetPlatform
}:

let
  inherit (targetPlatform) system;

  ifDarwin = attrs: if system == "x86_64-darwin" then attrs else {};

  defaultNativeBuildInputs = extraBuildInputs ++
    [ ../../build-support/setup-hooks/move-docs.sh
      ../../build-support/setup-hooks/compress-man-pages.sh
      ../../build-support/setup-hooks/strip.sh
      ../../build-support/setup-hooks/patch-shebangs.sh
    ]
      # FIXME this on Darwin; see
      # https://github.com/NixOS/nixpkgs/commit/94d164dd7#commitcomment-22030369
    ++ lib.optional result.isLinux ../../build-support/setup-hooks/audit-tmpdir.sh
    ++ [
      ../../build-support/setup-hooks/multiple-outputs.sh
      ../../build-support/setup-hooks/move-sbin.sh
      ../../build-support/setup-hooks/move-lib64.sh
      ../../build-support/setup-hooks/set-source-date-epoch-to-latest.sh
      cc
    ];

  # `mkDerivation` wraps the builtin `derivation` function to
  # produce derivations that use this stdenv and its shell.
  #
  # See also:
  #
  # * https://nixos.org/nixpkgs/manual/#sec-using-stdenv
  #   Details on how to use this mkDerivation function
  #
  # * https://nixos.org/nix/manual/#ssec-derivation
  #   Explanation about derivations in general
  mkDerivation =
    { nativeBuildInputs ? []
    , buildInputs ? []

    , propagatedNativeBuildInputs ? []
    , propagatedBuildInputs ? []

    , crossConfig ? null
    , meta ? {}
    , passthru ? {}
    , pos ? # position used in error messages and for meta.position
        (if attrs.meta.description or null != null
          then builtins.unsafeGetAttrPos "description" attrs.meta
          else builtins.unsafeGetAttrPos "name" attrs)
    , separateDebugInfo ? false
    , outputs ? [ "out" ]
    , __impureHostDeps ? []
    , __propagatedImpureHostDeps ? []
    , sandboxProfile ? ""
    , propagatedSandboxProfile ? ""
    , ... } @ attrs:
    let
      dependencies = [
        (map (drv: drv.nativeDrv or drv) nativeBuildInputs)
        (map (drv: drv.crossDrv or drv) buildInputs)
      ];
      propagatedDependencies = [
        (map (drv: drv.nativeDrv or drv) propagatedNativeBuildInputs)
        (map (drv: drv.crossDrv or drv) propagatedBuildInputs)
      ];
    in let

      outputs' =
        outputs ++
        (if separateDebugInfo then assert targetPlatform.isLinux; [ "debug" ] else []);

      dependencies' = let
          justMap = map lib.chooseDevOutputs dependencies;
          nativeBuildInputs = lib.elemAt justMap 0
            ++ lib.optional targetPlatform.isWindows ../../build-support/setup-hooks/win-dll-link.sh;
          buildInputs = lib.elemAt justMap 1
               # TODO(@Ericson2314): Should instead also be appended to `nativeBuildInputs`.
            ++ lib.optional separateDebugInfo ../../build-support/setup-hooks/separate-debug-info.sh;
        in [ nativeBuildInputs buildInputs ];

      propagatedDependencies' = map lib.chooseDevOutputs propagatedDependencies;

      derivationArg =
        (removeAttrs attrs
          ["meta" "passthru" "crossAttrs" "pos"
           "__impureHostDeps" "__propagatedImpureHostDeps"
           "sandboxProfile" "propagatedSandboxProfile"])
        // (let
          # TODO(@Ericson2314): Reversing of dep lists is just temporary to avoid Darwin mass rebuild.
          computedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (extraBuildInputs ++ lib.concatLists (lib.reverseList dependencies'));
          computedPropagatedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (lib.concatLists (lib.reverseList propagatedDependencies'));
          computedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (extraBuildInputs ++ lib.concatLists (lib.reverseList dependencies')));
          computedPropagatedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (lib.concatLists (lib.reverseList propagatedDependencies')));
        in
        {
          builder = attrs.realBuilder or shell;
          args = attrs.args or ["-e" (attrs.builder or ./default-builder.sh)];
          stdenv = result;
          system = result.system;
          userHook = config.stdenv.userHook or null;
          __ignoreNulls = true;

          nativeBuildInputs = lib.elemAt dependencies' 0;
          buildInputs = lib.elemAt dependencies' 1;

          propagatedNativeBuildInputs = lib.elemAt propagatedDependencies' 0;
          propagatedBuildInputs = lib.elemAt propagatedDependencies' 1;
        } // ifDarwin {
          # TODO: remove lib.unique once nix has a list canonicalization primitive
          __sandboxProfile =
          let profiles = [ extraSandboxProfile ] ++ computedSandboxProfile ++ computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile sandboxProfile ];
              final = lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.unique profiles));
          in final;
          __propagatedSandboxProfile = lib.unique (computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile ]);
          __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ __extraImpureHostDeps ++ [
            "/dev/zero"
            "/dev/random"
            "/dev/urandom"
            "/bin/sh"
          ];
          __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
        } // (if outputs' != [ "out" ] then {
          outputs = outputs';
        } else { }));

      # The meta attribute is passed in the resulting attribute set,
      # but it's not part of the actual derivation, i.e., it's not
      # passed to the builder and is not a dependency.  But since we
      # include it in the result, it *is* available to nix-env for queries.
      meta = { }
          # If the packager hasn't specified `outputsToInstall`, choose a default,
          # which is the name of `p.bin or p.out or p`;
          # if he has specified it, it will be overridden below in `// meta`.
          #   Note: This default probably shouldn't be globally configurable.
          #   Services and users should specify outputs explicitly,
          #   unless they are comfortable with this default.
        // { outputsToInstall =
          let
            outs = outputs'; # the value passed to derivation primitive
            hasOutput = out: builtins.elem out outs;
          in [( lib.findFirst hasOutput null (["bin" "out"] ++ outs) )];
        }
        // attrs.meta or {}
          # Fill `meta.position` to identify the source location of the package.
        // lib.optionalAttrs (pos != null)
          { position = pos.file + ":" + toString pos.line; }
        ;

    in

      lib.addPassthru
        (derivation (import ./check-meta.nix
          {
            inherit lib config meta derivationArg;
            mkDerivationArg = attrs;
            inherit system; # TODO: cross-compilation?
          }))
        ( {
            overrideAttrs = f: mkDerivation (attrs // (f attrs));
            inherit meta passthru;
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
      __sandboxProfile = stdenvSandboxProfile;
      __impureHostDeps = __stdenvImpureHostDeps;
    })

    // rec {

      meta = {
        description = "The default build environment for Unix packages in Nixpkgs";
        platforms = lib.platforms.all;
      };

      # Utility flags to test the type of platform.
      inherit (hostPlatform)
        isDarwin isLinux isSunOS isHurd isCygwin isFreeBSD isOpenBSD
        isi686 isx86_64 is64bit isMips isBigEndian;
      isArm = hostPlatform.isArm32;
      isAarch64 = hostPlatform.isArm64;

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
