{ lib
, callPackage
}:

{
  owner = "minecraft-linux";

  version = "0.9.0";

  nlohmann_json_373 = callPackage ./nlohmann_json_373_dep.nix { };

  description = "Unofficial launcher for the Android version of Minecraft: Bedrock Edition";

  homepage = "https://mcpelauncher.readthedocs.io";

  maintainers = with lib.maintainers; [ aleksana ];

  platforms = lib.platforms.unix;
}
