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

  # Takes a fix point as its input (pkgs.haskell.packages or pkgs.haskell.compiler)
  # and returns an attribute set of aliases that should be merged into them, e.g.
  # { ghc810 = …; ghc90 = …; … }. Which version to use is determined by ghcRules:
  # Every rule describing a release series (see above) should have a defaultVersion
  # attribute that describes which actual version (e.g. 8.10.7) to use.
  generateDefaultVersions =
    set:
    let
      isReleaseSeries = v: lib.match "[0-9]+\\.[0-9]+" v != null;
      versionToAttr = v: "ghc${lib.replaceStrings [ "." ] [ "" ] v}";
    in
    lib.mapAttrs'
      (
        series:
        { defaultVersion, ... }:
        {
          name = versionToAttr series;
          value = set.${versionToAttr defaultVersion};
        }
      )
      (
        lib.filterAttrs (
          version: rule:
          # ghcHEAD's rule is expressed as a release series, but obviosuly it
          # doesn't have a default version
          isReleaseSeries version && rule ? defaultVersion
        ) ghcRules
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
      # Note that we use pkgsBuildBuild.haskell.packages.*.
      # haskell.packages.*.ghc is similar to stdenv: The ghc comes from the
      # previous package set, i.e. this predicate holds: `name: pkgs:
      # pkgs.haskell.packages.${name}.ghc ==
      # pkgs.buildPackages.haskell.compiler.${name}.ghc`. This isn't problematic
      # since pkgsBuildBuild.buildPackages is also build->build, just something
      # to keep in mind.
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
      defaultVersion = "8.10.7";
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
      defaultVersion = "9.0.2";
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
      defaultVersion = "9.2.8";
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
      defaultVersion = "9.4.8";
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
      defaultVersion = "9.6.6";
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
      defaultVersion = "9.8.4";
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
      defaultVersion = "9.10.1";
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
      defaultVersion = "9.12.1";
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
    in
    {
      # The integer-simple attribute set contains all the GHC compilers
      # build with integer-simple instead of integer-gmp.
      integer-simple =
        let
          integerSimpleGhcNames = lib.filter (name: builtins.elem name integerSimpleIncludes) (
            lib.attrNames compiler
          );
        in
        pkgs.recurseIntoAttrs (
          lib.genAttrs integerSimpleGhcNames (name: compiler.${name}.override { enableIntegerSimple = true; })
        );

      # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
      # with "native" and "gmp" backends.
      native-bignum =
        let
          nativeBignumGhcNames = lib.filter nativeBignumIncludePred (lib.attrNames compiler);
        in
        pkgs.recurseIntoAttrs (
          lib.genAttrs nativeBignumGhcNames (name: compiler.${name}.override { enableNativeBignum = true; })
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
        # See Note [GHC boot pkgsBuildBuild]
        bootPkgs = pkgsBuildBuild.haskell.packages.ghc810;
        ghcjsSrcJson = ../development/compilers/ghcjs/8.10/git.json;
        stage0 = ../development/compilers/ghcjs/8.10/stage0.nix;
      };

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
    // generateDefaultVersions compiler
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
      # The integer-simple attribute set contains package sets for all the GHC compilers
      # using integer-simple instead of integer-gmp.
      integer-simple =
        let
          integerSimpleGhcNames = lib.filter (name: builtins.elem name integerSimpleIncludes) (
            lib.attrNames packages
          );
        in
        lib.genAttrs integerSimpleGhcNames (
          name:
          packages.${name}.override (oldAttrs: {
            ghc = bh.compiler.integer-simple.${name};
            buildHaskellPackages = bh.packages.integer-simple.${name};
            overrides = lib.composeExtensions (oldAttrs.overrides or (_: _: { })) (
              _: _: { integer-simple = null; }
            );
          })
        );

      native-bignum =
        let
          nativeBignumGhcNames = lib.filter nativeBignumIncludePred (lib.attrNames compiler);
        in
        lib.genAttrs nativeBignumGhcNames (
          name:
          packages.${name}.override {
            ghc = bh.compiler.native-bignum.${name};
            buildHaskellPackages = bh.packages.native-bignum.${name};
          }
        );

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

      ghcjs = packages.ghcjs810;
      ghcjs810 = callPackage ../development/haskell-modules rec {
        buildHaskellPackages = ghc.bootPkgs;
        ghc = bh.compiler.ghcjs810;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
        packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs-8.x.nix { };
      };
    }
    // generateDefaultVersions packages
    // lib.mapAttrs (
      name: compiler:
      callPackage ../development/haskell-modules {
        # Even though we are passed the compiler by value, use the pkgs fix point to aid overlaying
        # TODO(@sternenseemann): also use the fix point for the list of compilers,
        # so overlays can add compilers and have their package sets created automatically (low prio).
        ghc = bh.compiler.${name};
        buildHaskellPackages = bh.packages.${name};
        compilerConfig = callPackage (
          ../development/haskell-modules
          + "/configuration-ghc-${lib.versions.majorMinor (toGhcReleaseSeriesVersion compiler.version)}.x.nix"
        ) { };
      }
    ) (ghcsByVersion // { inherit (bh.compiler) ghcHEAD; });
}
