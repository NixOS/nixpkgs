{ godot3 }:

godot3.overrideAttrs (self: base: {
  pname = "godot3-headless";
  godotBuildDescription = "headless";
  godotBuildPlatform = "server";
})
