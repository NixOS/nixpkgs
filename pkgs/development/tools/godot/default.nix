{
  callPackage,
  nix-update-script,
  fetchzip,
}:
let
  mkGodotPackages =
    versionPrefix:
    let
      attrs = import (./. + "/${versionPrefix}/default.nix");
      inherit (attrs)
        version
        hash
        exportTemplatesHash
        nugetDeps
        ;
    in
    rec {
      godot = (callPackage ./common.nix { inherit version hash nugetDeps; }).overrideAttrs (old: {
        passthru = old.passthru or { } // {
          inherit export-templates-bin;
          updateScript = [
            ./update.sh
            versionPrefix
            (builtins.unsafeGetAttrPos "version" attrs).file
          ];
        };
      });

      godot-mono = godot.override {
        withMono = true;
      };

      export-templates-bin = (
        callPackage ./export-templates-bin.nix {
          inherit version godot;
          hash = exportTemplatesHash;
        }
      );
    };

  godotPackages_4_3 = mkGodotPackages "4.3";
  godotPackages_4_4 = mkGodotPackages "4.4";
  godotPackages_4 = godotPackages_4_4;
  godotPackages = godotPackages_4;
in
{
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

  godot_4_3 = godotPackages_4_3.godot;
  godot_4_3-mono = godotPackages_4_3.godot-mono;
  godot_4_3-export-templates = godotPackages_4_3.export-templates-bin;
  godot_4_4 = godotPackages_4_4.godot;
  godot_4_4-mono = godotPackages_4_4.godot-mono;
  godot_4_4-export-templates = godotPackages_4_4.export-templates-bin;
  godot_4 = godotPackages_4.godot;
  godot_4-mono = godotPackages_4.godot-mono;
  godot_4-export-templates = godotPackages_4.export-templates-bin;
  godot = godotPackages.godot;
  godot-mono = godotPackages.godot-mono;
  godot-export-templates = godotPackages.export-templates-bin;
}
