{
  buildPackages,
  pkgsBuildBuild,
  pkgsBuildTarget,
  pkgs,
  newScope,
  stdenv,
  lib,
}:

let
  # These are attributes in compiler that support integer-simple.
  integerSimpleIncludes = [
    "ghc88"
    "ghc884"
    "ghc810"
    "ghc8107"
  ];

  # Matches all attributes in compiler that support native-bignum only builds
  nativeBignumIncludePred =
    name:
    !(
      lib.hasSuffix "Binary" name
      || lib.hasPrefix "ghcjs" name
      || lib.elem name integerSimpleIncludes
      || lib.elem name [
        # haskell.compiler sub groups
        "integer-simple"
        "native-bignum"
      ]
    );

  callPackage = newScope {
    haskellLib = pkgs.haskell.lib.compose;
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

  # - We refer to the first two parts of released GHC's version numbers as
  #   release series, e.g. "9.8".
  # - The second part is always even for releases (and alphas/release candidates),
  #   GHCs master branch uses an odd part.
  # - In nixpkgs all common infrastructure is identified by the (stable) release
  #   series. Uneven version numbers (e.g. ghcHEAD) should use the next even
  #   one for identifying configurations etc. to use.
  #
  # To aid with this toGhcReleaseSeriesVersion takes a full GHC version number
  # and returns the matching (even) release series.
  toGhcReleaseSeriesVersion =
    version:
    let
      parts = lib.splitVersion version;
    in
    lib.concatStringsSep "." (
      lib.genList (
        i:
        let
          part = lib.elemAt parts i;
          parsed = lib.toInt part;
        in
        if i == 1 && lib.mod parsed 2 == 1 then toString (parsed + 1) else part
      ) (lib.length parts)
    );

  # Given a list of version components (think builtins.splitVersion) return
  # all matching rules from ghcRules, merged by precedence.
  #
  # Rules match if their version is the same exactly or
  # if the rule's attribute name is a prefix of the given GHC version.
  # Longer matching prefixes takes precedence.
  matchGhcRules =
    versionParts:
    let
      version = lib.concatStringsSep "." versionParts;
    in
    lib.pipe ghcRules # see below
      [
        (lib.filterAttrs (
          versionPrefix: _: versionPrefix == version || lib.hasPrefix "${versionPrefix}." version
        ))
        builtins.attrValues
        # Thanks to lexical ordering, rules with a longer matching prefix will take precedence.
        # ATTN: This merging behavior is not exercised by current (2025-01-30) code.
        lib.mergeAttrsList
      ];

  makeGhc =
    filename:
    {
      bootPkgsAttr,
      llvmVersion,
      python3Attr ? "python3",
      ...
    }:
    callPackage filename {
      # Note [GHC boot pkgsBuildBuild]
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
      bootPkgs = pkgsBuildBuild.haskell.packages.${bootPkgsAttr};
      llvmPackages = pkgs."llvmPackages_${toString llvmVersion}";
      buildTargetLlvmPackages = pkgsBuildTarget."llvmPackages_${toString llvmVersion}";

      # Common
      inherit (buildPackages.${python3Attr}.pkgs) sphinx; # a distutils issue with 3.12
      python3 = buildPackages.${python3Attr}; # so that we don't have two of them
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
    };

  # Find all GHC Nix expressions in the tree and automatically callGhc them.
  # Think ghcs by version like pkgs by name, though there is e.g. no sharding.
  parseGhcFilename = builtins.match "([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.nix";
  ghcsByVersion =
    let
      exprDir = ../development/compilers/ghc;
    in
    lib.pipe exprDir [
      builtins.readDir
      (builtins.mapAttrs (f: _: parseGhcFilename f))
      (lib.filterAttrs (_: parsed: parsed != null))
      (lib.mapAttrs' (
        filename: versionParts: {
          name = "ghc${lib.concatStrings versionParts}";
          value = makeGhc (exprDir + "/${filename}") (matchGhcRules versionParts);
        }
      ))
    ];

  # Rules governing external arguments passed to GHC expressions. These mostly
  # control what version of dependencies are picked in cases where GHC supports
  # multiple versions (so it takes a generically named input).
  # See matchGhcRules above on how rules are picked for a specific GHC version.
  #
  # Rule fields:
  #
  # - defaultVersion (only if rule's attribute is a release series):
  #   see generateDefaultVersions and toGhcReleaseSeriesVersion.
  # - bootPkgsAttr: attribute name of the package set (in haskell.packages) for
  #   bootstrapping hadrian and GHC.
  # - llvmVersion: Major version of LLVM to use for -fllvm, e.g. 15.
  # - python3Attr: attribute name of python (in pkgs) to use for bootstrapping
  #   the GHC configure script (if necessary) and sphinx.
  ghcRules = {
    "8.10" = {
      bootPkgsAttr =
        # the oldest ghc with aarch64-darwin support is 8.10.5
        if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          # to my (@a-m-joseph) knowledge there are no newer official binaries for this platform
          "ghc865Binary"
        else
          "ghc8107Binary";
      llvmVersion = 12;
      # TODO(@sternenseemann): can we use the default python now?
      python3Attr = "python311";
    };
    "9.0" = {
      bootPkgsAttr =
        # the oldest ghc with aarch64-darwin support is 8.10.5
        if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc810"
        else
          "ghc8107Binary";
      llvmVersion = 12;
      # TODO(@sternenseemann): can we use the default python now?
      python3Attr = "python311";
    };
    "9.2" = {
      bootPkgsAttr =
        if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc810"
        else
          "ghc8107Binary";
      llvmVersion = 12;
      # TODO(@sternenseemann): can we use the default python now?
      python3Attr = "python311";
    };
    "9.4" = {
      bootPkgsAttr =
        # Building with 9.2 is broken due to
        # https://gitlab.haskell.org/ghc/ghc/-/issues/21914
        # Use 8.10 as a workaround where possible to keep bootstrap path short.

        # On ARM text won't build with GHC 8.10.*
        if stdenv.buildPlatform.isAarch then
          # TODO(@sternenseemann): package bindist
          "ghc902"
        # No suitable bindists for powerpc64le
        else if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc902"
        else
          "ghc8107Binary";
      # Support range >= 10 && < 14
      llvmVersion = 12;
    };
    "9.6" = {
      bootPkgsAttr =
        # For GHC 9.2 no armv7l bindists are available.
        if stdenv.buildPlatform.isAarch32 then
          "ghc928"
        else if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc928"
        else
          "ghc924Binary";
      # Support range >= 11 && < 16
      llvmVersion = 15;
    };
    "9.8" = {
      bootPkgsAttr =
        # For GHC 9.6 no armv7l bindists are available.
        if stdenv.buildPlatform.isAarch32 then
          "ghc963"
        else if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc963"
        else
          "ghc963Binary";
      # Support range >= 11 && < 16
      llvmVersion = 15;
    };
    "9.10" = {
      bootPkgsAttr =
        # For GHC 9.6 no armv7l bindists are available.
        if stdenv.buildPlatform.isAarch32 then
          "ghc963"
        else if stdenv.buildPlatform.isPower64 && stdenv.buildPlatform.isLittleEndian then
          "ghc963"
        else if stdenv.buildPlatform.isDarwin then
          # it seems like the GHC 9.6.* bindists are built with a different
          # toolchain than we are using (which I'm guessing from the fact
          # that 9.6.4 bindists pass linker flags our ld doesn't support).
          # With both 9.6.3 and 9.6.4 binary it is impossible to link against
          # the clock package (probably a hsc2hs problem).
          "ghc963"
        else
          "ghc963Binary";
      # Support range >= 11 && < 16
      llvmVersion = 15;
    };
    "9.12" = {
      bootPkgsAttr =
        # No suitable bindist packaged yet
        "ghc9101";
      # 2024-12-21: Support range >= 13 && < 20
      llvmVersion = 19;
    };
    "9.14" = {
      bootPkgsAttr =
        # No suitable bindist packaged yet
        "ghc9101";
      # Support range >= 11 && < 16
      llvmVersion = 18;
    };
  };
