# These overrides are applied to the dependencies of the Nix components.

{
  src,

  # The raw Nixpkgs, not affected by this scope
  pkgs,

  stdenv,
}:

let
  prevStdenv = stdenv;
in

let
  inherit (pkgs) lib;

  root = ./.;

  stdenv = if prevStdenv.isDarwin && prevStdenv.isx86_64 then darwinStdenv else prevStdenv;

  # Fix the following error with the default x86_64-darwin SDK:
  #
  #     error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
  #
  # Despite the use of the 10.13 deployment target here, the aligned
  # allocation function Clang uses with this setting actually works
  # all the way back to 10.6.
  darwinStdenv = pkgs.overrideSDK prevStdenv { darwinMinVersion = "10.13"; };

  resolveRelPath = p: lib.path.removePrefix root p;
  resolvePath = p: src + "/${resolveRelPath p}";

  # Indirection for Nixpkgs to override when package.nix files are vendored
  # fileset filtering is not possible without IFD on src, so we ignore the fileset
  # and produce a path containing _more_, but the extra files generally won't be
  # accessed.
  # The Nix flake uses fileset.toSource for this.
  filesetToSource = { root, fileset }: resolvePath root;

  /**
    Given a set of layers, create a mkDerivation-like function
  */
  mkPackageBuilder =
    exts: userFn: stdenv.mkDerivation (lib.extends (lib.composeManyExtensions exts) userFn);

  localSourceLayer =
    finalAttrs: prevAttrs:
    let
      workDirPath =
        # Ideally we'd pick finalAttrs.workDir, but for now `mkDerivation` has
        # the requirement that everything except passthru and meta must be
        # serialized by mkDerivation, which doesn't work for this.
        prevAttrs.workDir;

      workDirSubpath = resolveRelPath workDirPath;
      # sources = assert prevAttrs.fileset._type == "fileset"; prevAttrs.fileset;
      # src = lib.fileset.toSource { fileset = sources; inherit root; };

    in
    {
      sourceRoot = "${src.name}/" + workDirSubpath;
      inherit src;

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
      pkgs.buildPackages.meson
      pkgs.buildPackages.ninja
    ] ++ prevAttrs.nativeBuildInputs or [ ];
    mesonCheckFlags = prevAttrs.mesonCheckFlags or [ ] ++ [
      "--print-errorlogs"
    ];
  };

  mesonBuildLayer = finalAttrs: prevAttrs: {
    nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [
      pkgs.buildPackages.pkg-config
    ];
    separateDebugInfo = !stdenv.hostPlatform.isStatic;
    hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";
    env =
      prevAttrs.env or { }
      // lib.optionalAttrs (
        stdenv.isLinux
        && !(stdenv.hostPlatform.isStatic && stdenv.system == "aarch64-linux")
        && !(stdenv.hostPlatform.useLLVM or false)
      ) { LDFLAGS = "-fuse-ld=gold"; };
  };

  mesonLibraryLayer = finalAttrs: prevAttrs: {
    outputs = prevAttrs.outputs or [ "out" ] ++ [ "dev" ];
  };

  # Work around weird `--as-needed` linker behavior with BSD, see
  # https://github.com/mesonbuild/meson/issues/3593
  bsdNoLinkAsNeeded =
    finalAttrs: prevAttrs:
    lib.optionalAttrs stdenv.hostPlatform.isBSD {
      mesonFlags = [ (lib.mesonBool "b_asneeded" false) ] ++ prevAttrs.mesonFlags or [ ];
    };

  miscGoodPractice = finalAttrs: prevAttrs: {
    strictDeps = prevAttrs.strictDeps or true;
    enableParallelBuilding = true;
  };
in
scope: {
  inherit stdenv;

  aws-sdk-cpp =
    (pkgs.aws-sdk-cpp.override {
      apis = [
        "s3"
        "transfer"
      ];
      customMemoryManagement = false;
    }).overrideAttrs
      {
        # only a stripped down version is built, which takes a lot less resources
        # to build, so we don't need a "big-parallel" machine.
        requiredSystemFeatures = [ ];
      };

  boehmgc = pkgs.boehmgc.override {
    enableLargeConfig = true;
  };

  inherit resolvePath filesetToSource;

  mkMesonDerivation = mkPackageBuilder [
    miscGoodPractice
    localSourceLayer
    mesonLayer
  ];
  mkMesonExecutable = mkPackageBuilder [
    miscGoodPractice
    bsdNoLinkAsNeeded
    localSourceLayer
    mesonLayer
    mesonBuildLayer
  ];
  mkMesonLibrary = mkPackageBuilder [
    miscGoodPractice
    bsdNoLinkAsNeeded
    localSourceLayer
    mesonLayer
    mesonBuildLayer
    mesonLibraryLayer
  ];
}
