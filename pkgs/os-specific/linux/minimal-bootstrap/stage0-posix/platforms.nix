# Platform specific constants
{
  lib,
  hostPlatform,
}:

rec {
  # meta.platforms
  platforms = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];

  # system arch as used within the stage0 project
  stage0Arch =
    {
      "aarch64-linux" = "AArch64";
      "i686-linux" = "x86";
      "x86_64-linux" = "AMD64";
    }
    .${hostPlatform.system} or (throw "Unsupported system: ${hostPlatform.system}");

  # lower-case form is widely used by m2libc
  m2libcArch = lib.toLower stage0Arch;

  # Passed to M2-Mesoplanet as --operating-system
  m2libcOS =
    if hostPlatform.isLinux then "linux" else throw "Unsupported system: ${hostPlatform.system}";

  baseAddress =
    {
      "aarch64-linux" = "0x00600000";
      "i686-linux" = "0x08048000";
      "x86_64-linux" = "0x00600000";
    }
    .${hostPlatform.system} or (throw "Unsupported system: ${hostPlatform.system}");
}