in
{
  lib = import ../development/haskell-modules/lib {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  package-list = callPackage ../development/haskell-modules/package-list.nix { };

  compiler =
    let
      # See Note [GHC boot pkgsBuildBuild]
      bb = pkgsBuildBuild.haskell;
    in
    {
      # The integer-simple attribute set contains all the GHC compilers
      # build with integer-simple instead of integer-gmp.
      integer-simple =
        let
          integerSimpleGhcNames = pkgs.lib.filter (name: builtins.elem name integerSimpleIncludes) (
            pkgs.lib.attrNames compiler
          );
        in
        pkgs.recurseIntoAttrs (
          pkgs.lib.genAttrs integerSimpleGhcNames (
            name: compiler.${name}.override { enableIntegerSimple = true; }
          )
        );

      # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
      # with "native" and "gmp" backends.
      native-bignum =
        let
          nativeBignumGhcNames = pkgs.lib.filter nativeBignumIncludePred (pkgs.lib.attrNames compiler);
        in
        pkgs.recurseIntoAttrs (
          pkgs.lib.genAttrs nativeBignumGhcNames (
            name: compiler.${name}.override { enableNativeBignum = true; }
          )
        );

      ghc865Binary = callPackage ../development/compilers/ghc/8.6.5-binary.nix {
        # Should be llvmPackages_6 which has been removed from nixpkgs
        llvmPackages = null;
      };

      ghc8107Binary = callPackage ../development/compilers/ghc/8.10.7-binary.nix {
        llvmPackages = pkgs.llvmPackages_12;
      };

      ghc924Binary = callPackage ../development/compilers/ghc/9.2.4-binary.nix {
        llvmPackages = pkgs.llvmPackages_12;
      };

      ghc963Binary = callPackage ../development/compilers/ghc/9.6.3-binary.nix {
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghcjs = compiler.ghcjs810;
      ghcjs810 = callPackage ../development/compilers/ghcjs/8.10 {
        bootPkgs = bb.packages.ghc810;
        ghcjsSrcJson = ../development/compilers/ghcjs/8.10/git.json;
        stage0 = ../development/compilers/ghcjs/8.10/stage0.nix;
      };

      # TODO(sterni): default via ghcRules
      ghc810 = compiler.ghc8107;
      ghc90 = compiler.ghc902;
      ghc92 = compiler.ghc928;
      ghc94 = compiler.ghc948;
      ghc96 = compiler.ghc966;
      ghc98 = compiler.ghc984;
      ghc910 = compiler.ghc9101;
      ghc912 = compiler.ghc9121;
      ghcHEAD =
        let
          # TODO(@sternensemann): can we avoid tracking the version in two places?
          majorMinor = "9.13";
          ghc =
            makeGhc ../development/compilers/ghc/head.nix
              # GHC's master branch always has an odd version minor number.
              # Our rules/configurations use the even version number of the following release.
              ghcRules.${toGhcReleaseSeriesVersion majorMinor};
        in
        assert lib.hasPrefix majorMinor ghc.version;
        ghc;
    }
    // ghcsByVersion;

  # Default overrides that are applied to all package sets.
  packageOverrides = self: super: { };

  # Always get compilers from `buildPackages`
  # TODO(sterni): generate automatically
  packages =
    let
      bh = buildPackages.haskell;
    in
    {
      ghc865Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc865Binary;
        ghc = bh.compiler.ghc865Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc8107Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc8107Binary;
        ghc = bh.compiler.ghc8107Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc924Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc924Binary;
        ghc = bh.compiler.ghc924Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc963Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc963Binary;
        ghc = bh.compiler.ghc963Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc8107 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc8107;
        ghc = bh.compiler.ghc8107;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      };
      ghc810 = packages.ghc8107;
      ghc902 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc902;
        ghc = bh.compiler.ghc902;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
      };
      ghc90 = packages.ghc902;
      ghc925 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc925;
        ghc = bh.compiler.ghc925;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      };
      ghc926 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc926;
        ghc = bh.compiler.ghc926;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      };
      ghc927 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc927;
        ghc = bh.compiler.ghc927;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      };
      ghc928 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc928;
        ghc = bh.compiler.ghc928;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      };
      ghc92 = packages.ghc928;
      ghc947 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc947;
        ghc = bh.compiler.ghc947;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
      };
      ghc948 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc948;
        ghc = bh.compiler.ghc948;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
      };
      ghc94 = packages.ghc948;
      ghc963 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc963;
        ghc = bh.compiler.ghc963;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc964 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc964;
        ghc = bh.compiler.ghc964;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc965 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc965;
        ghc = bh.compiler.ghc965;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc966 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc966;
        ghc = bh.compiler.ghc966;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc96 = packages.ghc966;
      ghc981 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc981;
        ghc = bh.compiler.ghc981;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc982 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc982;
        ghc = bh.compiler.ghc982;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc983 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc983;
        ghc = bh.compiler.ghc983;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc984 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc984;
        ghc = bh.compiler.ghc984;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc98 = packages.ghc984;
      ghc9101 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9101;
        ghc = bh.compiler.ghc9101;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.10.x.nix { };
      };
      ghc910 = packages.ghc9101;
      ghc9121 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9121;
        ghc = bh.compiler.ghc9121;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.12.x.nix { };
      };
      ghc912 = packages.ghc9121;
      ghcHEAD = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghcHEAD;
        ghc = bh.compiler.ghcHEAD;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.14.x.nix { };
      };

      ghcjs = packages.ghcjs810;
      ghcjs810 = callPackage ../development/haskell-modules rec {
        buildHaskellPackages = ghc.bootPkgs;
        ghc = bh.compiler.ghcjs810;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
        packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs-8.x.nix { };
      };

      # The integer-simple attribute set contains package sets for all the GHC compilers
      # using integer-simple instead of integer-gmp.
      integer-simple =
        let
          integerSimpleGhcNames = pkgs.lib.filter (name: builtins.elem name integerSimpleIncludes) (
            pkgs.lib.attrNames packages
          );
        in
        pkgs.lib.genAttrs integerSimpleGhcNames (
          name:
          packages.${name}.override (oldAttrs: {
            ghc = bh.compiler.integer-simple.${name};
            buildHaskellPackages = bh.packages.integer-simple.${name};
            overrides = pkgs.lib.composeExtensions (oldAttrs.overrides or (_: _: { })) (
              _: _: { integer-simple = null; }
            );
          })
        );

      native-bignum =
        let
          nativeBignumGhcNames = pkgs.lib.filter nativeBignumIncludePred (
            pkgs.lib.attrNames compiler
          );
        in
        pkgs.lib.genAttrs nativeBignumGhcNames (
          name:
          packages.${name}.override {
            ghc = bh.compiler.native-bignum.${name};
            buildHaskellPackages = bh.packages.native-bignum.${name};
          }
        );
    };
}
