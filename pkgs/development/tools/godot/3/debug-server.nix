{ godot3-headless }:

godot3-headless.overrideAttrs (self: base: {
  pname = "godot3-debug-server";
  godotBuildDescription = "debug server";
  shouldBuildTools = false;
})
