{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-biFiDQNDbPtqWHMi0JkuYGaX+Y9aNoXdYd+WwILJ3lo=";
    linux_arm64 = "sha256-KmG2hHiR7aKDS2qJ/fN8T3pppt6wNaVp4ZGaanxqPYU=";
    darwin_x64 = "sha256-buDJ2OnjjYSZi/vwPL35TYTYdJq7Xg9VckCP/DSpNEU=";
    darwin_arm64 = "sha256-CDuajhnC/KdyCqtHmqV1oXmXmqU6RksQc/VVJtc0p10=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
