let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in

{
  lib,
  bootstrapStdenv,
  fetchFromGitHub,
  meson,
  ninja,
  stdenv,
  stdenvNoCC,
  xcodeProjectCheckHook,
}:

let
  hasBasenamePrefix = prefix: file: lib.hasPrefix prefix (baseNameOf file);
in
lib.makeOverridable (
  attrs:
  let
    attrs' = if lib.isFunction attrs then attrs else _: attrs;
    attrsFixed = lib.fix attrs';
    stdenv' =
      if attrsFixed.noCC or false then
        stdenvNoCC
      else if attrsFixed.noBootstrap or false then
        stdenv
      else
        bootstrapStdenv;
  in
  stdenv'.mkDerivation (
    lib.extends (
      self: super:
      assert super ? releaseName;
      let
        inherit (super) releaseName;
        info = versions.${releaseName};
        files = lib.filesystem.listFilesRecursive (lib.path.append ./. releaseName);
        mesonFiles = lib.filter (hasBasenamePrefix "meson") files;
      in
      # You have to have at least `meson.build.in` when using xcodeHash to trigger the Meson
      # build support in `mkAppleDerivation`.
      assert super ? xcodeHash -> lib.length mesonFiles > 0;
      {
        pname = super.pname or releaseName;
        inherit (info) version;

        src = super.src or fetchFromGitHub {
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
          maintainers = lib.teams.darwin.members;
          platforms = lib.platforms.darwin;
        } // super.meta or { };
      }
      // lib.optionalAttrs (super ? xcodeHash) {
        postUnpack =
          super.postUnpack or ""
          + lib.concatMapStrings (
            file:
            if baseNameOf file == "meson.build.in" then
              "substitute ${lib.escapeShellArg "${file}"} \"$sourceRoot/meson.build\" --subst-var version\n"
            else
              "cp ${lib.escapeShellArg "${file}"} \"$sourceRoot/\"${lib.escapeShellArg (baseNameOf file)}\n"
          ) mesonFiles;

        xcodeProject = super.xcodeProject or "${releaseName}.xcodeproj";

        nativeBuildInputs = super.nativeBuildInputs or [ ] ++ [
          meson
          ninja
          xcodeProjectCheckHook
        ];

        mesonBuildType = "release";
      }
    ) attrs'
  )
)
