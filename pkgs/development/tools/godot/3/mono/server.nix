{ godot3-mono-debug-server }:

godot3-mono-debug-server.overrideAttrs (self: base: {
  pname = "godot3-mono-server";
  godotBuildDescription = "mono server";
  godotBuildTarget = "release";
})
