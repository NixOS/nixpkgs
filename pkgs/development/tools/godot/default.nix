# TODO:
# - combine binary and source tests
# - filter builtInputs by builtin_ flags
{
  callPackage,
  lib,
  nix-update-script,
  fetchzip,
}:
let
  mkGodotPackages =
    versionPrefix:
    let
      attrs = import (./. + "/${versionPrefix}/default.nix");
      updateScript = [
        ./update.sh
        versionPrefix
        (builtins.unsafeGetAttrPos "version" attrs).file
      ];
    in
    lib.recurseIntoAttrs rec {
      godot = callPackage ./common.nix {
        inherit updateScript;
        inherit (attrs)
          version
          hash
          ;
        inherit (attrs.default)
          exportTemplatesHash
          ;
      };

      godot-mono = godot.override {
        withMono = true;
        inherit (attrs.mono)
          exportTemplatesHash
          nugetDeps
          ;
      };

      export-template = godot.export-template;
      export-template-mono = godot-mono.export-template;

      export-templates-bin = godot.export-templates-bin;
      export-templates-mono-bin = godot-mono.export-templates-bin;
    };
in
rec {
  godot3 = callPackage ./3 { };
  godot3-export-templates = callPackage ./3/export-templates.nix { };
  godot3-headless = callPackage ./3/headless.nix { };
  godot3-debug-server = callPackage ./3/debug-server.nix { };
  godot3-server = callPackage ./3/server.nix { };
  godot3-mono = callPackage ./3/mono { };
  godot3-mono-export-templates = callPackage ./3/mono/export-templates.nix { };
  godot3-mono-headless = callPackage ./3/mono/headless.nix { };
  godot3-mono-debug-server = callPackage ./3/mono/debug-server.nix { };
  godot3-mono-server = callPackage ./3/mono/server.nix { };

  godotPackages_4_3 = mkGodotPackages "4.3";
  godotPackages_4_4 = mkGodotPackages "4.4";
  godotPackages_4_5 = mkGodotPackages "4.5";
  godotPackages_4 = godotPackages_4_5;
  godotPackages = godotPackages_4;

  godot_4_3 = godotPackages_4_3.godot;
  godot_4_3-mono = godotPackages_4_3.godot-mono;
  godot_4_3-export-templates-bin = godotPackages_4_3.export-templates-bin;
  godot_4_4 = godotPackages_4_4.godot;
  godot_4_4-mono = godotPackages_4_4.godot-mono;
  godot_4_4-export-templates-bin = godotPackages_4_4.export-templates-bin;
  godot_4_5 = godotPackages_4_5.godot;
  godot_4_5-mono = godotPackages_4_5.godot-mono;
  godot_4_5-export-templates-bin = godotPackages_4_5.export-templates-bin;
  godot_4 = godotPackages_4.godot;
  godot_4-mono = godotPackages_4.godot-mono;
  godot_4-export-templates-bin = godotPackages_4.export-templates-bin;
  godot = godotPackages.godot;
  godot-mono = godotPackages.godot-mono;
  godot-export-templates-bin = godotPackages.export-templates-bin;
}
