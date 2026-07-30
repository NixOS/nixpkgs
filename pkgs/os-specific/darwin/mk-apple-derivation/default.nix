{
  lib,
  bootstrapStdenv,
  meson,
  ninja,
  runCommand,
  sourceRelease,
  xcodeProjectCheckHook,
}:

let
  prependShardPath =
    path:
    let
      shard = lib.toLower (lib.substring 0 2 path);
    in
    lib.foldl' lib.path.append ../by-name [
      shard
      path
    ];

  hasBasenamePrefix = prefix: file: lib.hasPrefix prefix (baseNameOf file);
in
lib.extendMkDerivation {
  constructDrv = bootstrapStdenv.mkDerivation;
  extendDrvArgs =
    finalAttrs: args:
    assert args ? releaseName;
    let
      inherit (args) releaseName;
      releaseSrc = sourceRelease releaseName;
      files = lib.filesystem.listFilesRecursive (prependShardPath releaseName);
      mesonFiles = lib.filter (hasBasenamePrefix "meson") files;
    in
    # You have to have at least `meson.build.in` when using xcodeHash to trigger the Meson
    # build support in `mkAppleDerivation`.
    assert args ? xcodeHash -> lib.length mesonFiles > 0;
    {
      pname = args.pname or releaseName;
      inherit (releaseSrc) version;

      src = args.src or releaseSrc;

      strictDeps = true;
      __structuredAttrs = true;

      meta = {
        homepage = "https://opensource.apple.com/releases/";
        license = lib.licenses.apple-psl20;
        teams = [ lib.teams.darwin ];
        platforms = lib.platforms.darwin;
      }
      // args.meta or { };
    }
    // lib.optionalAttrs (args ? xcodeHash) (
      let
        xcodeProject = args.xcodeProject or "${releaseName}.xcodeproj";
      in
      {
        postUnpack =
          args.postUnpack or ""
          + lib.concatMapStrings (
            file:
            if baseNameOf file == "meson.build.in" then
              "substitute ${lib.escapeShellArg "${file}"} \"$sourceRoot/meson.build\" --subst-var version\n"
            else
              "cp ${lib.escapeShellArg "${file}"} \"$sourceRoot/\"${lib.escapeShellArg (baseNameOf file)}\n"
          ) mesonFiles;

        inherit xcodeProject;

        nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
          meson
          ninja
          xcodeProjectCheckHook
        ];

        mesonBuildType = "release";

        # build-platform check so CI catches stale xcodeHashes the Darwin-only postUnpack hook misses
        passthru = lib.recursiveUpdate (args.passthru or { }) {
          tests.xcodeProjectHash =
            runCommand "${finalAttrs.pname}-xcodeproject-hash-check"
              {
                sourceRoot = "${finalAttrs.src}";
                inherit xcodeProject;
                inherit (args) xcodeHash;
                nativeBuildInputs = [ xcodeProjectCheckHook ];
              }
              ''
                verifyXcodeProjectHash
                touch "$out"
              '';
        };
      }
    );
}
