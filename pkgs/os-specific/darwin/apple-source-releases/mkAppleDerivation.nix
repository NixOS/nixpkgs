let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in

{
  lib,
  bootstrapStdenv,
  fetchFromGitHub,
  meson,
  ninja,
  xcodeProjectCheckHook,
}:

let
  hasBasenamePrefix = prefix: file: lib.hasPrefix prefix (baseNameOf file);
in
lib.extendMkDerivation {
  constructDrv = bootstrapStdenv.mkDerivation;
  extendDrvArgs =
    finalAttrs: args:
    assert args ? releaseName;
    let
      inherit (args) releaseName;
      info = versions.${releaseName};
      files = lib.filesystem.listFilesRecursive (lib.path.append ./. releaseName);
      mesonFiles = lib.filter (hasBasenamePrefix "meson") files;
    in
    # You have to have at least `meson.build.in` when using xcodeHash to trigger the Meson
    # build support in `mkAppleDerivation`.
    assert args ? xcodeHash -> lib.length mesonFiles > 0;
    {
      pname = args.pname or releaseName;
      inherit (info) version;

      src = args.src or fetchFromGitHub {
        owner = "apple-oss-distributions";
        repo = releaseName;
        rev = info.rev or "${releaseName}-${info.version}";
        inherit (info) hash;
      };

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
    // lib.optionalAttrs (args ? xcodeHash) {
      postUnpack =
        args.postUnpack or ""
        + lib.concatMapStrings (
          file:
          if baseNameOf file == "meson.build.in" then
            "substitute ${lib.escapeShellArg "${file}"} \"$sourceRoot/meson.build\" --subst-var version\n"
          else
            "cp ${lib.escapeShellArg "${file}"} \"$sourceRoot/\"${lib.escapeShellArg (baseNameOf file)}\n"
        ) mesonFiles;

      xcodeProject = args.xcodeProject or "${releaseName}.xcodeproj";

      nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
        meson
        ninja
        xcodeProjectCheckHook
      ];

      mesonBuildType = "release";
    };
}
