{
  lib,
  pkgs,
  src,
  officialRelease,
  maintainers,
  teams,
  version,
}:

scope:

let
  inherit (scope)
    callPackage
    ;
  inherit
    (scope.callPackage (
      { stdenv }:
      {
        inherit stdenv;
      }
    ) { })
    stdenv
    ;
  inherit (pkgs.buildPackages)
    meson
    ninja
    pkg-config
    ;

  root = ../.;

  # Indirection for Nixpkgs to override when package.nix files are vendored
  filesetToSource = lib.fileset.toSource;

  /**
    Given a set of layers, create a mkDerivation-like function
  */
  mkPackageBuilder =
    exts: userFn: stdenv.mkDerivation (lib.extends (lib.composeManyExtensions exts) userFn);

  setVersionLayer = finalAttrs: prevAttrs: {
    preConfigure =
      prevAttrs.preConfigure or ""
      +
      # Update the repo-global .version file.
      # Symlink ./.version points there, but by default only workDir is writable.
      ''
        chmod u+w ./.version
        echo ${finalAttrs.version} > ./.version
      '';
  };

  localSourceLayer =
    finalAttrs: prevAttrs:
    let
      workDirPath =
        # Ideally we'd pick finalAttrs.workDir, but for now `mkDerivation` has
        # the requirement that everything except passthru and meta must be
        # serialized by mkDerivation, which doesn't work for this.
        prevAttrs.workDir;

      workDirSubpath = lib.path.removePrefix root workDirPath;
      sources =
        assert prevAttrs.fileset._type == "fileset";
        prevAttrs.fileset;
      src = lib.fileset.toSource {
        fileset = sources;
        inherit root;
      };

    in
    {
      sourceRoot = "${src.name}/" + workDirSubpath;
      inherit src;

      # Clear what `derivation` can't/shouldn't serialize; see prevAttrs.workDir.
      fileset = null;
      workDir = null;
    };

  resolveRelPath = p: lib.path.removePrefix root p;

  makeFetchedSourceLayer =
    finalScope: finalAttrs: prevAttrs:
    let
      workDirPath =
        # Ideally we'd pick finalAttrs.workDir, but for now `mkDerivation` has
        # the requirement that everything except passthru and meta must be
        # serialized by mkDerivation, which doesn't work for this.
        prevAttrs.workDir;

      workDirSubpath = resolveRelPath workDirPath;

    in
    {
      sourceRoot = "${finalScope.patchedSrc.name}/" + workDirSubpath;
      src = finalScope.patchedSrc;
      version =
        let
          n = lib.length finalScope.patches;
        in
        if n == 0 then prevAttrs.version else prevAttrs.version + "+${toString n}";

      # Clear what `derivation` can't/shouldn't serialize; see prevAttrs.workDir.
      fileset = null;
      workDir = null;
    };

  mesonLayer = finalAttrs: prevAttrs: {
    # NOTE:
    # As of https://github.com/NixOS/nixpkgs/blob/8baf8241cea0c7b30e0b8ae73474cb3de83c1a30/pkgs/by-name/me/meson/setup-hook.sh#L26,
    # `mesonBuildType` defaults to `plain` if not specified. We want our Nix-built binaries to be optimized by default.
    # More on build types here: https://mesonbuild.com/Builtin-options.html#details-for-buildtype.
    mesonBuildType = "release";
    # NOTE:
    # Users who are debugging Nix builds are expected to set the environment variable `mesonBuildType`, per the
    # guidance in https://github.com/NixOS/nix/blob/8a3fc27f1b63a08ac983ee46435a56cf49ebaf4a/doc/manual/source/development/debugging.md?plain=1#L10.
    # For this reason, we don't want to refer to `finalAttrs.mesonBuildType` here, but rather use the environment variable.
    preConfigure =
      prevAttrs.preConfigure or ""
      +
        lib.optionalString
          (
            !stdenv.hostPlatform.isWindows
            # build failure
            && !stdenv.hostPlatform.isStatic
            # LTO breaks exception handling on x86-64-darwin.
            && stdenv.system != "x86_64-darwin"
          )
          ''
            case "$mesonBuildType" in
            release|minsize) appendToVar mesonFlags "-Db_lto=true"  ;;
            *)               appendToVar mesonFlags "-Db_lto=false" ;;
            esac
          '';
    nativeBuildInputs = [
      meson
      ninja
    ]
    ++ prevAttrs.nativeBuildInputs or [ ];
    mesonCheckFlags = prevAttrs.mesonCheckFlags or [ ] ++ [
      "--print-errorlogs"
    ];
  };

  mesonBuildLayer = finalAttrs: prevAttrs: {
    nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [
      pkg-config
    ];
    separateDebugInfo = !stdenv.hostPlatform.isStatic;
    hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";
  };

  mesonLibraryLayer = finalAttrs: prevAttrs: {
    # See https://github.com/NixOS/nix/pull/14105 -- enabling this only for Nix 2.32+ as there are
    # reports of undefined behavior on previous versions. Note that this does //not// use
    # `finalAttrs.version` in order to avoid infinite recursion.
    ${if lib.versionOlder version "2.32" then null else "preConfigure"} =
      let
        interpositionFlags = [
          "-fno-semantic-interposition"
          "-Wl,-Bsymbolic-functions"
        ];
      in
      # NOTE: By default GCC disables interprocedular optimizations (in particular inlining) for
      # position-independent code and thus shared libraries.
      # Since LD_PRELOAD tricks aren't worth losing out on optimizations, we disable it for good.
      # This is not the case for Clang, where inlining is done by default even without -fno-semantic-interposition.
      # https://reviews.llvm.org/D102453
      # https://fedoraproject.org/wiki/Changes/PythonNoSemanticInterpositionSpeedup
      prevAttrs.preConfigure or ""
      + lib.optionalString stdenv.cc.isGNU ''
        export CFLAGS="''${CFLAGS:-} ${toString interpositionFlags}"
        export CXXFLAGS="''${CXXFLAGS:-} ${toString interpositionFlags}"
      '';
    outputs = prevAttrs.outputs or [ "out" ] ++ [ "dev" ];
  };

  # Work around weird `--as-needed` linker behavior with BSD, see
  # https://github.com/mesonbuild/meson/issues/3593
  bsdNoLinkAsNeeded =
    finalAttrs: prevAttrs:
    lib.optionalAttrs stdenv.hostPlatform.isBSD {
      mesonFlags = [ (lib.mesonBool "b_asneeded" false) ] ++ prevAttrs.mesonFlags or [ ];
    };

  nixDefaultsLayer = finalAttrs: prevAttrs: {
    strictDeps = prevAttrs.strictDeps or true;
    enableParallelBuilding = true;
    pos = builtins.unsafeGetAttrPos "pname" prevAttrs;
    meta = prevAttrs.meta or { } // {
      homepage = prevAttrs.meta.homepage or "https://nixos.org/nix";
      longDescription =
        prevAttrs.longDescription or ''
          Nix is a powerful package manager for mainly Linux and other Unix systems that
          makes package management reliable and reproducible. It provides atomic
          upgrades and rollbacks, side-by-side installation of multiple versions of
          a package, multi-user package management and easy setup of build
          environments.
        '';
      license = prevAttrs.meta.license or lib.licenses.lgpl21Plus;
      maintainers = prevAttrs.meta.maintainers or [ ] ++ scope.maintainers;
      teams = prevAttrs.meta.teams or [ ] ++ scope.teams;
      platforms = prevAttrs.meta.platforms or (lib.platforms.unix ++ lib.platforms.windows);
    };
  };

  /**
    Append patches to the source layer.
  */
  appendPatches =
    scope: patches:
    scope.overrideScope (
      finalScope: prevScope: {
        patches = prevScope.patches ++ patches;
      }
    );

  whenAtLeast = v: thing: if lib.versionAtLeast version v then thing else null;

