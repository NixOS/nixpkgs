{ godot3-mono-headless }:

godot3-mono-headless.overrideAttrs (self: base: {
  pname = "godot3-mono-debug-server";
  godotBuildDescription = "mono debug server";
  shouldBuildTools = false;
})
