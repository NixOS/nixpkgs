{
  buildPackages,
  pkgsBuildBuild,
  pkgsBuildTarget,
  pkgs,
  newScope,
  stdenv,
  config,
}:

let
  nativeBignumExcludes = [
    # haskell.compiler sub groups
    "native-bignum"
    # Binary GHCs
    "ghc902Binary"
    "ghc966DebianBinary"
    "ghc984Binary"
    # `ghc/ng`. Two reasons: these are assembled by `ghc/ng/compiler.nix`, which
    # takes no `enableNativeBignum` to override, and they are built with
    # `-fbignum-native` already -- there is no gmp flavour to choose between.
    #
    # The `-tools` and `-stage1` rungs are here for the same reason; they are
    # bootstrap scaffolding, not something to offer a bignum choice for.
    "ghcNG-9_14"
    "ghcNG-9_14-stage1"
    "ghcNG-9_14-tools"
    "ghcNG-head"
    "ghcNG-head-stage1"
    "ghcNG-head-tools"
  ];

  haskellLibUncomposable = import ../development/haskell-modules/lib {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callPackage = newScope {
    haskellLib = haskellLibUncomposable.compose;
    overrides = pkgs.haskell.packageOverrides;
  };

  bootstrapPackageSet = self: super: {
    mkDerivation =
      drv:
      super.mkDerivation (
        drv
        // {
          doCheck = false;
          doHaddock = false;
          enableExecutableProfiling = false;
          enableLibraryProfiling = false;
          enableSharedExecutables = false;
          enableSharedLibraries = false;
        }
      );
  };

  # Use this rather than `rec { ... }` below for sake of overlays.
  inherit (pkgs.haskell) compiler packages;

  # The GHC LLVM backend rarely sees significant changes relating to
  # LLVM version support, as it uses the textual IR format and invokes
  # the LLVM binary tools rather than linking to the C++ libraries.
  #
  # Consider backporting upstream GHC changes to support new LLVM
  # versions in `common-llvm-patches.nix` to allow the version to be
  # shared across our supported versions of GHC. If the required
  # changes are too invasive, it’s fine to decouple individual versions
  # from this default or disable their LLVM support if it’s not load‐
  # bearing (e.g. GHC 9.4.8 is important for cross‐compiling GHC).
  buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_20;
  llvmPackages = pkgs.llvmPackages_20;

  # Note the Nixpkgs default version is chosen in all-packages.nix.
  chooseDefaultVersions = sets: {
    ghc94 = sets.ghc948;
    ghc96 = sets.ghc967;
    ghc98 = sets.ghc984;
    ghc910 = sets.ghc9103;
    ghc912 = sets.ghc9123;
    ghc914 = sets.ghc9141;

    microhs_0_15 = sets.microhs_0_15_4_0;
    microhs = sets.microhs_0_15;
  };

  # The `ghc/ng` releases. Just the source trees and version metadata; the
  # rungs of the bootstrap are ordinary entries in `compiler` and `packages`
  # below, referring to each other through `pkgs.haskell` like everything else.
  #
  # Deliberately not a `let`-bound chain of stages: that would bind each rung's
  # compiler at construction, so nothing downstream could re-bind it -- and
  # `.extend` drops `override`, closing the set entirely. Going through the
  # fixpoint is what keeps it late-bound, and gives the build/host indexing for
  # cross for free.
  ngReleases = pkgs.callPackages ../development/compilers/ghc/ng { };

  ngPackageSet =
    args:
    callPackage ../development/compilers/ghc/ng/package-set.nix (
      { haskellLib = haskellLibUncomposable.compose; } // args
    );

  # The `-tools` and `-stage1` rungs are build-hosted by definition: they are
  # the programs that *build* a compiler, not anything a target ever runs.
  #
  # Splicing nonetheless insists on a host-indexed instance of every attribute
  # in `haskell.packages` and `haskell.compiler`, and merely naming
  # `buildPackages.haskell.compiler."ghcNG-X-stage1"` forces it. On a cross
  # build that instance would need a bootstrap GHC running on the *host*, which
  # hadrian refuses outright:
  #
  #     GHC >= 9.6 can't be cross-compiled.
  #
  # There is no aarch64-hosted `unlit` anyone would want, so rather than define
  # a nonsense rung and let it throw, the host instance simply *is* the build
  # one. Natively the two coincide and this is the identity.
  ngBuildHosted =
    get: mk: name: args:
    if stdenv.buildPlatform == stdenv.hostPlatform then mk args else get buildPackages.haskell name;
  ngToolRung = ngBuildHosted (h: name: h.packages.${name}) ngPackageSet;
  ngToolCompiler = ngBuildHosted (h: name: h.compiler.${name}) ngCompiler;

  ngCompiler = args: callPackage ../development/compilers/ghc/ng/compiler.nix args;