in

# This becomes the pkgs.nixComponents attribute set
{
  inherit version;
  inherit maintainers;
  inherit teams;

  inherit filesetToSource;

  /**
    A user-provided extension function to apply to each component derivation.
  */
  mesonComponentOverrides = finalAttrs: prevAttrs: { };

  /**
    An overridable derivation layer for handling the sources.
  */
  sourceLayer = localSourceLayer;

  /**
    Resolve a path value to either itself or a path in the `src`, depending
    whether `overrideSource` was called.
  */
  resolvePath = p: p;

  /**
    Apply an extension function (i.e. overlay-shaped) to all component derivations.

    Single argument: the extension function to apply (finalAttrs: prevAttrs: { ... })
  */
  overrideAllMesonComponents =
    f:
    scope.overrideScope (
      finalScope: prevScope: {
        mesonComponentOverrides = lib.composeExtensions scope.mesonComponentOverrides f;
      }
    );

  /**
    Provide an alternate source. This allows the expressions to be vendored without copying the sources,
    but it does make the build non-granular; all components will use a complete source.

    Filesets in the packaging expressions will be ignored.

    Single argument: the source to use.

    See also `appendPatches`
  */
  overrideSource =
    src:
    scope.overrideScope (
      finalScope: prevScope: {
        sourceLayer = makeFetchedSourceLayer finalScope;
        /**
          Unpatched source for the build of Nix. Packaging expressions will be ignored.
        */
        src = src;
        /**
          Patches for the whole Nix source. Changes to packaging expressions will be ignored.
        */
        patches = [ ];
        /**
          Fetched and patched source to be used in component derivations.
        */
        patchedSrc =
          if finalScope.patches == [ ] then
            src
          else
            pkgs.buildPackages.srcOnly (
              pkgs.buildPackages.stdenvNoCC.mkDerivation {
                name = "${finalScope.src.name or "nix-source"}-patched";
                inherit (finalScope) src patches;
              }
            );

        resolvePath = p: finalScope.patchedSrc + "/${resolveRelPath p}";
        filesetToSource = { root, fileset }: finalScope.resolvePath root;

        appendPatches = appendPatches finalScope;
      }
    );

  /**
    Append patches to be applied to the whole Nix source.
    This affects all components.

    Changes to the packaging expressions will be ignored.

    Single argument: list of patches to apply

    See also `overrideSource`
  */
  appendPatches =
    patches:
    # switch to "fetched" source first, so that patches apply to the whole tree.
    (scope.overrideSource "${./..}").appendPatches patches;

  mkMesonDerivation = mkPackageBuilder [
    nixDefaultsLayer
    scope.sourceLayer
    setVersionLayer
    mesonLayer
    scope.mesonComponentOverrides
  ];
  mkMesonExecutable = mkPackageBuilder [
    nixDefaultsLayer
    bsdNoLinkAsNeeded
    scope.sourceLayer
    setVersionLayer
    mesonLayer
    mesonBuildLayer
    scope.mesonComponentOverrides
  ];
  mkMesonLibrary = mkPackageBuilder [
    nixDefaultsLayer
    bsdNoLinkAsNeeded
    scope.sourceLayer
    mesonLayer
    setVersionLayer
    mesonBuildLayer
    mesonLibraryLayer
    scope.mesonComponentOverrides
  ];

  nix-util = callPackage ../src/libutil/package.nix { };
  nix-util-c = callPackage ../src/libutil-c/package.nix { };
  nix-util-test-support = callPackage ../src/libutil-test-support/package.nix { };
  nix-util-tests = callPackage ../src/libutil-tests/package.nix { };

  nix-store = callPackage ../src/libstore/package.nix { };
  nix-store-c = callPackage ../src/libstore-c/package.nix { };
  nix-store-test-support = callPackage ../src/libstore-test-support/package.nix { };
  nix-store-tests = callPackage ../src/libstore-tests/package.nix { };

  nix-fetchers = callPackage ../src/libfetchers/package.nix { };
  ${whenAtLeast "2.29pre" "nix-fetchers-c"} = callPackage ../src/libfetchers-c/package.nix { };
  nix-fetchers-tests = callPackage ../src/libfetchers-tests/package.nix { };

  nix-expr = callPackage ../src/libexpr/package.nix { };
  nix-expr-c = callPackage ../src/libexpr-c/package.nix { };
  nix-expr-test-support = callPackage ../src/libexpr-test-support/package.nix { };
  nix-expr-tests = callPackage ../src/libexpr-tests/package.nix { };

  nix-flake = callPackage ../src/libflake/package.nix { };
  nix-flake-c = callPackage ../src/libflake-c/package.nix { };
  nix-flake-tests = callPackage ../src/libflake-tests/package.nix { };

  nix-main = callPackage ../src/libmain/package.nix { };
  nix-main-c = callPackage ../src/libmain-c/package.nix { };

  nix-cmd = callPackage ../src/libcmd/package.nix { };

  nix-cli = callPackage ../src/nix/package.nix { };

  nix-functional-tests = callPackage ../tests/functional/package.nix { };

  nix-manual = callPackage ../doc/manual/package.nix { };
  nix-internal-api-docs = callPackage ../src/internal-api-docs/package.nix { };
  nix-external-api-docs = callPackage ../src/external-api-docs/package.nix { };

  nix-perl-bindings = callPackage ../src/perl/package.nix { };

  nix-everything = callPackage ../packaging/everything.nix { } // {
    # Note: no `passthru.overrideAllMesonComponents` etc
    #       This would propagate into `nix.overrideAttrs f`, but then discard
    #       `f` when `.overrideAllMesonComponents` is used.
    #       Both "methods" should be views on the same fixpoint overriding mechanism
    #       for that to work. For now, we intentionally don't support the broken
    #       two-fixpoint solution.
    /**
      Apply an extension function (i.e. overlay-shaped) to all component derivations, and return the nix package.

      Single argument: the extension function to apply (finalAttrs: prevAttrs: { ... })
    */
    overrideAllMesonComponents = f: (scope.overrideAllMesonComponents f).nix-everything;

    /**
      Append patches to be applied to the whole Nix source.
      This affects all components.

      Changes to the packaging expressions will be ignored.

      Single argument: list of patches to apply

      See also `overrideSource`
    */
    appendPatches = ps: (scope.appendPatches ps).nix-everything;

    /**
      Provide an alternate source. This allows the expressions to be vendored without copying the sources,
      but it does make the build non-granular; all components will use a complete source.

      Filesets in the packaging expressions will be ignored.

      Single argument: the source to use.

      See also `appendPatches`
    */
    overrideSource = src: (scope.overrideSource src).nix-everything;

    /**
      Override any internals of the Nix package set.

      Single argument: the extension function to apply to the package set (finalScope: prevScope: { ... })

      Example:
      ```
      overrideScope (finalScope: prevScope: { aws-sdk-cpp = null; })
      ```
    */
    overrideScope = f: (scope.overrideScope f).nix-everything;

  };
}
