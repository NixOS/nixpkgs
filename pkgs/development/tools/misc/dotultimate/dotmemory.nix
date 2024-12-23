{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dotmemory";
  version = "2024.3.2";
  desktopName = "dotMemory";
  code = "DM";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotMemory.linux-x64.2024.3.2.tar.gz";
      hash = "sha256-tj42kOmzGZYJW2QI0tcxYmr7mQBbkbbqU93G6nDaJ0Q=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotMemory.linux-arm64.2024.3.2.tar.gz";
      hash = "sha256-fOqF/4GdLA5g+Fs3BYlO6GyIiF4eiZIL13PYQyCSlpc=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotMemory.macos-x64.2024.3.2.dmg";
      hash = "sha256-jKY2mnFiCbNFQrzgkof3aQMOLcxAC7uoYpRaHZcC5Jg=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotMemory.macos-arm64.2024.3.2.dmg";
      hash = "sha256-Pzghdi6gfWGWlo/mhC+BKdMXwlX9AG/jJRdduRXOaBo=";
    };
  };

  iconHolder = "JetBrains.dotMemory.Standalone.Avalonia.exe";

  meta = {
    homepage = "https://www.jetbrains.com/dotmemory";
    description = ".NET Memory Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
