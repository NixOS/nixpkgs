{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-Vk0KyrugzVF5WTezu0MJc8pe1HHkpd2g91UkPQCbyjQ=";
    linux_arm64 = "sha256-ohUB4P0wftURBRNngYo8fs2jMgyxhIraAwWUXlvMYc4=";
    darwin_x64 = "sha256-jpiKm5ffCZRU9Gn2XsHg75PI1CkJSddta6TzS16mfbg=";
    darwin_arm64 = "sha256-DCK+ShzOUUkc76F3V66rHN658yqvuxSNUSl8fkfx3mc=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
