# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified

{
  lib,
  newScope,
  plugins,
  themes,
  languages,
  callPackage,
}:

let
  packages =
    self:
    let
      generatedJson = {
        inherit plugins themes languages;
      };
      sourceJson = {
        plugins = builtins.fromJSON (builtins.readFile ./wordpress-plugins.json);
        themes = builtins.fromJSON (builtins.readFile ./wordpress-themes.json);
        languages = builtins.fromJSON (builtins.readFile ./wordpress-languages.json);
      };

    in
    {
      # Create a generic WordPress package. Most arguments are just passed
      # to `mkDerivation`. The version is automatically filtered for weird characters.
      mkWordpressDerivation = self.callPackage (
        {
          stdenvNoCC,
          lib,
          filterWPString,
          gettext,
          wp-cli,
        }:
        {
          type,
          pname,
          version,
          license,
          ...
        }@args:
        assert lib.any (x: x == type) [
          "plugin"
          "theme"
          "language"
        ];
        stdenvNoCC.mkDerivation (
          {
            pname = "wordpress-${type}-${pname}";
            version = filterWPString version;

            dontConfigure = true;
            dontBuild = true;

            installPhase = ''
              runHook preInstall
              cp -R ./. $out
              runHook postInstall
            '';

            passthru = {
              wpName = pname;
            };

            meta = {
              license = lib.licenses.${license};
            }
            // (args.passthru or { });
          }
          // lib.optionalAttrs (type == "language") {
            nativeBuildInputs = [
              gettext
              wp-cli
            ];
            dontBuild = false;
            buildPhase = ''
              runHook preBuild

              find -name '*.po' -print0 | while IFS= read -d "" -r po; do
                msgfmt -o $(basename "$po" .po).mo "$po"
              done
              wp i18n make-json .
              rm *.po

              runHook postBuild
            '';
          }
          // removeAttrs args [
            "type"
            "pname"
            "version"
            "passthru"
          ]
        )
      ) { };

      # Create a derivation from the official wordpress.org packages.
      # This takes the type, the pname and the data generated from the go tool.
      mkOfficialWordpressDerivation = self.callPackage (
        { mkWordpressDerivation, fetchWordpress }:
        {
          type,
          pname,
          data,
          license,
        }:
        mkWordpressDerivation {
          inherit type pname license;
          version = data.version;

          src = fetchWordpress type data;
        }
      ) { };

      # Filter out all characters that might occur in a version string but that that are not allowed
      # in store paths.
      filterWPString =
        builtins.replaceStrings
          [
            " "
            ","
            "/"
            "&"
            ";"
            ''"''
            "'"
            "$"
            ":"
            "("
            ")"
            "["
            "]"
            "{"
            "}"
            "|"
            "*"
            "\t"
          ]
          [
            "_"
            "."
            "."
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            "-"
            ""
            ""
          ];

      # Fetch a package from the official wordpress.org SVN.
      # The data supplied is the data straight from the go tool.
      fetchWordpress = self.callPackage (
        { fetchsvn }:
        type: data:
        fetchsvn {
          inherit (data) rev sha256;
          url =
            if type == "plugin" || type == "theme" then
              "https://" + type + "s.svn.wordpress.org/" + data.path
            else if type == "language" then
              "https://i18n.svn.wordpress.org/core/" + data.version + "/" + data.path
            else if type == "pluginLanguage" then
              "https://i18n.svn.wordpress.org/plugins/" + data.path
            else if type == "themeLanguage" then
              "https://i18n.svn.wordpress.org/themes/" + data.path
            else
              throw "fetchWordpress: invalid package type ${type}";
        }
      ) { };

    }
    // lib.mapAttrs (
      type: pkgs:
      lib.recurseIntoAttrs (
        lib.makeExtensible (
          _:
          lib.mapAttrs (
            pname: data:
            self.mkOfficialWordpressDerivation {
              type = lib.removeSuffix "s" type;
              inherit pname data;
              license = sourceJson.${type}.${pname};
            }
          ) pkgs
        )
      )
    ) generatedJson;

in
# This creates an extensible scope.
lib.recursiveUpdate ((lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (
  selfWP: superWP: { }
)) (callPackage ./thirdparty.nix { })
