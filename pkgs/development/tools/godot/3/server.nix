{ godot3-debug-server }:

godot3-debug-server.overrideAttrs (
  self: base: {
    pname = "godot3-server";
    godotBuildDescription = "server";
    godotBuildTarget = "release";
  }
)
