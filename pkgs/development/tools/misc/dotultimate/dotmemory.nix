{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dotmemory";
  version = "2024.2.6";
  desktopName = "dotMemory";
  code = "DM";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotMemory.linux-x64.2024.2.6.tar.gz";
      sha256 = "e34a560cc96b170291c151b5d825fec7302608aeef2362757e2a2e97c4f73a5a";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotMemory.linux-arm64.2024.2.6.tar.gz";
      sha256 = "88908b1ce92bb7d9a87871bf89440acacb3ca43a288906ea1048a70d3acdd9a6";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotMemory.macos-x64.2024.2.6.dmg";
      sha256 = "27d88456d7ffa4936b8cf6a20d41442483f5b356784c28cf7a5bfd7319d23e88";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotMemory.macos-arm64.2024.2.6.dmg";
      sha256 = "8ec4fe36a4948ee8c9cf4e6d98268a8b4e116cbf61ff9ca6d68e3b3495dc910e";
    };
  };

  iconHolder = "JetBrains.dotMemory.Standalone.Avalonia.exe";

  meta = with lib; {
    homepage = "https://www.jetbrains.com/dotmemory";
    description = "The .NET Memory Profiler";
    maintainers = with maintainers; [ js6pak ];
  };
}
