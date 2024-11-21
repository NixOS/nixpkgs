{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dottrace";
  version = "2024.3";
  desktopName = "dotTrace";
  code = "DP";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotTrace.linux-x64.2024.3.tar.gz";
      hash = "sha256-0Y9xdATsTDaXbn/6LLxP0qYwW+Ibnb9J0OW5pwHKP1Q=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotTrace.linux-arm64.2024.3.tar.gz";
      hash = "sha256-xnCp/yNwu3ooj9gbn5RMOH4cBpCIYP7MF9phJOu6Py0=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotTrace.macos-x64.2024.3.dmg";
      hash = "sha256-0NEnTYL1NbjhUBCmSQecSjJ17Q/lvMZ8jbR8NNp09tk=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3/JetBrains.dotTrace.macos-arm64.2024.3.dmg";
      hash = "sha256-A2XIBX/MTcHhPXW4xmwuXg0gKoe7RuB4XP6qjofKa8g=";
    };
  };

  iconHolder = "JetBrains.dotTrace.Home.Shell.exe";

  executables = [
    "dotTrace"
    "dotTraceViewer"
  ];

  meta = {
    homepage = "https://www.jetbrains.com/profiler";
    description = ".NET Performance Profiler";
    maintainers = with lib.maintainers; [ js6pak ];
  };
}
