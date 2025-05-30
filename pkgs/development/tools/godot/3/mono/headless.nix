{ godot3-mono }:

godot3-mono.overrideAttrs (
  self: base: {
    pname = "godot3-mono-headless";
    godotBuildDescription = "mono headless";
    godotBuildPlatform = "server";
  }
)
