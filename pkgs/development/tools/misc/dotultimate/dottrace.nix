{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dottrace";
  version = "2024.2.6";
  desktopName = "dotTrace";
  code = "DP";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotTrace.linux-x64.2024.2.6.tar.gz";
      sha256 = "533eda879f87622d72332e3451f1a75c184ddf0a9d9f21ff4a8595c64d7a975d";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotTrace.linux-arm64.2024.2.6.tar.gz";
      sha256 = "41c29256f81c6fef84fb232f18d17020b59f4a2ae7ae388da307070c4c8c921d";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotTrace.macos-x64.2024.2.6.dmg";
      sha256 = "9b6ad1fc31c425b83bc0680ba9524e67f477553a61b365aa1f4394673d32e5c9";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.2.6/JetBrains.dotTrace.macos-arm64.2024.2.6.dmg";
      sha256 = "fbd0818ccb6061f50c0e7dc72ce87fcbb613dc586ee506dc405ccc767c685fbc";
    };
  };

  iconHolder = "JetBrains.dotTrace.Home.Shell.exe";

  executables = [
    "dotTrace"
    "dotTraceViewer"
  ];

  meta = with lib; {
    homepage = "https://www.jetbrains.com/profiler";
    description = ".NET Performance Profiler";
    maintainers = with maintainers; [ js6pak ];
  };
}
