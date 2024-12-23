{
  lib,
  mkJetBrainsAvaloniaProduct,
}:
mkJetBrainsAvaloniaProduct {
  pname = "dottrace";
  version = "2024.3.2";
  desktopName = "dotTrace";
  code = "DP";

  sources = {
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotTrace.linux-x64.2024.3.2.tar.gz";
      hash = "sha256-8Vf6SE86BrhU3i6ovaV7Ju6cQYRBaVIx+5GOSvSKPWE=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotTrace.linux-arm64.2024.3.2.tar.gz";
      hash = "sha256-RpQM+oHHHW00w0UgKd6ktUG5dJadfIBrxTDmVWzDj7o=";
    };

    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotTrace.macos-x64.2024.3.2.dmg";
      hash = "sha256-N/4G27a4Xyz0NwvrsXfQc4eV2xcH+Mpx6kyLgdyxDiI=";
    };
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/resharper/dotUltimate.2024.3.2/JetBrains.dotTrace.macos-arm64.2024.3.2.dmg";
      hash = "sha256-zcJvpKfa4oji5sLMkWjHFXK4CE1E7pbWoQqyGkGjkLs=";
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
