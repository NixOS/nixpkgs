let lib = import ../../../lib; stdenv-overridable = lib.makeOverridable (

argsStdenv@{ name ? "stdenv", preHook ? "", initialPath

, # If we don't have a C compiler, we might either have `cc = null` or `cc =
  # throw ...`, but if we do have a C compiler we should definiely have `cc !=
  # null`.
  #
  # TODO(@Ericson2314): Add assert without creating infinite recursion
  hasCC ? cc != null, cc

, shell
, allowedRequisites ? null, extraAttrs ? {}, overrides ? (self: super: {}), config
, disallowedRequisites ? []

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot

, setupScript ? ./setup.sh

, extraNativeBuildInputs ? []
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

, # The implementation of `mkDerivation`, parameterized with the final stdenv so we can tie the knot.
  # This is convient to have as a parameter so the stdenv "adapters" work better
  mkDerivationFromStdenv ? import ./make-derivation.nix { inherit lib config; }
}:

let
  defaultNativeBuildInputs = extraNativeBuildInputs ++
    [
      ../../build-support/setup-hooks/audit-tmpdir.sh
      ../../build-support/setup-hooks/compress-man-pages.sh
      ../../build-support/setup-hooks/make-symlinks-relative.sh
      ../../build-support/setup-hooks/move-docs.sh
      ../../build-support/setup-hooks/move-lib64.sh
      ../../build-support/setup-hooks/move-sbin.sh
      ../../build-support/setup-hooks/move-systemd-user-units.sh
      ../../build-support/setup-hooks/multiple-outputs.sh
      ../../build-support/setup-hooks/patch-shebangs.sh
      ../../build-support/setup-hooks/prune-libtool-files.sh
      ../../build-support/setup-hooks/reproducible-builds.sh
      ../../build-support/setup-hooks/set-source-date-epoch-to-latest.sh
      ../../build-support/setup-hooks/strip.sh
    ] ++ lib.optionals hasCC [ cc ];

  defaultBuildInputs = extraBuildInputs;

  stdenv = (stdenv-overridable argsStdenv);

  # The stdenv that we are producing.
  in
    derivation (
    lib.optionalAttrs (allowedRequisites != null) {
      allowedRequisites = allowedRequisites
        ++ defaultNativeBuildInputs ++ defaultBuildInputs;
    }
    // lib.optionalAttrs config.contentAddressedByDefault {
      __contentAddressed = true;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    }
    // {
      inherit name;
      inherit disallowedRequisites;

      # Nix itself uses the `system` field of a derivation to decide where to
      # build it. This is a bit confusing for cross compilation.
      inherit (buildPlatform) system;

      builder = shell;

      args = ["-e" ./builder.sh];

      setup = setupScript;

      # We pretty much never need rpaths on Darwin, since all library path references
      # are absolute unless we go out of our way to make them relative (like with CF)
      # TODO: This really wants to be in stdenv/darwin but we don't have hostPlatform
      # there (yet?) so it goes here until then.
      preHook = preHook + lib.optionalString buildPlatform.isDarwin ''
        export NIX_DONT_SET_RPATH_FOR_BUILD=1
      '' + lib.optionalString (hostPlatform.isDarwin || (hostPlatform.parsed.kernel.execFormat != lib.systems.parse.execFormats.elf && hostPlatform.parsed.kernel.execFormat != lib.systems.parse.execFormats.macho)) ''
        export NIX_DONT_SET_RPATH=1
        export NIX_NO_SELF_RPATH=1
      '' + lib.optionalString (hostPlatform.isDarwin && hostPlatform.isMacOS) ''
        export MACOSX_DEPLOYMENT_TARGET=${hostPlatform.darwinMinVersion}
      ''
      # TODO this should be uncommented, but it causes stupid mass rebuilds. I
      # think the best solution would just be to fixup linux RPATHs so we don't
      # need to set `-rpath` anywhere.
      # + lib.optionalString targetPlatform.isDarwin ''
      #   export NIX_DONT_SET_RPATH_FOR_TARGET=1
      # ''
      ;

      inherit initialPath shell
        defaultNativeBuildInputs defaultBuildInputs;
    }
    // lib.optionalAttrs buildPlatform.isDarwin {
      __sandboxProfile = stdenvSandboxProfile;
      __impureHostDeps = __stdenvImpureHostDeps;
    })

    // {

      meta = {
        description = "The default build environment for Unix packages in Nixpkgs";
        platforms = lib.platforms.all;
      };

      inherit buildPlatform hostPlatform targetPlatform;

      inherit extraNativeBuildInputs extraBuildInputs
        __extraImpureHostDeps extraSandboxProfile;

      # Utility flags to test the type of platform.
      inherit (hostPlatform)
        isDarwin isLinux isSunOS isCygwin isBSD isFreeBSD isOpenBSD
        isi686 isx86_32 isx86_64
        is32bit is64bit
        isAarch32 isAarch64 isMips isBigEndian;

      # Override `system` so that packages can get the system of the host
      # platform through `stdenv.system`. `system` is originally set to the
      # build platform within the derivation above so that Nix directs the build
      # to correct type of machine.
      inherit (hostPlatform) system;

      mkDerivation = mkDerivationFromStdenv stdenv;

      inherit fetchurlBoot;

      inherit overrides;

      inherit cc hasCC;

      # Convenience for doing some very basic shell syntax checking by parsing a script
      # without running any commands. Because this will also skip `shopt -s extglob`
      # commands and extglob affects the Bash parser, we enable extglob always.
      shellDryRun = "${stdenv.shell} -n -O extglob";

      tests = {
        succeedOnFailure = import ../tests/succeedOnFailure.nix { inherit stdenv; };
      };
      passthru.tests = lib.warn "Use `stdenv.tests` instead. `passthru` is a `mkDerivation` detail." stdenv.tests;
    }

    # Propagate any extra attributes.  For instance, we use this to
    # "lift" packages like curl from the final stdenv for Linux to
    # all-packages.nix for that platform (meaning that it has a line
    # like curl = if stdenv ? curl then stdenv.curl else ...).
    // extraAttrs
); in stdenv-overridable
