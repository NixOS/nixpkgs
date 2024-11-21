{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dotmemory";
  version = "2024.3";
  desktopName = "dotMemory";
  code = "DM";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotMemory.linux-x64.2024.3.tar.gz";
      hash = "sha256-fxGNnTAp9VmALN9NQ65B+dVsK+wKyBM5el4Ui3ve77U=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotMemory.linux-arm64.2024.3.tar.gz";
      hash = "sha256-+4bvYkPVtQsyPz6wsmaNWenswlOueZeg7EumFfQF1WE=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotMemory.macos-x64.2024.3.dmg";
      hash = "sha256-NipdU191BSMIMwiu4kM1Og9wJJbZy7e0wNqUiggrrq4=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotMemory.macos-arm64.2024.3.dmg";
      hash = "sha256-LmPNvsZMRCtWCXMqsXDuEqAJ5rcIEet4v2SikKcQQOg=";
    };
  };

  iconHolder = "JetBrains.dotMemory.Standalone.Avalonia.exe";

  meta = {
    homepage = "https://www.jetbrains.com/dotmemory";
    description = ".NET Memory Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
