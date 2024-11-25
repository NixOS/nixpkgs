# These overrides are applied to the dependencies of the Nix components.

{
  src,
  version,

  # The raw Nixpkgs, not affected by this scope
  pkgs,
  stdenv,

  # Overrides, defined in ../
  libgit2-thin-packfile,
}:

let
  prevStdenv = stdenv;
in

let
  inherit (pkgs) lib;

  root = ./.;

  resolveRelPath = p: lib.path.removePrefix root p;

  resolvePath = p: src + "/${resolveRelPath p}";

  # fileset filtering is not possible without IFD on src, so we ignore the fileset
  # and produce a path containing _more_, but the extra files generally won't be
  # accessed.
  filesetToSource = { root, fileset }: resolvePath root;

  fetchedSourceLayer = finalAttrs: prevAttrs:
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



  stdenv = if prevStdenv.isDarwin && prevStdenv.isx86_64
    then darwinStdenv
    else prevStdenv;

  # Fix the following error with the default x86_64-darwin SDK:
  #
  #     error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
  #
  # Despite the use of the 10.13 deployment target here, the aligned
  # allocation function Clang uses with this setting actually works
  # all the way back to 10.6.
  darwinStdenv = pkgs.overrideSDK prevStdenv { darwinMinVersion = "10.13"; };

  /** Given a set of layers, create a mkDerivation-like function */
  mkPackageBuilder = exts: userFn:
    stdenv.mkDerivation (lib.extends (lib.composeManyExtensions exts) userFn);

  mesonLayer = finalAttrs: prevAttrs:
    {
      nativeBuildInputs = [
        pkgs.buildPackages.meson
        pkgs.buildPackages.ninja
      ] ++ prevAttrs.nativeBuildInputs or [];
      mesonCheckFlags = prevAttrs.mesonCheckFlags or [] ++ [
        "--print-errorlogs"
      ];
    };

  mesonBuildLayer = finalAttrs: prevAttrs:
    {
      nativeBuildInputs = prevAttrs.nativeBuildInputs or [] ++ [
        pkgs.buildPackages.pkg-config
      ];
      separateDebugInfo = !stdenv.hostPlatform.isStatic;
      hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";
    };

  mesonLibraryLayer = finalAttrs: prevAttrs:
    {
      outputs = prevAttrs.outputs or [ "out" ] ++ [ "dev" ];
    };

  # Work around weird `--as-needed` linker behavior with BSD, see
  # https://github.com/mesonbuild/meson/issues/3593
  bsdNoLinkAsNeeded = finalAttrs: prevAttrs:
    lib.optionalAttrs stdenv.hostPlatform.isBSD {
      mesonFlags = [ (lib.mesonBool "b_asneeded" false) ] ++ prevAttrs.mesonFlags or [];
    };

  miscGoodPractice = finalAttrs: prevAttrs:
    {
      strictDeps = prevAttrs.strictDeps or true;
      enableParallelBuilding = true;
    };
in
scope: {
  inherit stdenv;
  inherit version;

  aws-sdk-cpp = (pkgs.aws-sdk-cpp.override {
    apis = [ "s3" "transfer" ];
    customMemoryManagement = false;
  }).overrideAttrs {
    # only a stripped down version is built, which takes a lot less resources
    # to build, so we don't need a "big-parallel" machine.
    requiredSystemFeatures = [ ];
  };

  libseccomp = pkgs.libseccomp.overrideAttrs (_: rec {
    version = "2.5.5";
    src = pkgs.fetchurl {
      url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
      hash = "sha256-JIosik2bmFiqa69ScSw0r+/PnJ6Ut23OAsHJqiX7M3U=";
    };
  });

  boehmgc = pkgs.boehmgc.override {
    enableLargeConfig = true;
  };

  # TODO Hack until https://github.com/NixOS/nixpkgs/issues/45462 is fixed.
  boost = (pkgs.boost.override {
    extraB2Args = [
      "--with-container"
      "--with-context"
      "--with-coroutine"
    ];
  }).overrideAttrs (old: {
    # Need to remove `--with-*` to use `--with-libraries=...`
    buildPhase = lib.replaceStrings [ "--without-python" ] [ "" ] old.buildPhase;
    installPhase = lib.replaceStrings [ "--without-python" ] [ "" ] old.installPhase;
  });

  libgit2 = libgit2-thin-packfile;

  busybox-sandbox-shell = pkgs.busybox-sandbox-shell or (pkgs.busybox.override {
    useMusl = true;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_FEATURE_FANCY_ECHO y
      CONFIG_FEATURE_SH_MATH y
      CONFIG_FEATURE_SH_MATH_64 y

      CONFIG_ASH y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y

      CONFIG_ASH_ALIAS y
      CONFIG_ASH_BASH_COMPAT y
      CONFIG_ASH_CMDCMD y
      CONFIG_ASH_ECHO y
      CONFIG_ASH_GETOPTS y
      CONFIG_ASH_INTERNAL_GLOB y
      CONFIG_ASH_JOB_CONTROL y
      CONFIG_ASH_PRINTF y
      CONFIG_ASH_TEST y
    '';
  });

  inherit resolvePath filesetToSource;

  mkMesonDerivation =
    mkPackageBuilder [
      miscGoodPractice
      fetchedSourceLayer
      mesonLayer
    ];
  mkMesonExecutable =
    mkPackageBuilder [
      miscGoodPractice
      bsdNoLinkAsNeeded
      fetchedSourceLayer
      mesonLayer
      mesonBuildLayer
    ];
  mkMesonLibrary =
    mkPackageBuilder [
      miscGoodPractice
      bsdNoLinkAsNeeded
      fetchedSourceLayer
      mesonLayer
      mesonBuildLayer
      mesonLibraryLayer
    ];
}