in
{
  lib = haskellLibUncomposable;

  package-list = callPackage ../development/haskell-modules/package-list.nix { };

  # Always get boot compilers from `pkgsBuildBuild`. The boot (stage0) compiler
  # is used to build another compiler (stage1) that'll be used to build the
  # final compiler (stage2) (except when building a cross-compiler). This means
  # that stage1's host platform is the same as stage0: build. Consequently,
  # stage0 needs to be build->build.
  #
  # Note that we use bb.haskell.packages.*. haskell.packages.*.ghc is similar to
  # stdenv: The ghc comes from the previous package set, i.e. this predicate holds:
  # `name: pkgs: pkgs.haskell.packages.${name}.ghc == pkgs.buildPackages.haskell.compiler.${name}.ghc`.
  # This isn't problematic since pkgsBuildBuild.buildPackages is also build->build,
  # just something to keep in mind.
  compiler = pkgs.lib.recurseIntoAttrs (
    let
      bb = pkgsBuildBuild.haskell;
    in
    {
      # Required to bootstrap 9.4.8.
      ghc902Binary = callPackage ../development/compilers/ghc/9.0.2-binary.nix {
        inherit llvmPackages;
      };

      ghc966DebianBinary = callPackage ../development/compilers/ghc/9.6.6-debian-binary.nix { };

      ghc984Binary = callPackage ../development/compilers/ghc/9.8.4-binary.nix { };

      ghc948 = callPackage ../development/compilers/ghc/9.4.8.nix {
        bootPkgs =
          # Building with 9.2 is broken due to
          # https://gitlab.haskell.org/ghc/ghc/-/issues/21914 krank:ignore-line
          bb.packages.ghc902Binary;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc967 = callPackage ../development/compilers/ghc/9.6.7.nix {
        bootPkgs =
          if
            stdenv.buildPlatform.isPower64
            && stdenv.buildPlatform.isBigEndian
            && pkgs.stdenv.hostPlatform.isAbiElfv1
          then
            # No bindist, "borrowing" the GHC from Debian
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isRiscV64 then
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isLoongArch64 then
            bb.packages.ghc966DebianBinary
          else
            bb.packages.ghc948;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc984 = callPackage ../development/compilers/ghc/9.8.4.nix {
        bootPkgs =
          if
            stdenv.buildPlatform.isPower64
            && stdenv.buildPlatform.isBigEndian
            && pkgs.stdenv.hostPlatform.isAbiElfv1
          then
            # No bindist, "borrowing" the GHC from Debian
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isRiscV64 then
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isLoongArch64 then
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isi686 then
            bb.packages.ghc948
          else
            bb.packages.ghc984Binary;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc9103 = callPackage ../development/compilers/ghc/9.10.3.nix {
        bootPkgs =
          if
            stdenv.buildPlatform.isPower64
            && stdenv.buildPlatform.isBigEndian
            && pkgs.stdenv.hostPlatform.isAbiElfv1
          then
            # No bindist, "borrowing" the GHC from Debian
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isRiscV64 then
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isLoongArch64 then
            bb.packages.ghc966DebianBinary
          else if stdenv.buildPlatform.isi686 then
            bb.packages.ghc967
          else
            bb.packages.ghc984Binary;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc9123 = callPackage ../development/compilers/ghc/9.12.3.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc9103;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc9124 = callPackage ../development/compilers/ghc/9.12.4.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc9103;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghc9141 = callPackage ../development/compilers/ghc/9.14.1.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc9103;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };
      ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc910;
        inherit (buildPackages.python3Packages) sphinx;
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        inherit buildTargetLlvmPackages llvmPackages;
      };

      # The split GHC package sets: one derivation per GHC sub-package,
      # built with the ordinary Haskell builder rather than hadrian, and
      # configured by ghc-toolchain rather than autoconf. See
      # ../development/compilers/ghc/ng/README.md.
      #
      # `ghc/ng`. The stage1 compilers are "weird" entries in the same sense as
      # the binary GHCs above: nobody would choose one, they exist because the
      # boot libraries cannot be built by the bootstrap compiler. See
      # ../development/compilers/ghc/ng/README.md.
      #
      # Each is assembled from the rung of the same name in `packages`. Note
      # which side of the build/host line each argument comes from:
      #
      #   packages   the rung itself, *host*-indexed -- the shipped compiler
      #              runs on the host, so its driver must be a host binary.
      #   toolsPkgs  always build-hosted: `ghc-toolchain-bin` probes the target
      #              but runs here, and stage1's `unlit` likewise.
      #
      # That is the `_wrappers` off-by-one, spelled out.
      "ghcNG-9_14-stage1" = ngToolCompiler "ghcNG-9_14-stage1" {
        ghcVersion = ngReleases."9.14";
        stage = "stage1";
        packages = packages."ghcNG-9_14-stage1";
        toolsPkgs = buildPackages.haskell.packages."ghcNG-9_14-tools";
      };
      "ghcNG-head-stage1" = ngToolCompiler "ghcNG-head-stage1" {
        ghcVersion = ngReleases.head;
        stage = "stage1";
        packages = packages."ghcNG-head-stage1";
        toolsPkgs = buildPackages.haskell.packages."ghcNG-head-tools";
      };

      "ghcNG-9_14" = ngCompiler {
        ghcVersion = ngReleases."9.14";
        stage = "stage2";
        packages = packages."ghcNG-9_14";
        toolsPkgs = buildPackages.haskell.packages."ghcNG-9_14-tools";
        # The shipped `ghc-pkg` is a host binary; on a cross build it cannot run
        # here, so the database is maintained with the stage1 compiler's copy,
        # which is build-hosted and the same GHC version.
        buildGhcPkg =
          if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
            null
          else
            buildPackages.haskell.compiler."ghcNG-9_14-stage1";
      };
      "ghcNG-head" = ngCompiler {
        ghcVersion = ngReleases.head;
        stage = "stage2";
        packages = packages."ghcNG-head";
        toolsPkgs = buildPackages.haskell.packages."ghcNG-head-tools";
        buildGhcPkg =
          if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
            null
          else
            buildPackages.haskell.compiler."ghcNG-head-stage1";
      };

      # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
      # with "native" and "gmp" backends.
      native-bignum =
        let
          isNativeBignumGhc =
            name: pkgs.lib.hasPrefix "ghc" name && !(builtins.elem name nativeBignumExcludes);
          nativeBignumGhcNames = pkgs.lib.filter isNativeBignumGhc (pkgs.lib.attrNames compiler);
        in
        pkgs.lib.recurseIntoAttrs (
          pkgs.lib.genAttrs nativeBignumGhcNames (
            name: compiler.${name}.override { enableNativeBignum = true; }
          )
        );

      microhs-boot = callPackage ../development/compilers/microhs/boot.nix {
        microhs-src = bb.compiler.microhs_0_15_4_0;
      };

      microhs_0_15_4_0 = callPackage ../development/compilers/microhs/0.15.4.0.nix {
        inherit (bb.compiler) microhs-boot;
      };
    }
    // chooseDefaultVersions compiler
    // pkgs.lib.optionalAttrs config.allowAliases {
      ghc810 = throw "'haskell.compiler.ghc810' has been removed."; # Added 2025-09-07
      ghc90 = throw "'haskell.compiler.ghc90' has been removed."; # Added 2025-09-07
      ghc92 = throw "'haskell.compiler.ghc92' has been removed."; # Added 2025-09-07
      ghcjs = throw "'haskell.compiler.ghcjs' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      ghcjs810 = throw "'haskell.compiler.ghcjs810' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      integer-simple = throw "All GHC versions with integer-simple support have been removed."; # Added 2025-09-07
    }
  );

  # Default overrides that are applied to all package sets.
  packageOverrides = self: super: { };

  # Always get compilers from `buildPackages`
  packages =
    let
      bh = buildPackages.haskell;
    in
    {
      ghc902Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc902Binary;
        ghc = bh.compiler.ghc902Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc966DebianBinary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc966DebianBinary;
        ghc = bh.compiler.ghc966DebianBinary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc984Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc984Binary;
        ghc = bh.compiler.ghc984Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc948 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc948;
        ghc = bh.compiler.ghc948;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
      };
      ghc967 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc967;
        ghc = bh.compiler.ghc967;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc984 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc984;
        ghc = bh.compiler.ghc984;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc9103 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9103;
        ghc = bh.compiler.ghc9103;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.10.x.nix { };
      };
      ghc9123 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9123;
        ghc = bh.compiler.ghc9123;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.12.x.nix { };
      };
      ghc9124 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9124;
        ghc = bh.compiler.ghc9124;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.12.x.nix { };
      };
      ghc9141 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9141;
        ghc = bh.compiler.ghc9141;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.14.x.nix { };
      };
      ghcHEAD = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghcHEAD;
        ghc = bh.compiler.ghcHEAD;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.16.x.nix { };
      };

      # `ghc/ng`: the rungs of the bootstrap, as ordinary package sets. Each is
      # an ordinary Hackage set with the GHC-tree packages and the pinned core
      # versions layered on as overlays -- `base`, `rts` and `ghc` are real
      # derivations here, where a `configuration-ghc-*.nix` set would leave
      # `null`s on the premise that the compiler ships them. This is where they
      # are built.
      #
      # The `-tools` and `-stage1` sets are "weird" in the same sense as the
      # binary GHCs in `compiler`: bootstrap scaffolding rather than something
      # to use. Each rung takes its compiler from `buildPackages`, one rung
      # down, which is the whole chain:
      #
      #   -tools, -stage1   built by the bootstrap compiler (ghc9103)
      #   (unsuffixed)      built by `compiler."ghcNG-X-stage1"`
      "ghcNG-9_14-tools" = ngToolRung "ghcNG-9_14-tools" {
        ghcVersion = ngReleases."9.14";
        stage = "tools";
        basePkgs = packages.ghc9103;
      };
      "ghcNG-9_14-stage1" = ngToolRung "ghcNG-9_14-stage1" {
        ghcVersion = ngReleases."9.14";
        stage = "stage1";
        basePkgs = packages.ghc9103;
        toolsPkgs = bh.packages."ghcNG-9_14-tools";
      };
      "ghcNG-9_14" = ngPackageSet {
        ghcVersion = ngReleases."9.14";
        stage = "stage2";
        # Host-indexed, so a cross build gives these a cross `stdenv` -- and so
        # `generic-builder` an `isCross` of true, and Cabal a `--with-gcc`
        # naming the cross compiler rather than the bare `gcc` on `PATH`.
        basePkgs = packages.ghc9103;
        toolsPkgs = bh.packages."ghcNG-9_14-tools";
        ghc = bh.compiler."ghcNG-9_14-stage1";
      };

      "ghcNG-head-tools" = ngToolRung "ghcNG-head-tools" {
        ghcVersion = ngReleases.head;
        stage = "tools";
        basePkgs = packages.ghc9103;
      };
      "ghcNG-head-stage1" = ngToolRung "ghcNG-head-stage1" {
        ghcVersion = ngReleases.head;
        stage = "stage1";
        basePkgs = packages.ghc9103;
        toolsPkgs = bh.packages."ghcNG-head-tools";
      };
      "ghcNG-head" = ngPackageSet {
        ghcVersion = ngReleases.head;
        stage = "stage2";
        basePkgs = packages.ghc9103;
        toolsPkgs = bh.packages."ghcNG-head-tools";
        ghc = bh.compiler."ghcNG-head-stage1";
      };

      native-bignum =
        let
          nativeBignumGhcNames = pkgs.lib.filter (name: !(builtins.elem name nativeBignumExcludes)) (
            pkgs.lib.attrNames packages
          );
        in
        pkgs.lib.genAttrs nativeBignumGhcNames (
          name:
          packages.${name}.override {
            ghc = bh.compiler.native-bignum.${name};
            buildHaskellPackages = bh.packages.native-bignum.${name};
          }
        );

      microhs_0_15_4_0 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.microhs_0_15_4_0;
        ghc = bh.compiler.microhs_0_15_4_0;
        compilerConfig = callPackage ../development/haskell-modules/configuration-microhs.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
    }
    // chooseDefaultVersions packages
    // pkgs.lib.optionalAttrs config.allowAliases {
      ghc810 = throw "'haskell.packages.ghc810' has been removed."; # Added 2025-09-07
      ghc90 = throw "'haskell.packages.ghc90' has been removed."; # Added 2025-09-07
      ghc92 = throw "'haskell.packages.ghc92' has been removed."; # Added 2025-09-07
      ghcjs = throw "'haskell.packages.ghcjs' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      ghcjs810 = throw "'haskell.packages.ghcjs810' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      integer-simple = throw "All GHC versions with integer-simple support have been removed."; # Added 2025-09-07
    };
}
