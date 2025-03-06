{ callPackage }: {
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

  godot_4 = callPackage ./4/default.nix {};
  godot_4-mono = callPackage ./4/mono.nix {};
  godot_4-export-templates = callPackage ./4/export-templates.nix {};
}
