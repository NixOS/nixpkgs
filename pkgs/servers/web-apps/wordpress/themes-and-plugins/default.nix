# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified
{ lib, newScope, plugins, themes, languages, pluginLanguages, themeLanguages }:

let packages = self:
  let
    generatedJson = {
      inherit plugins themes languages pluginLanguages themeLanguages;
    };

  in {
    # Create a generic WordPress package. Most arguments are just passed
    # to `mkDerivation`. The version is automatically filtered for weird characters.
    mkWordpressDerivation = self.callPackage ({ stdenvNoCC, lib, filterWPString, gettext, wp-cli }:
      { type, pname, version, ... }@args:
        assert lib.any (x: x == type) [ "plugin" "theme" "language" "pluginLanguage" "themeLanguage" ];
        stdenvNoCC.mkDerivation ({
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
          } // (args.passthru or {});
        } // lib.optionalAttrs (type == "language" || type == "pluginLanguage" || type == "themeLanguage") {
          nativeBuildInputs = [ gettext wp-cli ];
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
        } // removeAttrs args [ "type" "pname" "version" "passthru" ])) {};

    # Create a derivation from the official wordpress.org packages.
    # This takes the type, the pname and the data generated from the go tool.
    mkOfficialWordpressDerivation = self.callPackage ({ mkWordpressDerivation, fetchWordpress }:
      { type, pname, data }:
      mkWordpressDerivation {
        inherit type pname;
        version = data.version;

        src = fetchWordpress type data;
      }) {};

    # Filter out all characters that might occur in a version string but that that are not allowed
    # in store paths.
    filterWPString = builtins.replaceStrings [ " " "," "/" "&" ";" ''"'' "'" "$" ":" "(" ")" "[" "]" "{" "}" "|" "*" "\t" ] [ "_" "." "." "" "" "" "" "" "" "" "" "" "" "" "" "-" "" "" ];

    # Fetch a package from the official wordpress.org SVN.
    # The data supplied is the data straight from the go tool.
    fetchWordpress = self.callPackage ({ fetchsvn }: type: data: fetchsvn {
      inherit (data) rev sha256;
      url = if type == "plugin" || type == "theme" then
        "https://" + type + "s.svn.wordpress.org/" + data.path
      else if type == "language" then
        "https://i18n.svn.wordpress.org/core/" + data.version + "/" + data.path
      else if type == "pluginLanguage" then
        "https://i18n.svn.wordpress.org/plugins/" + data.path
      else if type == "themeLanguage" then
        "https://i18n.svn.wordpress.org/themes/" + data.path
      else
        throw "fetchWordpress: invalid package type ${type}";
    }) {};

  } // lib.mapAttrs (type: pkgs: lib.makeExtensible (_: lib.mapAttrs (pname: data: self.mkOfficialWordpressDerivation { type = lib.removeSuffix "s" type; inherit pname data; }) pkgs)) generatedJson;

# This creates an extensible scope and immediately extends it with our custom
# package overrides.
in (lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (selfWP: superWP: {

  plugins = superWP.plugins.extend (selfPlugins: superPlugins: {
    # Fix the plugin caching store paths
    visualcomposer = superPlugins.visualcomposer.overrideAttrs (oA: {
      postInstall = ''
        ${oA.postInstall or ""}
        rm -r $out/cache
      '';
    });

    # Add nix syntax support
    prismatic = superWP.callPackage ({ fetchurl }: superPlugins.prismatic.overrideAttrs (oA: {
      postInstall = ''
        ${oA.postInstall or ""}

        cp ${fetchurl {
          url = "https://raw.githubusercontent.com/PrismJS/prism/v1.25.0/components/prism-nix.js";
          sha256 = "1ajw7pdnppgyar3v42nraxm0f4rzyqb5fw75ych8q3x94v4klgc7";
        }} $out/lib/prism/js/lang-nix.js

        # Allow loading the js
        substituteInPlace $out/inc/resources-enqueue.php \
          --replace "'lang-none'," "'lang-none', 'lang-nix'," \
          --replace "'language-none'," "'language-none', 'language-nix',"

        # Add the language into the editor
        sed -i "/Language\.\./a { label : 'Nix', value : 'nix' }," $out/js/blocks-prism.js
        sed -i "/Language\.\./a { label : 'Nix', value : 'nix' }," $out/js/buttons-prism.js
      '';
    })) {};
  });

  #themes = superWP.plugins.extend (selfThemes: superThemes: {
  #});
})
