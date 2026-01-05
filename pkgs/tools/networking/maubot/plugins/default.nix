{
  lib,
  fetchgit,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchFromGitea,
  stdenvNoCC,
  callPackage,
  ensureNewerSourcesForZipFilesHook,
  maubot,
  python3,
  poetry,
  formats,
}:

let
  # pname: plugin id (example: xyz.maubot.echo)
  # version: plugin version
  # other attributes are passed directly to stdenv.mkDerivation (you at least need src)
  buildMaubotPlugin =
    attrs@{
      version,
      pname,
      base_config ? null,
      ...
    }:
    stdenvNoCC.mkDerivation (
      removeAttrs attrs [ "base_config" ]
      // {
        pluginName = "${pname}-v${version}.mbp";
        nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [
          ensureNewerSourcesForZipFilesHook
          maubot
        ];
        buildPhase = ''
          runHook preBuild

          mbc build

          runHook postBuild
        '';

        postPatch =
          lib.optionalString (base_config != null) ''
            [ -e base-config.yaml ] || (echo "base-config.yaml doesn't exist, can't override it" && exit 1)
            cp "${
              if builtins.isPath base_config || lib.isDerivation base_config then
                base_config
              else if builtins.isString base_config then
                builtins.toFile "base-config.yaml" base_config
              else
                (formats.yaml { }).generate "base-config.yaml" base_config
            }" base-config.yaml
          ''
          + attrs.postPatch or "";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib/maubot-plugins
          install -m 444 $pluginName $out/lib/maubot-plugins

          runHook postInstall
        '';
      }
    );

  generated = import ./generated.nix {
    inherit
      lib
      fetchgit
      fetchFromGitHub
      fetchFromGitLab
      fetchFromGitea
      python3
      poetry
      buildMaubotPlugin
      ;
  };
in
generated
// {
  inherit buildMaubotPlugin;

  allOfficialPlugins = builtins.filter (x: x.isOfficial && !x.meta.broken) (
    builtins.attrValues generated
  );

  allPlugins = builtins.filter (x: !x.meta.broken) (builtins.attrValues generated);
}
