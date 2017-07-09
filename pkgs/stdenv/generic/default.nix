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

  ## Platform parameters
  ##
  ## The "build" "host" "target" terminology below comes from GNU Autotools. See
  ## its documentation for more information on what those words mean. Note that
  ## each should always be defined, even when not cross compiling.
  ##
  ## For purposes of bootstrapping, think of each stage as a "sliding window"
  ## over a list of platforms. Specifically, the host platform of the previous
  ## stage becomes the build platform of the current one, and likewise the
  ## target platform of the previous stage becomes the host platform of the
  ## current one.
  ##

, # The platform on which packages are built. Consists of `system`, a
  # string (e.g.,`i686-linux') identifying the most import attributes of the
  # build platform, and `platform` a set of other details.
  buildPlatform

, # The platform on which packages run.
  hostPlatform

, # The platform which build tools (especially compilers) build for in this stage,
  targetPlatform
}:

let
  defaultNativeBuildInputs = extraBuildInputs ++
    [ ../../build-support/setup-hooks/move-docs.sh
      ../../build-support/setup-hooks/compress-man-pages.sh
      ../../build-support/setup-hooks/strip.sh
      ../../build-support/setup-hooks/patch-shebangs.sh
    ]
      # FIXME this on Darwin; see
      # https://github.com/NixOS/nixpkgs/commit/94d164dd7#commitcomment-22030369
    ++ lib.optional hostPlatform.isLinux ../../build-support/setup-hooks/audit-tmpdir.sh
    ++ [
      ../../build-support/setup-hooks/multiple-outputs.sh
      ../../build-support/setup-hooks/move-sbin.sh
      ../../build-support/setup-hooks/move-lib64.sh
      ../../build-support/setup-hooks/set-source-date-epoch-to-latest.sh
      cc
    ];

  # The stdenv that we are producing.
  stdenv =
    derivation (
    (if isNull allowedRequisites then {} else { allowedRequisites = allowedRequisites ++ defaultNativeBuildInputs; }) //
    {
      inherit name;

      # Nix itself uses the `system` field of a derivation to decide where to
      # build it. This is a bit confusing for cross compilation.
      inherit (buildPlatform) system;

      builder = shell;

      args = ["-e" ./builder.sh];

      setup = setupScript;

      inherit preHook initialPath shell defaultNativeBuildInputs;
    }
    // lib.optionalAttrs buildPlatform.isDarwin {
      __sandboxProfile = stdenvSandboxProfile;
      __impureHostDeps = __stdenvImpureHostDeps;
    })

    // rec {

      meta = {
        description = "The default build environment for Unix packages in Nixpkgs";
        platforms = lib.platforms.all;
      };

      inherit buildPlatform hostPlatform targetPlatform;

      inherit extraBuildInputs __extraImpureHostDeps extraSandboxProfile;

      # Utility flags to test the type of platform.
      inherit (hostPlatform)
        isDarwin isLinux isSunOS isHurd isCygwin isFreeBSD isOpenBSD
        isi686 isx86_64 is64bit isMips isBigEndian;
      isArm = hostPlatform.isArm32;
      isAarch64 = hostPlatform.isArm64;

      # Whether we should run paxctl to pax-mark binaries.
      needsPax = isLinux;

      inherit (import ./make-derivation.nix {
        inherit lib config stdenv;
      }) mkDerivation;

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

in stdenv)
